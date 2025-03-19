//
//  Extensions.swift
//  SendMoneyApp
//
//  Created by Asad on 19/03/25.
//

import Foundation
import UIKit
extension UIViewController {
     func showErrorAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func addBackButton(){
        let backButton = UIBarButtonItem(image: UIImage(systemName: "lessthan"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
    }
    @objc private func backButtonTapped() {
           navigationController?.popViewController(animated: true)
       }
}
