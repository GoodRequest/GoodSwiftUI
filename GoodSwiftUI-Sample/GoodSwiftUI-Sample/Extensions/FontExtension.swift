//
//  FontExtension.swift
//  GoodSwiftUI-Sample
//
//  Created by Matus Klasovity on 22/01/2025.
//

import SwiftUI

extension Font {

    static func systemFont(ofSize size: CGFloat, weight: Font.Weight = .regular, relativeTo: TextStyle = .body) -> Font {
        let name = UIFont.systemFont(ofSize: size).familyName

        return .custom(name, size: size, relativeTo: relativeTo).weight(weight)
    }

}
