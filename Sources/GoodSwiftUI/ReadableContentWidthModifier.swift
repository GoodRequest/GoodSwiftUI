//
//  ReadableContentWidthModifier.swift
//
//  GoodSwiftUI
//  Created by Filip Šašala on 31/12/2023.
//

import SwiftUI

// MARK: - Readable content width view

public struct FittingReadableWidth<Content: View>: View {

    private let alignment: Alignment
    private let content: () -> Content

    public init(alignment: Alignment = .center, content: @escaping () -> Content) {
        self.alignment = alignment
        self.content = content
    }

    public var body: some View {
        content().fittingReadableWidth(alignment: alignment)
    }

}

// MARK: - Readable content width modifier

private struct ReadableContentWidthModifier: ViewModifier {

    let alignment: Alignment

    func body(content: Content) -> some View {
        content
            .modifier(ReadableContentWidthPaddingModifier(alignment: alignment))
            .modifier(ReadableContentWidthMeasurementModifier())
    }

}

public extension View {

    func fittingReadableWidth(alignment: Alignment = .center) -> some View {
        modifier(ReadableContentWidthModifier(alignment: alignment))
    }

}

// MARK: - Environment

private extension EnvironmentValues {

    @Entry var readableContentInsets = EdgeInsets()

}

// MARK: - Padding modifier

private struct ReadableContentWidthPaddingModifier: ViewModifier {

    @Environment(\.readableContentInsets) private var readableContentInsets

    let alignment: Alignment

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: alignment)
            .padding(.leading, readableContentInsets.leading)
            .padding(.trailing, readableContentInsets.trailing)
    }

}

// MARK: - Measurement modifier

private struct ReadableContentWidthMeasurementModifier: ViewModifier {

    @State private var readableContentInsets = EdgeInsets()

    func body(content: Content) -> some View {
        content
            .environment(\.readableContentInsets, readableContentInsets)
            .background(LayoutGuides(onChangeOfReadableContentInsets: {
                readableContentInsets = $0
            }))
    }

}

// MARK: - UIKit LayoutGuides view

private struct LayoutGuides: UIViewRepresentable {

    let onChangeOfReadableContentInsets: (EdgeInsets) -> ()

    func makeUIView(context: Context) -> LayoutGuidesView {
        let uiView = LayoutGuidesView()
        uiView.onChangeOfReadableContentInsets = self.onChangeOfReadableContentInsets
        return uiView
    }

    func updateUIView(_ uiView: LayoutGuidesView, context: Context) {
        uiView.onChangeOfReadableContentInsets = self.onChangeOfReadableContentInsets
    }

}

private final class LayoutGuidesView: UIView {

    fileprivate var onChangeOfReadableContentInsets: (EdgeInsets) -> () = { _ in }
    private var previousReadableContentInsets: EdgeInsets?

    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        updateReadableContent()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateReadableContent()
    }

    override var frame: CGRect {
        didSet { updateReadableContent() }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.layoutDirection != previousTraitCollection?.layoutDirection {
            updateReadableContent()
        }
    }

}

private extension LayoutGuidesView {

    func updateReadableContent() {
        let isRTLLanguage = traitCollection.layoutDirection == .rightToLeft
        let readableLayoutFrame = readableContentGuide.layoutFrame

        let readableEdgeInsets = UIEdgeInsets(
            top: readableLayoutFrame.minY - bounds.minY,
            left: readableLayoutFrame.minX - bounds.minX,
            bottom: -(readableLayoutFrame.maxY - bounds.maxY),
            right: -(readableLayoutFrame.maxX - bounds.maxX)
        )
        let readableContentInsets = EdgeInsets(
            top: readableEdgeInsets.top,
            leading: isRTLLanguage ? readableEdgeInsets.right : readableEdgeInsets.left,
            bottom: readableEdgeInsets.bottom,
            trailing: isRTLLanguage ? readableEdgeInsets.left : readableEdgeInsets.right
        )

        guard previousReadableContentInsets != readableContentInsets else { return }
        defer { previousReadableContentInsets = readableContentInsets }

        self.onChangeOfReadableContentInsets(readableContentInsets)
    }

}

// MARK: - Previews

@available(iOS 17.0, *)
#Preview {
    FittingReadableWidth {
        Rectangle()
            .foregroundStyle(.cyan)
    }
}

private final class PreviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let rectangle = UIView()
        rectangle.translatesAutoresizingMaskIntoConstraints = false
        rectangle.backgroundColor = .systemRed

        view.addSubview(rectangle)

        NSLayoutConstraint.activate([
            rectangle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rectangle.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            rectangle.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            rectangle.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

@available(iOS 17.0, *)
#Preview {
    PreviewViewController()
}
