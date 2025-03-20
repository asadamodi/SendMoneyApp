//
//  File.swift
//  SendMoneyApp
//
//  Created by Asad on 20/03/25.
//

import Foundation
import UIKit

class TransactionDetailViewController: UIViewController {
    private let transaction: Transaction

    init(transaction: Transaction) {
        self.transaction = transaction
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Transaction Details"

        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = """
        Service: \(transaction.serviceName ?? "")
        Provider: \(transaction.providerName ?? "")
        Date: \(transaction.date ?? Date())
        """

        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
