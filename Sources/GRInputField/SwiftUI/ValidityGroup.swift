//
//  ValidityGroup.swift
//  benu
//
//  Created by Filip Šašala on 15/04/2024.
//

import Foundation

// MARK: - Validity Group

public typealias ValidityGroup = [UUID: ValidationState]

public extension ValidityGroup {

    func allValid() -> Bool {
        isEmpty ? false : allSatisfy { $0.value.isValid }
    }

    mutating func validateAll() {
        removeAll()
    }

}

// MARK: - Validation State

public enum ValidationState: Equatable, Sendable {

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

    public static func == (lhs: ValidationState, rhs: ValidationState) -> Bool {
        switch lhs {
        case .valid:
            switch rhs {
            case .valid:
                return true
            default:
                return false
            }
        case .error(let lhsValidationError):
            switch rhs {
            case .error(let rhsValidationError):
                return lhsValidationError.localizedDescription == rhsValidationError.localizedDescription
            default:
                return false
            }
        case .pending(let lhsValidationError):
            switch rhs {
            case .pending(let rhsValidationError):
                return lhsValidationError?.localizedDescription == rhsValidationError?.localizedDescription
            default:
                return false
            }
        case .invalid:
            switch rhs {
            case .invalid:
                return true
            default:
                return false
            }
        }
    }

}
