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
}
