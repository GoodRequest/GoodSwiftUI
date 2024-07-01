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
        self = mapValues { $0.deterministicState }
    }

    internal mutating func determine(fieldWithId uuid: UUID) {
        self[uuid] = self[uuid]?.deterministicState
    }

}

// MARK: - Validation State

public enum ValidationState: Sendable {

    case valid
    case pending((any ValidationError)?)
    case invalid(any ValidationError)

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
        case .valid, .invalid:
            return self

        case .pending(let error):
            if let error {
                return .invalid(error)
            } else {
                return .valid
            }
        }
    }

}
