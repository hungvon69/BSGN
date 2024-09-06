//
//  DoctorViewModel.swift
//  BSGNProject
//
//  Created by Linh Thai on 16/08/2024.
//

import Foundation
import UIKit

class DoctorViewModel {
    var doctors: [Doctor] = []
    var listDoctor: [ListDoctor] = []
    
    var errorMessage: String?
    
    // Tạo một dictionary để lưu trữ ảnh của các doctor
    var doctorImages: [Int: UIImage] = [:]
    
    let homeService = HomeService()
    
}
