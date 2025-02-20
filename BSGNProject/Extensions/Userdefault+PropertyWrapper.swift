//
//  Userdefault+PropertyWrapper.swift
//  AdmicroHybridEvent
//
//  Created by Khanh Vu on 26/9/24.
//

import Foundation

enum UserDefaultKey: String, CaseIterable {
    case patient
    case doctor
    case uid
    case role
    case isRequestLocationPermission
}


@propertyWrapper
struct UserDefault<T> {
    let key: UserDefaultKey
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key.rawValue) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
        }
    }
    
    init(_ key: UserDefaultKey, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

@propertyWrapper
struct NullableUserDefault<T> {
    let key: UserDefaultKey
    
    var wrappedValue: T? {
        get {
            UserDefaults.standard.object(forKey: key.rawValue) as? T
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
        }
    }
    
    init(_ key: UserDefaultKey) {
        self.key = key
    }
}

@propertyWrapper
struct ObjectUserDefault<T: Codable> {
    let key: UserDefaultKey
    
    var wrappedValue: T? {
        get {
            guard let data = UserDefaults.standard.data(forKey: key.rawValue) else {
                return nil
            }
            return try? JSONDecoder().decode(T.self, from: data)
        }
        set {
            if let newValue = newValue {
                // Encode object or array of objects
                if let encoded = try? JSONEncoder().encode(newValue) {
                    UserDefaults.standard.set(encoded, forKey: key.rawValue)
                }
            } else {
                // Remove the value if newValue is nil
                UserDefaults.standard.removeObject(forKey: key.rawValue)
            }
        }
    }
    
    init(_ key: UserDefaultKey) {
        self.key = key
    }
}

/// Example:
//@UserDefault(.token, defaultValue: "")
//var token: String

