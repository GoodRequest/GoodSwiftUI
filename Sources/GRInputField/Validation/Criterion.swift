//
//  Criterion.swift
//  GoodSwiftUI
//
//  Created by Filip Šašala on 26/03/2025.
//

import Foundation
import GoodExtensions
import GoodStructs

// MARK: - Criterion

@MainActor public struct Criterion: Then, CriteriaConvertible {

    // MARK: - Variables

    private(set) internal var error: any ValidationError = InternalValidationError.invalid
    private(set) internal var isRealtime: Bool = false

    // MARK: - Constants

    private let regex: String?
    private let predicate: MainPredicate<String?>?

    // MARK: - Initialization

    public init(regex: String) {
        self.regex = regex
        self.predicate = nil
    }

    public init(predicate: @escaping MainPredicate<String?>) {
        self.regex = nil
        self.predicate = predicate
    }

    public func failWith(error: any ValidationError) -> Self {
        var mutableSelf = self
        mutableSelf.error = error
        return mutableSelf
    }

    public func realtime() -> Self {
        var mutableSelf = self
        mutableSelf.isRealtime = true
        return mutableSelf
    }

    public func asCriteria() -> [Criterion] {
        [self]
    }

}

// MARK: - Validate - public

public extension Criterion {

    @MainActor func validate(input: String?) -> Bool {
        if regex != nil {
            guard let input = input else { return false }

            return validateRegex(input: input)
        } else if let predicate = predicate {
            return predicate(input)
        } else {
            return false
        }
    }

}

// MARK: - Private

private extension Criterion {

    func validateRegex(input: String) -> Bool {
        guard let pattern = regex else {
            assertionFailure("Validator regex equal to nil")
            return false
        }

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            assertionFailure("Invalid validator regex")
            return false
        }

        let range = NSRange(input.startIndex..<input.endIndex, in: input)
        var isValid = false

        regex.enumerateMatches(in: input, options: [], range: range) { match, _, _ in isValid = (match != nil) }

        return isValid
    }

}

// MARK: - Hashable

extension Criterion: Hashable {

    nonisolated public static func == (lhs: Criterion, rhs: Criterion) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    nonisolated public func hash(into hasher: inout Hasher) {
        if predicate.isNotNil { hasher.combine(UUID()) }
        hasher.combine(regex)
    }

}

// MARK: - Default criteria

public extension Criterion {

    /// Always succeeds
    static let alwaysValid = Criterion { _ in true }

    /// Always fails
    static let alwaysError = Criterion { _ in false }
        .failWith(error: InternalValidationError.invalid)

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
    static let zipCode = Criterion(regex: "^[0-9]{5}$")

}
