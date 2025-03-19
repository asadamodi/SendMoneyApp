//
//  Service.swift
//  SendMoneyApp
//
//  Created by Asad on 17/03/25.
//

import Foundation

struct MoneyTransfer: Codable {
    let title: [String: String]
    let services: [Service]
}

struct Service: Codable {
    let label: [String: String]
    let name: String
    let providers: [Provider]
}

struct Provider: Codable {
    let name: String
    let id: String
    let requiredFields: [RequiredField]
    
    enum CodingKeys: String, CodingKey {
        case name, id, requiredFields = "required_fields"
    }
}


struct RequiredField: Codable {
    let label: [String: String]
    let name: String
    let placeholder: PlaceholderType?
    let type: String
    let validation: String?
    let maxLength: MaxLengthType
    let validationErrorMessage: ValidationErrorMessageType?
    let options: [Option]?
    
    enum CodingKeys: String, CodingKey {
        case label, name, placeholder, type, validation
        case maxLength = "max_length"
        case validationErrorMessage = "validation_error_message"
        case options
    }
}

struct Option: Codable {
    let label: String
    let name: String
}

// Handling multiple possible types for placeholder
enum PlaceholderType: Codable {
    case string(String)
    case dictionary([String: String])
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let dictValue = try? container.decode([String: String].self) {
            self = .dictionary(dictValue)
        } else {
            self = .null
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .dictionary(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}

// Handling multiple possible types for maxLength
enum MaxLengthType: Codable {
    case int(Int)
    case string(String)
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            self = .null
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}

// Handling multiple possible types for validationErrorMessage
enum ValidationErrorMessageType: Codable {
    case string(String)
    case dictionary([String: String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let dictValue = try? container.decode([String: String].self) {
            self = .dictionary(dictValue)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid data type for validationErrorMessage")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .dictionary(let value):
            try container.encode(value)
        }
    }
}

