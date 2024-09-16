//
//  Validator.swift
//  benu
//
//  Created by Filip Šašala on 04/08/2022.
//

import Foundation
import GoodExtensions
import GoodStructs

// MARK: - ValidatorBuilder

@resultBuilder public struct ValidatorBuilder {

    public static func buildBlock(_ components: CriteriaConvertible...) -> Validator {
        var criteria: [Criterion] = []
        components.forEach { criteria.append(contentsOf: $0.asCriteria()) }

        return Validator(criteria: criteria)
    }

    public static func buildOptional(_ component: CriteriaConvertible?) -> Validator {
        if let component = component?.asCriteria() {
            Validator(criteria: component)
        } else {
            Validator(criteria: [])
        }
    }

    public static func buildEither(first component: CriteriaConvertible) -> Validator {
        Validator(criteria: component.asCriteria())
    }

    public static func buildEither(second component: CriteriaConvertible) -> Validator {
        Validator(criteria: component.asCriteria())
    }

    public static func buildArray(_ components: [CriteriaConvertible]) -> Validator {
        let criteria = components.reduce(into: [Criterion]()) { partialResult, newElement in
            newElement.asCriteria().forEach { partialResult.append($0) }
        }

        return Validator(criteria: criteria)
    }

}

// MARK: - Validator

public struct Validator: CriteriaConvertible {

    fileprivate var criteria: [Criterion] = []

    @MainActor public func isValid(input: String?) -> Bool {
        validate(input: input).isNil
    }

    @MainActor public func validate(input: String?) -> (any ValidationError)? {
        let failedCriterion = criteria
            .map { (criterion: $0, result: $0.validate(input: input)) }
            .first { _, result in !result }
            .map { $0.0 }

        if let failedCriterion = failedCriterion {
            return failedCriterion.error
        }

        return nil
    }

    public func asCriteria() -> [Criterion] {
        return Array(criteria)
    }

}

// MARK: - Criterion

public struct Criterion: Sendable, Then, CriteriaConvertible {

    // MARK: - Variables

    private(set) internal var error: any ValidationError = InternalValidationError.alwaysError

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

    public func asCriteria() -> [Criterion] {
        [self]
    }

}

// MARK: - CriteriaConvertible

public protocol CriteriaConvertible {

    func asCriteria() -> [Criterion]

}

// MARK: - Hashable

extension Criterion: Hashable {

    public static func == (lhs: Criterion, rhs: Criterion) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        if predicate.isNotNil { hasher.combine(UUID()) }
        hasher.combine(regex)
    }

}

// MARK: - Public

extension Criterion {

    @MainActor public func validate(input: String?) -> Bool {
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
