//
//  ValidationError.swift
//  benu
//
//  Created by Filip Šašala on 11/06/2024.
//

import Foundation

// MARK: - Validation errors

public protocol ValidationError: Error, Equatable {

    var localizedDescription: String { get }

}

public enum InternalValidationError: ValidationError {

    case alwaysError
    case required
    case mismatch
    case external(String)

    public var localizedDescription: String {
        switch self {
        case .alwaysError:
            "Error"

        case .required:
            "Required"

        case .mismatch:
            "Elements do not match"

        case .external(let description):
            description
        }
    }

}

// MARK: - Default criteria

public extension Criterion {

    /// Always succeeds
    static let alwaysValid = Criterion { _ in true }

    /// Always fails
    static let alwaysError = Criterion { _ in false }
        .failWith(error: InternalValidationError.alwaysError)

    /// Accepts any input with length > 0, excluding leading/trailing whitespace
    static let nonEmpty = Criterion { !($0 ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        .failWith(error: InternalValidationError.required)

    /// Accepts an input if it is equal with another input
    static func matches(_ other: String?) -> Criterion {
        Criterion { this in this == other }
            .failWith(error: InternalValidationError.mismatch)
    }

    /// Accepts an empty input, see ``nonEmpty``.
    ///
    /// - Parameter criterion: Criteria for validation of non-empty input
    /// - Returns: `true` if input is empty or valid
    ///
    /// If input is empty, validation **succeeds** and input is deemed valid.
    /// If input is non-empty, validation continues by criterion specified as a parameter.
    static func acceptEmpty(_ criterion: Criterion) -> Criterion {
        Criterion { Criterion.nonEmpty.validate(input: $0) ? criterion.validate(input: $0) : true }
            .failWith(error: criterion.error)
    }

    static func external(error: (any Error)?) -> Criterion {
        Criterion { _ in error == nil }.failWith(error: InternalValidationError.external(error?.localizedDescription ?? ""))
    }

}

