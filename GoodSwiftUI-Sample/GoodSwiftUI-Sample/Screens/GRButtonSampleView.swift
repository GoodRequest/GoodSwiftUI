//
//  GRButtonSampleView.swift
//  GoodSwiftUI-Sample
//
//  Created by Lukas Kubaliak on 20/11/2024.
//

import SwiftUI
import GRButton

struct GRButtonSampleView: View {
    
    @State private var isLoading: Bool = false
    
    enum Constants {
        
        static let baseButtonTitle = "Base"
        static let iconButtonTitle = "Icon"
        static let disabledButtonTitle = "Disabled"
        static let loadingButtonTitle = "Loading"
        
    }

    let grButtonBaseStyleModel = GRButtonStyleModel(
        backgroundColor: .black,
        loadingTingColor: .white,
        iconTintColor: .white,
        textColor: .white,
        disabledTextColor: .white,
        textFont: .systemFont(ofSize: 17, weight: .semibold),
        disabledTextFont: .systemFont(ofSize: 17, weight: .semibold)
    )
    
    let grButtonTextStyleModel = GRButtonStyleModel(
        loadingTingColor: .black,
        iconTintColor: .black,
        textColor: .black,
        disabledTextColor: .black,
        textFont: .systemFont(ofSize: 17, weight: .semibold),
        disabledTextFont: .systemFont(ofSize: 17, weight: .semibold)
    )
    
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16) {
            GRButton(
                viewModel: .init(styleModel: grButtonBaseStyleModel, .sampleBase),
                textContent: Constants.baseButtonTitle,
                action: { isLoading.toggle() }
            )
            .buttonStyle(.scaling(viewModel: .init(styleModel: grButtonBaseStyleModel, .base)))
            
            GRButton(
                viewModel: .init(styleModel: grButtonTextStyleModel, .sampleText),
                textContent: Constants.baseButtonTitle,
                action: { isLoading.toggle() }
            )
            .buttonStyle(.scaling(viewModel: .init(styleModel: grButtonTextStyleModel, .base)))

            GRButton(
                viewModel: .init(styleModel: grButtonBaseStyleModel, .sampleBase),
                textContent: Constants.iconButtonTitle,
                icon: Image(
                    uiImage: UIImage(systemName: "arrow.forward")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
                ),
                action: { isLoading.toggle() }
            )
            .buttonStyle(.scaling(viewModel: .init(styleModel: grButtonBaseStyleModel, .base)))

            GRButton(
                viewModel: .init(styleModel: grButtonTextStyleModel, .sampleText),
                textContent: Constants.iconButtonTitle,
                icon: Image(
                    uiImage: UIImage(systemName: "arrow.forward")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
                ),
                action: { isLoading.toggle() }
            )
            .buttonStyle(.scaling(viewModel: .init(styleModel: grButtonTextStyleModel, .base)))

            GRButton(
                viewModel: .init(styleModel: grButtonBaseStyleModel, .sampleBase),
                textContent: Constants.disabledButtonTitle,
                action: { isLoading.toggle() }
            )
            .disabled(true)
            .buttonStyle(.scaling(viewModel: .init(styleModel: grButtonBaseStyleModel, .base)))

            GRButton(
                viewModel: .init(styleModel: grButtonTextStyleModel, .sampleText),
                textContent: Constants.disabledButtonTitle,
                action: { isLoading.toggle() }
            )
            .disabled(true)
            .buttonStyle(.scaling(viewModel: .init(styleModel: grButtonTextStyleModel, .base)))

            GRButton(
                viewModel: .init(styleModel: grButtonBaseStyleModel, .sampleBase),
                isLoading: isLoading,
                textContent: Constants.loadingButtonTitle,
                action: { isLoading.toggle() }
            )
            .buttonStyle(.scaling(viewModel: .init(styleModel: grButtonBaseStyleModel, .base)))

            GRButton(
                viewModel: .init(styleModel: grButtonTextStyleModel, .sampleText),
                isLoading: isLoading,
                textContent: Constants.loadingButtonTitle,
                action: { isLoading.toggle() }
            )
            .buttonStyle(.scaling(viewModel: .init(styleModel: grButtonTextStyleModel, .base)))
        }
    }
    
}
