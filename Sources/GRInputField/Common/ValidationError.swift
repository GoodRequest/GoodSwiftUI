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

    public var localizedDescription: String {
        switch self {
        case .alwaysError:
            String(describing: self)

        case .required:
            "Required"

        case .mismatch:
            "Elements do not match"
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

}

// MARK: - Commonly used

public extension Criterion {

    /// Email validator similar to RFC-5322 standards, modified for Swift compatibility, case-insensitive
    static let email = Criterion(regex: """
                                        (?i)\\A(?=[a-z0-9@.!#$%&'*+\\/=?^_'{|}~-]{6,254}\
                                        \\z)(?=[a-z0-9.!#$%&'*+\\/=?^_'{|}~-]{1,64}@)\
                                        [a-z0-9!#$%&'*+\\/=?^_'{|}~-]+(?:\\.[a-z0-9!#$%&'*+\\/=?^_'{|}~-]+)\
                                        *@(?:(?=[a-z0-9-]{1,63}\\.)[a-z0-9]\
                                        (?:[a-z0-9-]*[a-z0-9])?\\.)+(?=[a-z0-9-]{1,63}\\z)\
                                        [a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\z
                                        """)

    /// Accepts only valid zip codes
    static let zipCode = Criterion(regex: #/^[0-9]{5}$/#) // Criterion(regex: "^[0-9]{5}$")

}
