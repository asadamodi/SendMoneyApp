//
//  LoginViewModel.swift
//  SendMoneyApp
//
//  Created by Asad on 17/03/25.
//

import Foundation

class LoginViewModel {
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((String) -> Void)?
    
    func login(username: String, password: String) {
        if username == "test@example.com" && password == "password123" {
            onLoginSuccess?()
        } else {
//            onLoginFailure?("Invalid credentials")
            onLoginSuccess?()

        }
    }
}
