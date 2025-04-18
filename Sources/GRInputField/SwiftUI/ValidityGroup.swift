//
//  ValidityGroup.swift
//  benu
//
//  Created by Filip Šašala on 15/04/2024.
//

import Foundation

// MARK: - Validity Group

public typealias ValidityGroup = [UUID: ValidationState]

@MainActor public extension ValidityGroup {

    func allValid() -> Bool {
        isEmpty ? false : allSatisfy { $0.value.isValid }
    }

    mutating func validateAll() {
        removeAll()
    }

}

// MARK: - Validation State

@MainActor public enum ValidationState: Sendable, Equatable {

    case valid
    case error(any ValidationError)
    case pending(error: (any ValidationError)?)
    case invalid

    var isValid: Bool {
        if case .valid = self {
            return true
        } else if case .pending(let error) = self {
            return (error == nil)
        } else {
            return false
        }
    }

    var deterministicState: ValidationState {
        switch self {
        case .valid, .error, .invalid:
            return self

        case .pending(let error):
            if let error {
                return .error(error)
            } else {
                return .valid
            }
        }
    }

    nonisolated public static func == (lhs: ValidationState, rhs: ValidationState) -> Bool {
        switch (lhs, rhs) {
        case (.valid, .valid):
            return true

        case (.invalid, .invalid):
            return true

        case (.error(let lhsValidationError), .error(let rhsValidationError)):
            return lhsValidationError.localizedDescription == rhsValidationError.localizedDescription

        case (.pending(let lhsValidationError), .pending(let rhsValidationError)):
            return lhsValidationError?.localizedDescription == rhsValidationError?.localizedDescription

        default:
            return false
        }
    }

}
