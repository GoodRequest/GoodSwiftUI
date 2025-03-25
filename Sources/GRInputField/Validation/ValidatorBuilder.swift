//
//  ValidatorBuilder.swift
//  GoodSwiftUI
//
//  Created by Filip Šašala on 26/03/2025.
//

import Foundation
import GoodExtensions
import GoodStructs

// MARK: - ValidatorBuilder

@MainActor @resultBuilder public struct ValidatorBuilder {

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
