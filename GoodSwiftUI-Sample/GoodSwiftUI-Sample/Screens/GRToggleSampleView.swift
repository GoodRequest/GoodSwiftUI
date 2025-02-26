//
//  GRToggleSampleView.swift
//  GoodSwiftUI-Sample
//
//  Created by Lukas Kubaliak on 27/11/2024.
//

import SwiftUI
import GRToggle

struct GRToggleSampleView: View {
    
    @State private var isOn: Bool = false
    
    var body: some View {
        VStack {
            Group {
                Toggle(isOn: $isOn) { text("Toggle large") }
                    .toggleStyle(GRSwitchStyle(appearance: .default, size: .large))
                
                Toggle(isOn: $isOn) { text("Toggle small") }
                    .toggleStyle(GRSwitchStyle(appearance: .default, size: .small))
                
                Toggle(isOn: $isOn) { text("Toggle small disabled") }
                    .toggleStyle(GRSwitchStyle(appearance: .default, size: .small))
                    .disabled(true)
                
                Toggle(isOn: $isOn) { text("Check circle large") }
                    .toggleStyle(GRToggleStyle(appearance: .default, style: .circularCheck, size: .large))
                
                Toggle(isOn: $isOn) { text("Check circle small") }
                    .toggleStyle(GRToggleStyle(appearance: .default, style: .circularCheck, size: .small))
                
                Toggle(isOn: $isOn) { text("Check circle small disabled") }
                    .toggleStyle(GRToggleStyle(appearance: .default, style: .circularCheck, size: .small))
                    .disabled(true)
                
                Toggle(isOn: $isOn) { text("Radio box large") }
                    .toggleStyle(GRToggleStyle(appearance: .default, style: .radio, size: .large))
                
                Toggle(isOn: $isOn) { text("Radio box small") }
                    .toggleStyle(GRToggleStyle(appearance: .default, style: .radio, size: .small))
                
                Toggle(isOn: $isOn) { text("Radio box small disabled") }
                    .toggleStyle(GRToggleStyle(appearance: .default, style: .radio, size: .small))
                    .disabled(true)
                
                Toggle(isOn: $isOn) { text("Check Box large") }
                    .toggleStyle(GRToggleStyle(appearance: .default, style: .checkbox, size: .large))
                
                Toggle(isOn: $isOn) { text("Check Box small") }
                    .toggleStyle(GRToggleStyle(appearance: .default, style: .checkbox, size: .small))
                
                Toggle(isOn: $isOn) { text("Check Box small disabled") }
                    .toggleStyle(GRToggleStyle(appearance: .default, style: .checkbox, size: .small))
                    .disabled(true)
                    
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding()
    }
    
}

#Preview {
    GRToggleSampleView()
}

// MARK: - Private

private extension GRToggleSampleView {
    
    func text(_ text: String) -> some View {
        Text(text).frame(maxWidth: .infinity, alignment: .leading)
    }
    
}

// MARK: - GR Switch Appearance Configuration

extension GRSwitchAppearance {
    
    static let `default`: GRSwitchAppearance = .init(activeBackgroundColor: .red)
    
}

// MARK: - GR Toggle Appearance Configuration

extension GRToggleAppearance {
    
    static let `default`: GRToggleAppearance = .init(
        tintColor: .red,
        uncheckedBorderColor: .gray,
        checkedBackgroundColor: .red.opacity(0.2),
        checkmarkImageTintColor: .white,
        checkmarkImage: Image(systemName: "checkmark")
    )
    
}
