//
//  SignInViewModel.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 30.09.2023.
//

import Foundation

protocol ISignInViewModel {
    var loginService: LoginService { get set }
    var outputController: SignInViewController? { get }
    
    func controllerDelegate(controller: SignInViewController)
    func userLogin(email: String, password: String)
}

class SignInViewModel: ISignInViewModel {
    
    var loginService: LoginService
    var outputController: SignInViewController?
    
    private var loadingStatus = false
    
    
    init() {
        self.loginService = LoginService()
    }
    
    func controllerDelegate(controller: SignInViewController) {
        self.outputController = controller
    }
    
    func userLogin(email: String, password: String) {
        loadingStatus = true
        outputController?.loadLoadingStatus(isLoading: loadingStatus)
        
        loginService.userLogin(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            self.loadingStatus = false
            self.outputController?.loadLoadingStatus(isLoading: self.loadingStatus)
            self.outputController?.userLoginFinished(result)
        }
    }
    
}
