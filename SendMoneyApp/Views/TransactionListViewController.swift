//
//  TransactionListViewController.swift
//  SendMoneyApp
//
//  Created by Asad on 20/03/25.
//


import UIKit
import SnapKit
import ReSwift
import CoreData

class TransactionListViewController: UIViewController, StoreSubscriber {
    private var tableView: UITableView!
    private let viewModel = TransactionViewModel()
    private var transactions: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        store.subscribe(self)
        viewModel.fetchTransactions()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

    func newState(state: SendMoneyState) {
        transactions = state.fetchedTransactions
        tableView.reloadData()
    }

    private func setupUI() {
        title = "Transactions"
        view.backgroundColor = .white

        // Table View
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.identifier)
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-60) // Space for button
        }

        // Add Transaction Button
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add Transaction", for: .normal)
        addButton.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
        view.addSubview(addButton)

        addButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
    }

    @objc private func addTransaction() {
    }
}

extension TransactionListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        cell.configure(with: transactions[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = transactions[indexPath.row]
        let detailVC = TransactionDetailViewController(transaction: transaction)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
