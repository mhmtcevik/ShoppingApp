//
//  ResultController.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 30.09.2023.
//

import UIKit

protocol IResultController {
    var navigator: Navigator { get set }
    var viewModel: ResultViewModel { get set }
    
    func goRoot()
}

class ResultViewController: UIViewController, Navigatable, IResultController {
    
    private let successImageView = UIImageView()
    private let successLabel = UILabel()
    
    var navigator: Navigator
    var viewModel: ResultViewModel
    
    init(viewModel: ResultViewModel, navigator: Navigator) {
        self.viewModel = viewModel
        self.navigator = navigator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        viewModel.controllerDelegate(controller: self)
        viewModel.viewDidLoad()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(successImageView)
        
        successImageView.image = UIImage.paymentSuccsessIcon
        successImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        
        view.addSubview(successLabel)
        
        successLabel.text = "Purchase successful"
        successLabel.font = .systemFont(ofSize: 25)
        successLabel.textColor = .black.withAlphaComponent(0.5)
        
        successLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(successImageView.snp.bottom).offset(20)
        }
    }
    
    func goRoot() {
        self.viewModel.resetSaveData(completion: { [weak self] in
            self?.navigator.pop(sender: self, toRoot: true)
        })
    }

}
