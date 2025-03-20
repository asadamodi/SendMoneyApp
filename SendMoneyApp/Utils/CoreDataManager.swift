//
//  CoreDataManager.swift
//  SendMoneyApp
//
//  Created by Asad on 20/03/25.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "SendMoneyApp")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save Core Data: \(error)")
            }
        }
    }

    func createTransaction(serviceName: String, providerName: String,amount:Double,providerId:String,reqFields:[String:String]) {

        let transaction = Transaction(context: context)
        transaction.id = UUID()
        transaction.serviceName = serviceName
        transaction.providerName = providerName
        transaction.amount = amount
        transaction.providerId = providerId
        transaction.date = Date()
        transaction.providerToFields = NSSet(array: createRequiredFieldsList(reqFields: reqFields, transaction: transaction))
        saveContext()
    }
    private func createRequiredFieldsList(reqFields:[String:String],transaction:Transaction)->[ProviderRequiredFields]{
        var reqFieldsCoreData = [ProviderRequiredFields]()
        for _ in reqFields{
            let requiredField = ProviderRequiredFields(context: context)
            requiredField.key = reqFields["key"]
            requiredField.value = reqFields["value"]
            requiredField.fieldsToProvider = transaction
            reqFieldsCoreData.append(requiredField)
        }
        return reqFieldsCoreData
    }
    func fetchTransactions() -> [Transaction] {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch transactions: \(error)")
            return []
        }
    
    }
}
