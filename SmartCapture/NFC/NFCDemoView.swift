//
//  NFCDemoView.swift
//  SmartCapture
//
//  Created by Wilmer Barrios on 14/04/26.
//

import SwiftUI
import OzoneNFC

struct NFCDemoView: View {
    private struct FormValues {
        let passportNumber: String
        let dateOfBirth: Date
        let expiryDate: Date
    }

    private enum InMemoryFormStore {
        static var values: FormValues?
    }
    
    // MARK: Use this as developer for testing.
    private let DEFAULT_PASSPORT_NUMBER: String = ""
    private let DEFAULT_BIRTHDAY: String = DocumentKeyDateCodec.string(from: Date())
    private let DEFAULT_EXPIRE_DATE: String = DocumentKeyDateCodec.string(from: Date())
    
    @State private var passportNumber: String
    @State private var selectedDateOfBirth: Date
    @State private var selectedExpiryDate: Date
    
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    @State private var showResultView = false
    @State private var passport: OzoneNFCDocument?
    
    @State private var showOzoneView = false
    @State private var documentKey = OzoneNFCDocumentKey(passportNumber: "", dateOfBirth: "", expiryDate: "")

    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    let ozoneReader = OzoneNFCReader()

    init() {
        let storedValues = InMemoryFormStore.values

        _passportNumber = State(initialValue: storedValues?.passportNumber ?? DEFAULT_PASSPORT_NUMBER)
        _selectedDateOfBirth = State(initialValue: storedValues?.dateOfBirth ?? DocumentKeyDateCodec.date(from: DEFAULT_BIRTHDAY))
        _selectedExpiryDate = State(initialValue: storedValues?.expiryDate ?? DocumentKeyDateCodec.date(from: DEFAULT_EXPIRE_DATE))
    }

    private var currentDocumentKey: OzoneNFCDocumentKey {
        OzoneNFCDocumentKey(
            passportNumber: passportNumber,
            dateOfBirth: DocumentKeyDateCodec.string(from: selectedDateOfBirth),
            expiryDate: DocumentKeyDateCodec.string(from: selectedExpiryDate)
        )
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                SCUIUtil.gbgGradient(for: colorScheme).ignoresSafeArea()

                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        Image(systemName: "wave.3.right.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 54, height: 54)
                            .foregroundColor(.accentColor)

                        Text(String(localized: "GBG NFC Demo", comment: "Title for NFC demo screen"))
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)

                        Text(String(localized: "Enter your passport details to start an NFC document scan.", comment: "Subtitle describing NFC demo purpose"))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }                    
                    .padding(.horizontal, 20)

                    Form {
                        Section("Document Details") {
                            TextField("Passport Number", text: $passportNumber)

                            DatePicker(
                                "Expiry Date",
                                selection: $selectedExpiryDate,
                                displayedComponents: .date
                            )

                            DatePicker(
                                "Date of Birth",
                                selection: $selectedDateOfBirth,
                                displayedComponents: .date
                            )
                        }

                        Section {
                            Text(String(localized: "These values are kept in memory for this app session.", comment: "Information note about form data persistence"))
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }

                        Section {
                            AsyncButton(action: readDocument) {
                                actionLabel(title: String(localized: "Scan", comment: "Button title to start NFC scan"), systemImage: "dot.radiowaves.left.and.right")
                            }
                            .listRowBackground(Color.clear)

                            Button(action: navigateToOzoneNFCView) {
                                actionLabel(title: String(localized: "Start", comment: "Button title to start Ozone NFC flow"), systemImage: "wave.3.right")
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)

                    NavigationLink(destination: OzoneNFCSwiftUIWrapper(documentKey: documentKey, completion: onScanFinished),
                                   isActive: $showOzoneView) {
                        EmptyView()
                    }
                    NavigationLink(destination: NFCResultView(passport: passport), isActive: $showResultView) {
                        EmptyView()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(String(localized: "Error", comment: "Error alert title")), message: Text(errorMessage))
            }
            .onChange(of: passportNumber) { _ in
                saveFormValues()
            }
            .onChange(of: selectedDateOfBirth) { _ in
                saveFormValues()
            }
            .onChange(of: selectedExpiryDate) { _ in
                saveFormValues()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel("Close NFC demo")
                }
            }
        }
    }

    private func actionLabel(title: String, systemImage: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
            Text(title)
        }
        .font(.subheadline.bold())
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background(Color.accentColor)
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(color: Color.accentColor.opacity(0.25), radius: 8, x: 0, y: 4)
    }

    private enum DocumentKeyDateCodec {
        private static let calendar: Calendar = {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = .autoupdatingCurrent
            return calendar
        }()

        private static let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = calendar
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = .autoupdatingCurrent
            formatter.dateFormat = "yyMMdd"
            return formatter
        }()

        static func date(from value: String, fallback: Date = .now) -> Date {
            normalized(formatter.date(from: value) ?? fallback)
        }

        static func string(from date: Date) -> String {
            formatter.string(from: normalized(date))
        }

        private static func normalized(_ date: Date) -> Date {
            let startOfDay = calendar.startOfDay(for: date)
            return calendar.date(byAdding: .hour, value: 12, to: startOfDay) ?? date
        }
    }

    private func saveFormValues() {
        InMemoryFormStore.values = FormValues(
            passportNumber: passportNumber,
            dateOfBirth: selectedDateOfBirth,
            expiryDate: selectedExpiryDate
        )
    }
    
    func readDocument() async {
        guard !passportNumber.isEmpty else {
            errorMessage = String(localized: "Passport number is required", comment: "Error message when passport number is empty")
            showAlert = true
            return
        }
        
        do {
            passport = try await ozoneReader.readDocument(currentDocumentKey)
            showResultView = true
        } catch let error as OzoneNFCError {
            errorMessage = error.localizedDescription
            showAlert = true
        } catch {
            let format = String(localized: "Unexpected error: %@", comment: "Generic error message for unexpected errors")
            errorMessage = String(format: format, error.localizedDescription)
            showAlert = true
        }
    }
    
    func navigateToOzoneNFCView() {
        guard !passportNumber.isEmpty else {
            errorMessage = String(localized: "Passport number is required", comment: "Error message when passport number is empty")
            showAlert = true
            return
        }
        
        documentKey = currentDocumentKey
        showOzoneView = true
    }
    
    func onScanFinished(_ result: Result<OzoneNFCDocument, OzoneNFCError>) {
        switch result {
        case .success(let passport):
            self.passport = passport
            showOzoneView = false
            showResultView = true
        case .failure:
            showOzoneView = false
        }
    }
}

#Preview {
    NFCDemoView()
}
