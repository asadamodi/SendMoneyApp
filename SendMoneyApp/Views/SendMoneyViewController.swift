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
import Localize_Swift

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
        navigationItem.rightBarButtonItem?.title = state.selectedLanguage == .ar ? "English" : "عربي"
        
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
        // Add language switch button
        let languageButton = UIBarButtonItem(title:store.state.selectedLanguage == .ar ? "English" : "عربي" , style: .plain, target: self, action: #selector(switchLanguageTapped))
        languageButton.tintColor = .white
        navigationItem.rightBarButtonItem = languageButton
    }
    @objc private func switchLanguageTapped(sender:UIBarButtonItem) {
        //TODO: Need to add LanguageManager and make changes to app level
        let newLanguage: Language = store.state.selectedLanguage == .en ? .ar : .en
        store.dispatch(SelectedLanguageAction(selectedLanguage: newLanguage))
        Localize.setCurrentLanguage((newLanguage == .ar) ? "ar" : "en")
        // Adjust UI direction
        let semanticAttribute: UISemanticContentAttribute = (newLanguage == .ar) ? .forceRightToLeft : .forceLeftToRight
        UIView.appearance().semanticContentAttribute = semanticAttribute
        UINavigationBar.appearance().semanticContentAttribute = semanticAttribute
        UITableView.appearance().semanticContentAttribute = semanticAttribute
        UILabel.appearance().semanticContentAttribute = semanticAttribute
        UITextField.appearance().semanticContentAttribute = semanticAttribute
        
        // Apply changes and reload UI
        view.setNeedsLayout()
        navigationController?.navigationBar.setNeedsLayout()
        tableView.reloadData()
        
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
    //TODO: Save logic pending
    @objc private func sendButtonTapped() {
        view.endEditing(true)
//        let alertMessage = viewModel.validateInputs()
//        if !alertMessage.isEmpty {
//            showErrorAlert(title: "Validation Errors", message: alertMessage)
//        }
        
        viewModel.addTransaction()
        navigationController?.pushViewController(TransactionListViewController(), animated: true)
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
            cell.configure(placeholder: "Provider".localized(), value: viewModel.getSelectedProvider())
            cell.valueTextField.optionArray = viewModel.getProvidersNames()
            cell.valueTextField.didSelect { [weak self] selectedText, index, id in
                store.dispatch(SelectProviderAction(index: index))
                self?.tableView.reloadSections(IndexSet([2]), with: .automatic)
            }
        } else {
            let reqField = viewModel.getRequiredFields()[indexPath.row]
            cell.placeholderLabel.text = reqField.label["en"]
            cell.valueTextField.text = store.state.fieldValues[reqField.name]
            cell.valueTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
            cell.valueTextField.tag = indexPath.row
            if(reqField.type == "option"){
                cell.valueTextField.optionArray = reqField.options?.compactMap{$0.label} ?? []
                cell.valueTextField.didSelect { [weak self] selectedText, index, id in
                    cell.valueTextField.text = selectedText
                    self?.textFieldDidChange(cell.valueTextField)
                }
            }
            else {
                cell.valueTextField.optionArray = []
            }
           
            
        }
        return cell
    }
}
extension SendMoneyViewController:UITableViewDelegate{}
