//
//  sourcery_iOS
//
//  Created by Andrej Jasso on 28/10/2022.
//

import SwiftUI
import GoodExtensions

@available(iOS 14.0, *)
public struct GRButton: View {

    private let viewModel: GRButtonViewModel
    private let textContent: String?
    private let isLoading: Bool
    private let icon: Image?
    private let action: VoidClosure

    @Environment(\.isEnabled) private var isEnabled

    public init(
        viewModel: GRButtonViewModel,
        isLoading: Bool = false,
        textContent: String?,
        icon: Image? = nil,
        action: @escaping VoidClosure
    ) {
        self.viewModel = viewModel
        self.isLoading = isLoading
        self.textContent = textContent
        self.icon = icon
        self.action = action
    }

    public var body: some View {
        Button(
            action: {
                GRHapticsManager.shared.playSelectionFeedback()
                action()
            },
            label: {
                ZStack {
                    if let loading = viewModel.appearance.loading, isLoading {
                        progress(loading: loading)
                    } else {
                        content
                    }
                }
                .frame(maxWidth: !viewModel.appearance.frameModel.stretching ? .none : .infinity)
                .frame(width: viewModel.appearance.frameModel.width)
                .frame(height: viewModel.appearance.frameModel.height)
                .background(background)
                .shadowed(viewModel.appearance.shadow)
                .opacity(isEnabled ? 1.0 : 0.4)
                .animation(.linear(duration: 0.2), value: isLoading)
            }
        )
        .allowsHitTesting(!isLoading)
    }

    @ViewBuilder
    private var content: some View {
        HStack(alignment: .center, spacing: viewModel.appearance.frameModel.interItemSpacing) {
            if let icon = viewModel.appearance.icon {
                switch icon.alignment {
                case .trailingHugged:
                    if icon.mirrorIconSpace {
                        emptyIcon
                    }
                    text
                    self.icon
                        .foregroundColor(icon.tint)

                case .trailingEdge:
                    if icon.mirrorIconSpace {
                        emptyIcon
                    }
                    Spacer()
                    text
                    Spacer()
                    self.icon
                        .foregroundColor(icon.tint)

                case .leadingEdge:
                    self.icon
                        .foregroundColor(icon.tint)
                    Spacer()
                    text
                    Spacer()
                    if icon.mirrorIconSpace {
                        emptyIcon
                    }

                case .leadingHugged:
                    self.icon
                        .foregroundColor(icon.tint)
                    text
                    if icon.mirrorIconSpace {
                        emptyIcon
                    }
                }
            } else {
                text
            }
        }
        .padding(viewModel.appearance.frameModel.edgeSpacing)
    }

    @ViewBuilder
    private func progress(loading: LoadingModel) -> some View {
        HStack(alignment: .center, spacing: viewModel.appearance.frameModel.interItemSpacing) {
            text
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: loading.tintColor))
        }
        .padding(viewModel.appearance.frameModel.edgeSpacing)
    }

    @ViewBuilder
    private var background: some View {
        ZStack {
            if let stroke = viewModel.appearance.stroke {
                RoundedRectangle(cornerRadius: viewModel.appearance.frameModel.cornerRadius, style: .continuous)
                    .foregroundColor(stroke.color)
            }

            viewModel.appearance.backgroundColor
                .clipShape(RoundedRectangle(cornerRadius: viewModel.appearance.frameModel.cornerRadius))
                .padding(viewModel.appearance.stroke?.weight ?? 0)
                .frame(height: viewModel.appearance.frameModel.height)
        }
        
    }

    @ViewBuilder
    private var text: some View {
        Text(textContent ?? "")
            .foregroundColor(
                isEnabled
                    ? viewModel.appearance.text.color
                    : viewModel.appearance.disabledText.color
            )
            .font(
                Font(
                    isEnabled
                    ? viewModel.appearance.text.font
                    : viewModel.appearance.disabledText.font
                )
            )
            .lineLimit(1)
    }

    @ViewBuilder
    private var emptyIcon: some View {
        self.icon
            .opacity(0)
    }

}
