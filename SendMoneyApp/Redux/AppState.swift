//
//  AppState.swift
//  SendMoneyApp
//
//  Created by Asad on 17/03/25.
//

import Foundation
import ReSwift

// Define the Redux state structure
struct SendMoneyState {
    var selectedServiceIndex: Int = 0
    var selectedProviderIndex: Int = 0
    var fieldValues: [String: String] = [:] // Store user-entered values
}

// Define actions to modify the state
struct SelectServiceAction: Action {
    let index: Int
}

struct SelectProviderAction: Action {
    let index: Int
}

struct UpdateFieldValueAction: Action {
    let fieldName: String
    let value: String
}

// Define the reducer to handle state changes
func sendMoneyReducer(action: Action, state: SendMoneyState?) -> SendMoneyState {
    var state = state ?? SendMoneyState()
    
    switch action {
    case let action as SelectServiceAction:
        state.selectedServiceIndex = action.index
        state.selectedProviderIndex = 0 // Reset provider selection
        state.fieldValues.removeAll() // Clear previous input
    case let action as SelectProviderAction:
        state.selectedProviderIndex = action.index
        state.fieldValues.removeAll() // Clear previous input
    case let action as UpdateFieldValueAction:
        state.fieldValues[action.fieldName] = action.value
    default:
        break
    }
    
    return state
}
// Global Redux store definition
let store = Store(reducer: sendMoneyReducer, state: SendMoneyState())

func loadJSON() -> [Service]? {
    guard let url = Bundle.main.url(forResource: "services", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        return nil
    }
    do
    {
        return try JSONDecoder().decode(MoneyTransfer.self, from: data).services
    }catch
    {
        print(error)
        return nil
    }
}
