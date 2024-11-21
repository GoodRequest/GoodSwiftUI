//
//  GRButtonSampleView.swift
//  GoodSwiftUI-Sample
//
//  Created by Lukas Kubaliak on 20/11/2024.
//

import SwiftUI
import GRButton

struct GRButtonSampleView: View {
    
    enum Constants {
        
        static let baseButtonTitle = "Base"
        static let textButtonTitle = "Text"
        static let smallButtonTitle = "Small"
        static let mediumButtonTitle = "Medium"
        static let largeButtonTitle = "Large"
        static let disabledButtonTitle = "Disabled"
        static let loadingButtonTitle = "Loading"
        
    }
    
    @State var isLoading: Bool = false
    
    var leftImage = Image(systemName: "person")
    var rightImage = Image(systemName: "arrow.right")
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16) {
            Button(Constants.textButtonTitle) { isLoading.toggle() }
                .buttonStyle(GRButtonStyle(appearance: .secondary))
            
            Button(Constants.textButtonTitle) { isLoading.toggle() }
                .buttonStyle(GRButtonStyle(appearance: .primary))
            
            Button(Constants.smallButtonTitle) { isLoading.toggle() }
                .buttonStyle(
                    GRButtonStyle(
                        appearance: .secondary,
                        iconModel: .init(leftIcon: leftImage, rightIcon: rightImage),
                        size: .small
                    )
                )
            
            Button(Constants.smallButtonTitle) { isLoading.toggle() }
                .buttonStyle(
                    GRButtonStyle(
                        appearance: .primary,
                        iconModel: .init(leftIcon: leftImage, rightIcon: rightImage),
                        size: .small
                    )
                )
            
            Button(Constants.mediumButtonTitle) { isLoading.toggle() }
                .buttonStyle(
                    GRButtonStyle(
                        appearance: .secondary,
                        iconModel: .init(leftIcon: leftImage, rightIcon: rightImage),
                        size: .medium
                    )
                )
            
            Button(Constants.mediumButtonTitle) { isLoading.toggle() }
                .buttonStyle(
                    GRButtonStyle(
                        appearance: .primary,
                        iconModel: .init(leftIcon: leftImage, rightIcon: rightImage),
                        size: .medium
                    )
                )
            
            Button(Constants.largeButtonTitle) { isLoading.toggle() }
                .buttonStyle(
                    GRButtonStyle(
                        appearance: .secondary,
                        iconModel: .init(leftIcon: leftImage, rightIcon: nil),
                        size: .large
                    )
                )
            
            Button(Constants.largeButtonTitle) { isLoading.toggle() }
                .buttonStyle(
                    GRButtonStyle(
                        appearance: .primary,
                        iconModel: .init(leftIcon: leftImage, rightIcon: nil),
                        size: .large
                    )
                )
            
            Button(Constants.loadingButtonTitle) { isLoading.toggle() }
                .buttonStyle(
                    GRButtonStyle(
                        appearance: .secondary,
                        isLoading: isLoading,
                        size: .medium
                    )
                )
            
            Button(Constants.loadingButtonTitle) { isLoading.toggle() }
                .buttonStyle(
                    GRButtonStyle(
                        appearance: .primary,
                        isLoading: isLoading,
                        size: .medium
                    )
                )
            
            Button(action: {}, label: { EmptyView() })
                .buttonStyle(
                    GRButtonStyle(
                        appearance: .secondary,
                        iconModel: GRButtonIconModel(rightIcon: rightImage),
                        isLoading: isLoading,
                        size: .circleSmall
                    )
                )
            
            Button(action: {}, label: { EmptyView() })
                .buttonStyle(
                    GRButtonStyle(
                        appearance: .primary,
                        iconModel: GRButtonIconModel(rightIcon: rightImage),
                        isLoading: isLoading,
                        size: .circleSmall
                    )
                )
            
            Button(action: {}, label: { EmptyView() })
                .buttonStyle(
                    GRButtonStyle(
                        appearance: .secondary,
                        iconModel: GRButtonIconModel(rightIcon: rightImage),
                        isLoading: isLoading,
                        size: .circleMedium
                    )
                )
            
            Button(action: {}, label: { EmptyView() })
                .buttonStyle(
                    GRButtonStyle(
                        appearance: .primary,
                        iconModel: GRButtonIconModel(rightIcon: rightImage),
                        isLoading: isLoading,
                        size: .circleMedium
                    )
                )
            
            Button(action: {}, label: { EmptyView() })
                .buttonStyle(
                    GRButtonStyle(
                        appearance: .secondary,
                        iconModel: GRButtonIconModel(rightIcon: rightImage),
                        isLoading: isLoading,
                        size: .square
                    )
                )
            
            Button(action: {}, label: { EmptyView() })
                .buttonStyle(
                    GRButtonStyle(
                        appearance: .primary,
                        iconModel: GRButtonIconModel(rightIcon: rightImage),
                        isLoading: isLoading,
                        size: .square
                    )
                )
        }
    }
    
}

// MARK: - GR Button Appearance Configuration

extension GRButtonAppearanceModel {
    
    static let primary: GRButtonAppearanceModel = .init(
        backgroundColor: .red,
        loadingTintColor: .white,
        iconTintColor: .white,
        textColor: .white,
        disabledTextColor: .white,
        textFont: .systemFont(ofSize: 17, weight: .medium),
        disabledTextFont: .systemFont(ofSize: 17, weight: .medium)
    )
    
    static let secondary: GRButtonAppearanceModel = .init(
        backgroundColor: .clear,
        loadingTintColor: .black,
        iconTintColor: .black,
        textColor: .black,
        disabledTextColor: .black,
        textFont: .systemFont(ofSize: 17, weight: .medium),
        disabledTextFont: .systemFont(ofSize: 17, weight: .medium)
    )
    
}
