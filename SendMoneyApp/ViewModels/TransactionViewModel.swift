//
//  TransactionViewModel.swift
//  SendMoneyApp
//
//  Created by Asad on 20/03/25.
//

import Foundation
import ReSwift
import CoreData

class TransactionViewModel {
    func fetchTransactions() {
        let transactions = CoreDataManager.shared.fetchTransactions()
        store.dispatch(TransactionAction.fetchedTransactions(transactions))
    }

    
}
