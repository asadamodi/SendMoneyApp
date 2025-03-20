//
//  TransactionTableViewCell.swift
//  SendMoneyApp
//
//  Created by Asad on 20/03/25.
//

import Foundation
import UIKit
import SnapKit

class TransactionTableViewCell: UITableViewCell {
    private let serviceLabel = UILabel()
    private let providerLabel = UILabel()
    private let dateLabel = UILabel()
    static let identifier = "TransactionTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [serviceLabel, providerLabel, dateLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }

    func configure(with transaction: Transaction) {
        serviceLabel.text = "Service: \(transaction.serviceName ?? "")"
        providerLabel.text = "Provider: \(transaction.providerName ?? "")"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateLabel.text = "Date: \(dateFormatter.string(from: transaction.date ?? Date()))"
    }
}
