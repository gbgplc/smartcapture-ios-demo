//
//  NFCResultView.swift
//  SmartCapture
//
//  Created by Wilmer Barrios on 17/04/26.
//

import Foundation
import SwiftUI
import OzoneNFC

struct NFCResultView: View {
    var passport: OzoneNFCDocument?
    
    var body: some View {
        if let passport = self.passport {
            Form {
                Section {
                    HStack {
                        Text("First Name")
                        Spacer()
                        Text(passport.firstName)
                    }
                    HStack {
                        Text("Last Name")
                        Spacer()
                        Text(passport.lastName)
                    }
                    if let imageData = passport.image {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Image")
                            Image(uiImage: imageData)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    HStack {
                        Text("Document Number")
                        Spacer()
                        Text(passport.documentNumber)
                    }
                    HStack {
                        Text("Nationality")
                        Spacer()
                        Text(passport.nationality)
                    }
                    HStack {
                        Text("Date of Birth")
                        Spacer()
                        Text(passport.dateOfBirth)
                    }
                    if let age = passport.age {
                        HStack {
                            Text("Age")
                            Spacer()
                            Text(String(age))
                        }
                    }
                    HStack {
                        Text("Gender")
                        Spacer()
                        Text(passport.gender)
                    }
                    HStack {
                        Text("Expiry Date")
                        Spacer()
                        Text(passport.expiryDate)
                    }
                    HStack {
                        Text("Document Type")
                        Spacer()
                        Text(passport.documentType)
                    }
                    if passport.translatedDocumentType != TranslatedDocumentType.default {
                        HStack {
                            Text("Translated Document Type")
                            Spacer()
                            Text(passport.translatedDocumentType.rawValue)
                        }
                    }
                    HStack {
                        Text("Issuing Authority")
                        Spacer()
                        Text(passport.issuingAuthority)
                    }
                    HStack {
                        Text("Data Hash")
                        Spacer()
                        Text(passport.passportDataValid ? "Yes" : "No")
                    }
                } header: {
                    Text("Personal Information")
                }
                Section {
                    if passport.BACStatus != AuthStatus.skipped {
                        HStack {
                            Text("BAC Authentication")
                            Spacer()
                            Text(passport.BACStatus == AuthStatus.success ? "Succeeded" : "Failed")
                        }
                    }
                    if passport.PACEStatus != AuthStatus.skipped {
                        HStack {
                            Text("PACE Authentication")
                            Spacer()
                            Text(passport.PACEStatus == AuthStatus.success ? "Succeeded" : "Failed")
                        }
                    }
                    if passport.chipAuthenticationStatus != AuthStatus.skipped {
                        HStack {
                            Text("Chip Authentication")
                            Spacer()
                            Text(passport.chipAuthenticationStatus == AuthStatus.success ? "Succeeded" : "Failed")
                        }
                    }
                    if passport.activeAuthenticationStatus != AuthStatus.skipped {
                        HStack {
                            Text("Active Authentication")
                            Spacer()
                            Text(passport.activeAuthenticationStatus == AuthStatus.success ? "Succeeded" : "Failed")
                        }
                    }
                } header: {
                    Text("Authentication")
                }
            }
        }
    }
}
