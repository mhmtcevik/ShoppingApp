//
//  LoginService.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 1.10.2023.
//

import Foundation
import Alamofire

protocol ILoginService {
    var currentUserToken: Token? { get }
    
    func userLogin(email: String, password: String, result: @escaping (Bool) -> Void)
}

class LoginService: ILoginService {
    
    var currentUserToken: Token?
    
    static let host = "api.escuelajs.co"
    
    func userLogin(email: String, password: String, result: @escaping (Bool) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = LoginService.host
        urlComponents.path = StoreServiceEndPoint.loginPath.rawValue
        
        guard let url = urlComponents.url else {
            result(false)
            return
        }
        
        let userData: [String : Any] = [
            "email" : email,
            "password" : password
        ]
        
        AF.request(
            url,
            method: .post,
            parameters: userData,
            encoding: JSONEncoding.default).responseDecodable(of: Token.self) { response in
                
            guard
                let token = response.value
            else {
                result(false)
                return
            }
                
            self.currentUserToken = token
            result(true)
        }
    }
    
    
}
