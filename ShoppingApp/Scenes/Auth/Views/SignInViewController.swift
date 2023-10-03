//
//  AuthController.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 29.09.2023.
//

import UIKit
import SnapKit
import PKHUD

protocol ISignInController {
    var viewModel: SignInViewModel { get }
    
    func userLoginFinished(_ result: Bool)
    func loadLoadingStatus(isLoading: Bool)
}

final class SignInViewController: UIViewController, Navigatable {
    
    let signLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.text = "Sign In"
        label.textColor = .black
        return label
    }()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let accountlabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to ShoppingApp"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let bodyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email address"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let forgotButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        return button
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Protected by reCAPTCHA and subject to the Prism Privacy Policy and Terms of Service."
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.numberOfLines = .max
        label.textAlignment = .center
        return label
    }()
    
    var viewModel: SignInViewModel
    var navigator: Navigator
    
    init(viewModel: SignInViewModel, navigator: Navigator) {
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
        configureConstraints()
        setupActions()
        
        viewModel.controllerDelegate(controller: self)
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        configureViews()
    }
    
    func configureViews() {
        view.addSubview(signLabel)
        
        view.addSubview(topStackView)
        topStackView.addArrangedSubview(accountlabel)
        
        view.addSubview(bodyStackView)
        bodyStackView.addArrangedSubview(emailTextField)
        bodyStackView.addArrangedSubview(passwordTextField)
        
        view.addSubview(forgotButton)
        view.addSubview(subtitleLabel)
        view.addSubview(signInButton)
    }
    
    func configureConstraints() {
        signLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
        }
        
        topStackView.snp.makeConstraints { make in
            make.leading.equalTo(signLabel)
            make.top.equalTo(signLabel.snp.bottom).offset(12)
        }
        
        bodyStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(topStackView.snp.bottom).offset(24)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        forgotButton.snp.makeConstraints { make in
            make.leading.equalTo(bodyStackView)
            make.top.equalTo(bodyStackView.snp.bottom).offset(24)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.trailing.equalToSuperview().offset(-50)
            make.leading.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().offset(-80)
        }
    }
    
    func setupActions() {
        signInButton.addTarget(self, action: #selector(loginButtonDidtapped), for: .touchUpInside)
    }
    
    @objc
    func loginButtonDidtapped() {
        if let email = emailTextField.text,
           let password = passwordTextField.text {
            viewModel.userLogin(email: email, password: password)
        } else {
            HUD.flash(.label("Please check the entered data"), delay: 1)
            return
        }
    }
    
}

extension SignInViewController: ISignInController {
    func loadLoadingStatus(isLoading: Bool) {
        isLoading ? HUD.show(.progress) : HUD.hide()
    }
    
    
    func userLoginFinished(_ result: Bool) {
        if result {
            navigator.show(segue: .home(viewModel: HomeViewModel()), sender: self, transition: .present)
        } else {
            HUD.flash(.label("Please check the entered data"), delay: 1)
            return
        }
    }
    
}
