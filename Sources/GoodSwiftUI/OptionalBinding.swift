//
//  OptionalBinding.swift
//  GoodSwiftUI
//
//  Created by Filip Šašala on 09/01/2024.
//

import SwiftUI

/// Allows binding to optional values in SwiftUI, replacing `nil` with default argument on `rhs`.
///
/// Example:
/// ```swift
///  @State private var text: String? = nil
///  InputField(text: $text ?? "")
/// ```
@MainActor public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
