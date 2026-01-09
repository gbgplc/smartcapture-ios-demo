//
//  SettingsHomeView.swift
//  SmartCapture
//
//  Created by Wilmer Barrios on 21/05/24.
//

import SwiftUI

enum SettingOption: String, CaseIterable, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case createCredential
    case deleteCredential
    case selectCredential
    case temporaryCredential
    case selectJourney
    
    case startJourney
}

extension SettingOption {
    var title: String {
        switch self {
        case .createCredential:
            String(localized:"Create New Credentials", comment: "Create new credentials")
        case .deleteCredential:
            String(localized:"Delete Existing Credentials", comment: "Delete Existing Credentials")
        case .selectCredential:
            String(localized:"Select Credentials", comment: "Select Credentials")
        case .temporaryCredential:
            String(localized:"Temporary Credentials", comment: "Temporary Credentials")
        case .selectJourney:
            String(localized:"Select Journey", comment: "Select Journey")
        case .startJourney:
            String(localized:"Start Journey", comment: "Start Journey")
        }
    }
}

struct SettingsHomeView: View {
    private var mainColor: Color { .purple }
    private var secondaryColor: Color { .gray }
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            makeButton(
                for: .createCredential,
                foregroundColor: mainColor
            )
            makeButton(
                for: .deleteCredential,
                foregroundColor: mainColor
            )
            HStack(spacing: 12) {
                makeButton(
                    for: .selectCredential,
                    foregroundColor: mainColor
                )
                makeButton(
                    for: .temporaryCredential,
                    foregroundColor: secondaryColor
                )
            }
            makeButton(
                for: .selectJourney,
                foregroundColor: mainColor
            )
            Spacer()
            makeButton(
                for: .startJourney,
                foregroundColor: mainColor
            )
        }.padding()
    }
    
    private func makeButton(
        for option: SettingOption,
        foregroundColor: Color
    ) -> SCButton {
        SCButton(
            action: { onSettingSelected(option) },
            title: option.title,
            foregroundColor: foregroundColor
        )
    }
    
    private func onSettingSelected(_ setting: SettingOption) {
        print(Self.self, #function, setting)
    }
}

#Preview {
    SettingsHomeView()
}
