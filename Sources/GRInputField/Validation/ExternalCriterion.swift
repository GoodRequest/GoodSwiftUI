//
//  ExternalCriterion.swift
//  GoodSwiftUI
//
//  Created by Filip Šašala on 26/03/2025.
//

import Foundation
import GoodExtensions
import GoodStructs

// MARK: - External criterion

@MainActor public final class ExternalCriterion: CriteriaConvertible {

    private(set) internal var isRealtime: Bool = false
    private var predicate: MainPredicate<String?>?
    private var errorMessage: String?

    public init(errorSupplier: @MainActor @escaping (String?) -> (any LocalizedError)?) {
        self.predicate = {
            let error = errorSupplier($0)
            self.errorMessage = error?.localizedDescription
            return error.isNil
        }
    }

    public init<E: LocalizedError>(throwingErrorSupplier: @MainActor @escaping (String?) throws(E) -> ()) {
        self.predicate = {
            do {
                try throwingErrorSupplier($0)
                self.errorMessage = nil
                return true
            } catch {
                self.errorMessage = error.localizedDescription
                return false
            }
        }
    }

    public func realtime() -> Self {
        self.isRealtime = true
        return self
    }

    public func asCriteria() -> [Criterion] {
        let criterion = Criterion(predicate: predicate ?? { _ in false })
            .failWith(error: InternalValidationError.external {
                self.errorMessage ?? Bundle.main.localizedString(forKey: "invalid", value: "Invalid", table: "InternalValidationError")
            })

        if isRealtime {
            return [criterion.realtime()]
        } else {
            return [criterion]
        }
    }

}

extension Criterion {

    // Syntactic sugar to support `Criterion.external {...}`

    public static func external(error: @MainActor @escaping (String?) -> (any LocalizedError)?) -> ExternalCriterion {
        ExternalCriterion(errorSupplier: error)
    }

    public static func external<E: LocalizedError>(error: @MainActor @escaping (String?) throws(E) -> ()) -> ExternalCriterion {
        ExternalCriterion(throwingErrorSupplier: error)
    }

}
