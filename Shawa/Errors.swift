//
//  Errors.swift
//  Shawa
//
//  Created by Alex on 20.05.24.
//

import Foundation

enum AuthenticationError: Error {
    case emailMalformed, shortPassword, passwordAndConfirmNotMatch
}

extension AuthenticationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emailMalformed:
            String(localized: "Email is badly formatted")
        case .shortPassword:
            String(localized: "Password should be at least 6 characters long")
        case .passwordAndConfirmNotMatch:
            String(localized: "Password and confirmatiom do not match")
        }
    }
}

enum InputValidationError: Error {
    case fieldCannotBeEmpty(nameOfField: String)
    case cannotConvertToNumber(nameOfField: String)
    case cannotConvertToPhone
}

extension InputValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .fieldCannotBeEmpty(let nameOfField):
            String(localized: "Field \(nameOfField) cannot be emty")
        case .cannotConvertToNumber(let nameOfField):
            String(localized: "Field \(nameOfField) should nave a number")
        case .cannotConvertToPhone:
            String(localized: "Phone number invalid")
        }
    }
}


