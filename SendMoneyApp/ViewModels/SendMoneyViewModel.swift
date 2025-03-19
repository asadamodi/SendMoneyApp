//
//  SendMoneyViewModel.swift
//  SendMoneyApp
//
//  Created by Asad on 17/03/25.
//

import Foundation
//import ReSwift

class ServiceViewModel {
    var services: [Service] = []
    var inputValues: [String: String] = [:] // Key: Field Name, Value: User Input

    init() {
        services = loadJSON() ?? []
    }

    func getProviders() -> [Provider]? {
        return  services[store.state.selectedServiceIndex].providers.compactMap{$0}
       
    }
    func getServices()->[String]{
        return services.compactMap{$0.label["en"] }
    }
    func getProvidersNames()->[String]{
        return  services[store.state.selectedServiceIndex].providers.compactMap{$0.name}
    }
    func getRequiredFields()->[RequiredField]{
        return services[store.state.selectedServiceIndex].providers[store.state.selectedProviderIndex].requiredFields
    }
    func getSelectedService()->String?{
        services[store.state.selectedServiceIndex].label["en"]
    }
    func getSelectedProvider()->String?{
        services[store.state.selectedServiceIndex].providers[store.state.selectedProviderIndex].name
    }
    
    //TODO: Add dynamic validations from the json
    func validateInputs()->String{
        var alertMessage = ""
        
        let requiredFields = getRequiredFields()
        for field in requiredFields {
            let fieldName = field.label["en"] ?? "Unknown Field"
            let fieldValue = store.state.fieldValues[field.name] ?? ""
            let selectedLanguage = store.state.selectedLanguage
            
            if fieldValue.isEmpty {
                let errorMessage: String
                if let validationError = field.validationErrorMessage {
                    switch validationError {
                    case .string(let message):
                        errorMessage = message
                    case .dictionary(let messages):
                        errorMessage = messages[selectedLanguage == .en ? "en" : "ar"] ?? ""
                    }
                } else {
                    errorMessage = "Please enter value for: \(fieldName)"
                }
                alertMessage += "\(errorMessage)\n"
            }
        }
        return alertMessage
    }
}
