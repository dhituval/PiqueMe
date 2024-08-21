//
//  Colors.swift
//  PiqueMe
//
//  Created by Diya Hituvalli on 8/21/24.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        // Ensure the hex string is valid
        let cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgb: UInt64 = 0
        
        // Handle color codes in the format #RRGGBB
        if cleanedHex.hasPrefix("#") {
            let index = cleanedHex.index(cleanedHex.startIndex, offsetBy: 1)
            let hexString = String(cleanedHex[index...])
            Scanner(string: hexString).scanHexInt64(&rgb)
        } else {
            Scanner(string: cleanedHex).scanHexInt64(&rgb)
        }
        
        // Extract RGB components
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: 1.0
        )
    }
}
