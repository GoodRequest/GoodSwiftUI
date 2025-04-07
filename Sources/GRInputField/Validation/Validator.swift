//
//  Validator.swift
//  benu
//
//  Created by Filip Šašala on 04/08/2022.
//

import Foundation
import GoodExtensions
import GoodStructs

// MARK: - Validator

@MainActor public struct Validator: CriteriaConvertible {

    internal var criteria: [Criterion] = []

    internal init(criteria: [Criterion]) {
        self.criteria = criteria
    }

    internal init(realtime criteria: [Criterion]) {
        self.criteria = criteria.filter { $0.isRealtime }
    }

    public func isValid(input: String?) -> Bool {
        validate(input: input).isNil
    }

    public func validate(input: String?) -> (any ValidationError)? {
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
