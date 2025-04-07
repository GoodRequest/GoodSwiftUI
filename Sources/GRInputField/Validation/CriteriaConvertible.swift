//
//  CriteriaConvertible.swift
//  GoodSwiftUI
//
//  Created by Filip Šašala on 26/03/2025.
//

// MARK: - CriteriaConvertible

@MainActor public protocol CriteriaConvertible {

    func asCriteria() -> [Criterion]

}
