//
//  ValidationError.swift
//  benu
//
//  Created by Filip Šašala on 11/06/2024.
//

import Foundation
import GoodExtensions

// MARK: - Validation errors

public protocol ValidationError: LocalizedError {}

public enum InternalValidationError: ValidationError {

    case invalid
    case required
    case mismatch
    case external(MainSupplier<String>)

    public var errorDescription: String? {
        switch self {
        case .invalid:
            Bundle.main.localizedString(forKey: "invalid", value: "Invalid", table: "InternalValidationError")

        case .required:
            Bundle.main.localizedString(forKey: "required", value: "Required", table: "InternalValidationError")

        case .mismatch:
            Bundle.main.localizedString(forKey: "mismatch", value: "Mismatch", table: "InternalValidationError")

        case .external(let description):
            MainActor.assumeIsolated {
                description()
            }
        }
    }

}
