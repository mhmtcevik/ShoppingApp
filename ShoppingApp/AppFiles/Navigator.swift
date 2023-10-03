//
//  Navigator.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 30.09.2023.
//

import UIKit

protocol Navigatable {
    var navigator: Navigator { get set}
}

class Navigator {
    
    enum Scene {
        case signIn(viewModel: SignInViewModel)
        case home(viewModel: HomeViewModel)
        case basket(viewModel: BasketViewModel)
        case result(viewModel: ResultViewModel)
    }
    
    enum Transition {
        case navigation
        case present
    }
    
    private func get(segue: Scene) -> UIViewController? {
        switch segue {
        case .signIn(let viewModel):
            let vc = SignInViewController(viewModel: viewModel, navigator: self)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            
            return vc
        case .home(let viewModel):
            let vc = HomeViewController(viewModel: viewModel, navigator: self)
            let nc = UINavigationController(rootViewController: vc)
            nc.modalTransitionStyle = .crossDissolve
            nc.modalPresentationStyle = .overFullScreen
            
            return nc
        case .basket(let viewModel):
            let vc = BasketViewController(viewModel: viewModel, navigator: self)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            
            return vc
        case .result(let viewModel):
            let vc = ResultViewController(viewModel: viewModel, navigator: self)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            
            return vc
        }
    }
    
    func pop(sender: UIViewController?, toRoot: Bool = false) {
        if toRoot {
            sender?.navigationController?.popToRootViewController(animated: true)
        } else {
            sender?.navigationController?.popViewController(animated: true)
        }
    }
    
    func dismiss(sender: UIViewController?) {
        sender?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func show(segue: Scene, sender: UIViewController?, transition: Transition) {
        if let target = get(segue: segue) {
            show(target: target, sender: sender, transition: transition)
        }
    }
    
    private func show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        switch transition {
        case .navigation:
            if let nav = sender?.navigationController {
                // push root controller on navigation stack
                nav.pushViewController(target, animated: false)
                return
            }
        case .present:
            DispatchQueue.main.async {
                sender?.present(target, animated: true, completion: nil)
            }
        }
    }
    
}
