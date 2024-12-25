//
//  SettingsView.swift
//  ScanTest]
//
//  Created by Zainab Alatwi  on 17/06/1446 AH.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedBackgroundColor") private var selectedBackgroundColorHex: String = "#FFFFFF"
    @AppStorage("selectedFontSize") private var selectedFontSize: Double = 20.0 // تخزين كـ Double
    
    let colors: [String: Color] = [
        "White": .white,
        "Black": .black,
        "Yellow": .yellow,
        "Blue": .blue
    ]
    
    var body: some View {
        Form {
            Section(header: Text("Background Color")) {
                Picker("Select Background Color", selection: $selectedBackgroundColorHex) {
                    ForEach(colors.keys.sorted(), id: \.self) { colorName in
                        Text(colorName)
                            .tag(self.hexString(for: colors[colorName] ?? .white))
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Section(header: Text("Font Size")) {
                Slider(value: $selectedFontSize, in: 12...36, step: 1) {
                    Text("Font Size")
                }
                .accessibilityValue(Text("\(Int(selectedFontSize))"))
            }
        }
        .navigationTitle("Settings")
    }
    
    private func hexString(for color: Color) -> String {
        if color == .white { return "#FFFFFF" }
        if color == .black { return "#000000" }
        if color == .yellow { return "#FFFF00" }
        if color == .blue { return "#0000FF" }
        return "#FFFFFF" // Default to white
    }
}

