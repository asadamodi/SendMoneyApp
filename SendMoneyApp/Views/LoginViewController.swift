//
//  LoginViewController.swift
//  SendMoneyApp
//
//  Created by Asad on 17/03/25.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    // MARK: - UI Elements
    private let viewModel = LoginViewModel()

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let footerLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModelBindings()

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGray6
        navigationItem.title = "Sign in"
        
        // Title Label
        titleLabel.text = "SEND MONEY APP"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        
        // Subtitle Label
        subtitleLabel.text = "Welcome to Send Money App!"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = .darkGray
        subtitleLabel.textAlignment = .center
        
        // Email TextField
        emailTextField.placeholder = "Email*"
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        
        // Password TextField
        passwordTextField.placeholder = "Password*"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        // Login Button
        loginButton.setTitle("Sign in", for: .normal)
        loginButton.backgroundColor = .darkGray
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 25
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        // Footer Label
        footerLabel.text = "By proceeding you also agree to the Terms of Service and Privacy Policy"
        footerLabel.font = UIFont.systemFont(ofSize: 12)
        footerLabel.textColor = .gray
        footerLabel.textAlignment = .center
        footerLabel.numberOfLines = 0
        
        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(footerLabel)
        
        // Apply SnapKit Constraints
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(100)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(44)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(100)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        footerLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.leading.trailing.equalToSuperview().inset(40)
        }
    }
    
    // MARK: - Actions
    
    @objc private func handleLogin() {
        
        
        let username = emailTextField.text!
        let password = passwordTextField.text!
        viewModel.login(username: username, password: password)

        
    }
    
    private func setupViewModelBindings() {
        viewModel.onLoginSuccess = { [weak self] in
            DispatchQueue.main.async {
                let sendMoneyVC = SendMoneyViewController()
                self?.navigationController?.pushViewController(sendMoneyVC, animated: true)
            }
        }
        
        viewModel.onLoginFailure = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showErrorAlert(title: "Error", message: "Invalid email or password")
            }
        }
    }

}
