//
//  ProfileEnum.swift
//  Snapheal
//
//  Created by Khánh Vũ on 3/11/24.
//

import Foundation
import UIKit

extension DoctorProfileViewController {
    enum ProfileSection {
        case avatar
        case info
        case payment
        case logout
        
        var items: [ProfileRow] {
            switch self {
            case .avatar: [.avatar]
            case .info: [.name, .phone, .major]
            case .payment: [.paymentMethod]
            case .logout: [.signOut]
            }
        }
        
        var headerTitle: String? {
            switch self {
            case .info: "Giới thiệu"
            case .payment: "Phương thức thanh toán"
            default: nil
            }
        }
        
        var headerHeight: CGFloat {
            switch self {
            case .avatar: .leastNormalMagnitude
            default: 30
            }
        }
    }
    
    enum ProfileRow {
        case avatar
        case name, phone, major
        case paymentMethod
        case signOut
        
        var title: String? {
            switch self {
            case .name: Global.role == .doctor ? Global.doctor?.getFullName() : Global.patient?.getFullName()
            case .phone: Global.role == .doctor ? Global.doctor?.phoneNumber : Global.patient?.phoneNumber
            case .major: "Bác sĩ chuyên khoa " + (Global.doctor?.major ?? "")
            case .paymentMethod: "Zalo pay: " + (Global.doctor?.phoneNumber ?? "")
            case .signOut: "Đăng xuất"
            default: nil
            }
        }
    }
}
