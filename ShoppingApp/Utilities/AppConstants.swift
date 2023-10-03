//
//  AppConstants.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 30.09.2023.
//

import Foundation

struct AppConstants {
    
    static let defaultStockAmount = 4 
    
    struct Currency {
        
        static let currency: Currency = .turkishLira
        
        enum Currency: String {
            case dollar = "$"
            case turkishLira = "TL"
            
            func getPriceString(price: String) -> String {
                switch self {
                case .dollar:
                    return "$ \(price)"
                case .turkishLira:
                    return "\(price) TL"
                }
            }
        }
    }

}
