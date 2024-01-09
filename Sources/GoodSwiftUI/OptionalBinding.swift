//
//  OptionalBinding.swift
//  GoodSwiftUI
//
//  Created by Filip Šašala on 09/01/2024.
//

import SwiftUI

public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
