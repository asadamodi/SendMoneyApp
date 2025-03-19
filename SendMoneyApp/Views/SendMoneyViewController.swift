//
//  SendMoneyViewController.swift
//  SendMoneyApp
//
//  Created by Asad on 17/03/25.
//

import ReSwift
import UIKit
import SnapKit
import iOSDropDown

class SendMoneyViewController: UIViewController, StoreSubscriber {
    private let tableView = UITableView()
    private let viewModel = ServiceViewModel()
    private let sendButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupSendButton()
        
        // Subscribe to Redux state updates
        store.subscribe(self)
    }
    
    deinit {
        store.unsubscribe(self)
    }
    
    func newState(state: SendMoneyState) {
        tableView.reloadSections(IndexSet([1, 2]), with: .automatic)
    }
    
    func setupUI(){
        view.backgroundColor = UIColor.systemGray6
        navigationItem.title = "Send Money App"
        navigationController?.navigationBar.backgroundColor = UIColor.gray
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.gray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.isTranslucent = false
        
        addBackButton()
        
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80) // Adjusting for send button
        }
        
        tableView.register(SendMoneyTableViewCell.self, forCellReuseIdentifier: SendMoneyTableViewCell.identifier)
        tableView.register(UINib(nibName: SendMoneyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SendMoneyTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight =  UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
    }
    
    private func setupSendButton() {
        view.addSubview(sendButton)
        sendButton.setTitle("Send", for: .normal)
        sendButton.backgroundColor = UIColor.systemBlue
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.layer.cornerRadius = 8
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        sendButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @objc private func sendButtonTapped() {
        view.endEditing(true)
        var alertMessage = ""
        
        let requiredFields = viewModel.getRequiredFields()
        for field in requiredFields {
            let fieldName = field.label["en"] ?? "Unknown Field"
            let fieldValue = store.state.fieldValues[field.name] ?? ""
            
            if fieldValue.isEmpty {
                let errorMessage: String
                if let validationError = field.validationErrorMessage {
                    switch validationError {
                    case .string(let message):
                        errorMessage = message
                    case .dictionary(let messages):
                        errorMessage = messages["en"] ?? "Invalid input for \(fieldName)"
                    }
                } else {
                    errorMessage = "Please enter value for: \(fieldName)"
                }
                alertMessage += "\(errorMessage)\n"
            }
        }
        
        if !alertMessage.isEmpty {
            showErrorAlert(title: "Validation Errors", message: alertMessage)
        }
    }
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let fieldName = viewModel.getRequiredFields()[textField.tag].name
        store.dispatch(UpdateFieldValueAction(fieldName: fieldName, value: textField.text ?? ""))
    }
}

extension SendMoneyViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            let provider = viewModel.getProviders()
            return provider?[store.state.selectedProviderIndex].requiredFields.count ?? 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SendMoneyTableViewCell.identifier) as? SendMoneyTableViewCell else {
            return UITableViewCell()
        }
        cell.valueTextField.text = ""
        
        if indexPath.section == 0 {
            cell.valueTextField.optionArray = viewModel.getServices()
            cell.configure(placeholder: "Service", value: viewModel.getSelectedService())
            cell.valueTextField.didSelect { [weak self] selectedText, index, id in
                store.dispatch(SelectServiceAction(index: index))
                self?.tableView.reloadSections(IndexSet([2]), with: .automatic)
            }
        } else if indexPath.section == 1 {
            cell.configure(placeholder: "Provider", value: viewModel.getSelectedProvider())
            cell.valueTextField.optionArray = viewModel.getProvidersNames()
            cell.valueTextField.didSelect { [weak self] selectedText, index, id in
                store.dispatch(SelectProviderAction(index: index))
                self?.tableView.reloadSections(IndexSet([2]), with: .automatic)
            }
        } else {
            let reqField = viewModel.getRequiredFields()[indexPath.row]
            cell.placeholderLabel.text = reqField.label["en"]
            cell.valueTextField.text = store.state.fieldValues[reqField.name]
            cell.valueTextField.optionArray = []
            cell.valueTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
            cell.valueTextField.tag = indexPath.row
            
        }
        return cell
    }
}
extension SendMoneyViewController:UITableViewDelegate{}
