//
//  StoreService.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 30.09.2023.
//

import Foundation
import Alamofire

protocol IStoreService {
    func fetchProductsData(result: @escaping ([Product]?) -> Void)
    func fetchCategoriesData(result: @escaping ([Category]?) -> Void)
}

struct StoreService: IStoreService {
    
    static let host = "api.escuelajs.co"
    
    func fetchProductsData(result: @escaping ([Product]?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = StoreService.host
        urlComponents.path = StoreServiceEndPoint.productPath.rawValue
        
        guard let url = urlComponents.url?.absoluteString else { return }
        
        AF.request(url).responseDecodable(of: [Product].self) { response in
            guard
                let products = response.value
            else {
                result(nil)
                return
            }
            
            result(products)
        }
    }
    
    func fetchCategoriesData(result: @escaping ([Category]?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = StoreService.host
        urlComponents.path = StoreServiceEndPoint.categoryPath.rawValue
        
        guard let url = urlComponents.url else { return }
        
        AF.request(url).responseDecodable(of: [Category].self) { response in
            guard
                let categories = response.value
            else {
                result(nil)
                return
            }
            
            result(categories)
        }
    }
    
}
