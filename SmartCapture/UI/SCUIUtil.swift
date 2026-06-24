//
//  SCUIUtil.swift
//  SmartCapture
//
//  Created by Wilmer Barrios on 28/05/26.
//

import Foundation
import SwiftUI

enum SCUIUtil {
    static func gbgGradient(for colorScheme: ColorScheme) -> LinearGradient {
        let colors: [Color] = colorScheme == .dark
            ? [
                Color(red: 0.29, green: 0.28, blue: 0.48),
                Color(red: 0.13, green: 0.16, blue: 0.30)
            ]
            : [
                Color(red: 0.64, green: 0.63, blue: 1.0), // (vivid purple)
                Color(red: 0.96, green: 0.97, blue: 1.0)  // (light blue)
            ]

        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
