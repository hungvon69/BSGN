//
//  BaseService.swift
//  BSGNProject
//
//  Created by Linh Thai on 16/08/2024.
//

import Foundation
import Alamofire
import ObjectMapper

struct AppKey {
    static let authorization = "Authorization"
    static let contentType = "Content-Type"
    static let accept = "Accept"
    
    static let accessToken = "access_token"
    static let expiresIn = "expires_in"
}

struct AppError: Error {
    let code: Int
    let message: String
}

enum NetworkErrorType: Int, Error {
    case UNAUTHORIZED = 401
    case INVALID_TOKEN = 403
}

enum CFErrorCode: Int {
    case dataNull = -1
}

struct AnyDecodable: Codable {}

struct AnyMapple : Mappable {
    var value : DataAnyMapple?
    
    init?(map: ObjectMapper.Map) {
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        self.value <- map["data"]
    }
    
    init() {
        
    }
}

struct DataAnyMapple: Mappable {
    var status : Bool = false
    var statusMessage: String = ""
    var data: [String] = []
    
    init?(map: ObjectMapper.Map) {
        
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        self.status <- map["status"]
        self.statusMessage <- map["message"]
        self.data <- map["data"]
    }
}

private struct APIResponse<T: Decodable>: Decodable {
    var status: Int?
    var message: String?
    var errorCode: Int?
    var data: T?
    
    private enum CodingKeys: String, CodingKey {
        case errorCode = "code"
    }
}

class BaseService3 {
    
    let domainApi = "https://domain.com"
    private var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: AppKey.contentType, value: "application/json")
        headers.add(name: AppKey.accept, value: "application/json")
        return headers
    }
    
    private var alamofireManager: Alamofire.Session
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        alamofireManager = Alamofire.Session(configuration: configuration)
    }
    
    func request<T: Decodable>(_ path: String,
                               _ method: HTTPMethod,
                               parameters: Parameters? = nil,
                               of: T.Type,
                               encoding: ParameterEncoding = URLEncoding.default,
                               success: @escaping (T) -> Void,
                               failure: @escaping (_ code: Int, _ message: String) -> Void) {
            
        let domain = "\(domainApi)/api/"
        let url = path.starts(with: "http") ? path : "\(domain)\(path)"
        self.alamofireManager.request(url, method: method, parameters: parameters, encoding: encoding, headers: self.headers)
            .validate(statusCode: 200..<500)
            .validate(contentType: ["application/json", "application/xml"])
            .responseDecodable(of: APIResponse<T>.self) { response in
                switch response.result {
                case let .success(data):
                    if data.data != nil {
                        success(data.data!)
                    } else if response.response?.statusCode == 200 {
                        if let obj = AnyDecodable() as? T {
                            success(obj)
                        } else {
                            var code = _isOptional(T.self) ? CFErrorCode.dataNull.rawValue : 0
                            var message = ""
                            if let data = response.data {
                                do {
                                    if let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] {
                                        code = code == 0 ? (jsonData["error_code"] as? Int ?? code) : code
                                        message = jsonData["message"] as? String ?? ""
                                    }
                                } catch { }
                            }
                            failure(code, message)
                        }
                    } else if response.response?.statusCode == NetworkErrorType.UNAUTHORIZED.rawValue {
                        failure(-1, "You have no permission to access")
                    }  else {
                        var code = 0
                        var message = ""
                        if let data = response.data {
                            do {
                                if let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] {
                                    code = jsonData["error_code"] as? Int ?? 0
                                    message = jsonData["message"] as? String ?? ""
                                }
                            } catch { }
                        }
                        failure(code, message)
                    }
                case let .failure(error):
                    var code = error.responseCode ?? 0
                    var message = error.failureReason ?? ""
                    if let data = response.data {
                        do {
                            if let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] {
                                code = jsonData["error_code"] as? Int ?? code
                                message = jsonData["message"] as? String ?? ""
                            }
                        } catch { }
                    }
                    // TODO: Parse json fail
                    if code == 0, let _ = response.data {
                        //Log.d(response)
                    }
                    failure(code, message)
                }
            }
    }
    
    func requestHandleResponse<T: Mappable>(
                               _ path: String,
                               _ method: HTTPMethod,
                               parameters: Parameters? = nil,
                               extraHeader: HTTPHeaders? = nil,
                               of: T.Type,
                               encoding: ParameterEncoding = URLEncoding.default,
                               success: @escaping (T) -> Void,
                               failure: @escaping (_ code: Int, _ message: String) -> Void)
    {
        let domain = "\(domainApi)/api/"
        let url = path.starts(with: "http") ? path : "\(domain)\(path)"
        let headerRequest = (extraHeader == nil) ? self.headers : extraHeader
        
        var newParameters = [String : Any]()
        newParameters = parameters ?? ["":""]
        self.alamofireManager.request(url, method: method, parameters: newParameters, encoding: encoding, headers: headerRequest)
           .validate(statusCode: 200..<500)
           .validate(contentType: ["application/json", "application/xml"])
           .responseData(completionHandler: { response in
               switch response.result {
               case .success(let data):
                   do {
                       if let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String : Any],
                            let status = json["status"] as? Bool{
                           if status {
                               if let dataJson = json["data"] as? [String:Any] {
                                   if let results = T(JSON: dataJson) {
                                       success(results)
                                   }
                               }
                           }else{
                               if let message = json["message"] as? String, let code = json["error_code"] as? Int {
                                   failure(code,message)
                               }
                           }
                       }
                   } catch{
                       //print("-----API Request----: Error when parse data")
                       failure(-2, "Error when parse data")
                   }
               case .failure:
                   failure(-1, "Have something wrong when request data")
               }
           })
    }
    
    func requestBodyHandleResponse<T: Mappable>(
                               _ path: String,
                               _ method: HTTPMethod,
                               parameters: Parameters? = nil,
                               of: T.Type,
                               extraHeader: HTTPHeaders? = nil,
                               encoding: ParameterEncoding = URLEncoding.default,
                               success: @escaping (T) -> Void,
                               failure: @escaping (_ code: Int, _ message: String) -> Void)
    {
        let domain = "\(domainApi)/api/"
        let url = path.starts(with: "http") ? path : "\(domain)\(path)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                failure(-3, "Error encoding parameters")
            }
        }
        if let extraHeader = extraHeader {
            request.headers = extraHeader
        }else{
            request.headers = self.headers
        }
        
        self.alamofireManager.request(request)
            .validate(statusCode: 200..<500)
            .validate(contentType: ["application/json", "application/xml"])
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any],
                            let status = json["status"] as? Bool {
                            if status {
                                if let dataJson = json["data"] as? [String: Any] {
                                    if let results = T(JSON: dataJson) {
                                        success(results)
                                    }
                                }
                            } else {
                                if let message = json["message"] as? String, let code = json["error_code"] as? Int {
                                    failure(code, message)
                                }
                            }
                        }
                    } catch {
                        failure(-2, "Error parsing data")
                    }
                case .failure:
                    failure(-1, "Something went wrong with the request")
                }
            }
    }
    
    
    func requestPost<T: Decodable>(_ path: String,
                               _ method: HTTPMethod,
                               parameters: String? = nil,
                               of: T.Type,
                               encoding: ParameterEncoding = URLEncoding.default,
                               success: @escaping () -> Void,
                               failure: @escaping (_ code: Int, _ message: String) -> Void) {
        let domain = "\(domainApi)/api/"
        let url = path.starts(with: "http") ? path : "\(domain)\(path)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        request.httpBody = parameters?.data(using: .utf8)
        request.headers = self.headers
        AF.request(request).validate().responseData(completionHandler: { response in
            switch response.result {
            case .success(let data):
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String : Any], let dataStatus = json["status"] as? Bool  {
                        if dataStatus {
                            success()
                        } else {
                            failure(-1,"")
                        }
                    }
                } catch {
                    //print("-----API Request----: Error when parse data")
                    failure(-2, "Error when parse data")
                }
            case .failure:
                failure(-1, "Have something wrong when request data")
            }
            
        })
    }
    
    func requestUpload<T: Mappable>(
                        _ path: String,
                        _ method: HTTPMethod,
                        parameters: [String: String] = ["":""],
                        imageData: [String: Data]?,
                        extraHeader: HTTPHeaders? = nil,
                        of: T.Type,
                        mimeType: String? = nil,
                        success: @escaping (T) -> Void,
                        failure: @escaping (_ code: Int, _ message: String) -> Void)
    {
        let domain = "\(domainApi)/api/"
        let url = path.starts(with: "http") ? path : "\(domain)\(path)"
        var headers = HTTPHeaders()
        headers.add(name: AppKey.accept, value: "application/json")
        headers.add(name: AppKey.contentType, value: "multipart/form-data")
        
        self.alamofireManager.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data = imageData{
                let timestamp = NSDate().timeIntervalSince1970
                for (key, value) in data{
                    multipartFormData.append(value, withName: key, fileName: "file_\(timestamp).png", mimeType: "image/png")
                }
            }
        }, to: url, usingThreshold: UInt64.init(), method: method, headers: headers)
        .validate(statusCode: 200..<500)
        .responseData(completionHandler: { response in
            switch response.result {
            case .success(let data):
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String : Any],
                         let status = json["status"] as? Bool{
                        if status {
                            if let dataJson = json["data"] as? [String:Any] {
                                if let results = T(JSON: dataJson) {
                                    success(results)
                                }
                            }
                        }else{
                            if let message = json["message"] as? String, let code = json["error_code"] as? Int {
                                failure(code,message)
                            }
                        }
                    }
                } catch{
                    //print("-----API Request----: Error when parse data")
                    failure(-2, "Error when parse data")
                }
            case .failure:
                failure(-1, "Have something wrong when request data")
            }
        })
    }
    
}

