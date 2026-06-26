iOS Smart Capture
================

Repo containing demos for the Face, Document, and NFC components.

## Available Demos

This project provides three main demo modules:

### 1. Document

- **Description:**  
  Scan a document using your device's camera. The app performs quality checks (sharpness, glare, resolution) and displays the results with capture metadata.
- **How to Run:**  
  Select **Document** from the home screen and follow the instructions.

### 2. Face

- **Description:**  
  Capture a user's face and validate liveness (real person detection).
- **How to Run:**  
  Select **Face** from the home screen and follow the instructions.

### 3. NFC

- **Description:**  
  Read an electronic passport (ePassport) chip via NFC. The app communicates with the passport's LDS1 application using the Ozone SDK and displays the retrieved chip data.
- **How to Run:**  
  Select **NFC** from the home screen and follow the instructions. A physical NFC-capable device and an ePassport are required.

---

## NFC Setup

### Capabilities

Both NFC capabilities must be enabled in Xcode:
- [Apple — How to add a capability](https://help.apple.com/xcode/mac/current/#/dev88ff319e7)
- [Apple — NFC required capabilities](https://developer.apple.com/documentation/CoreNFC/building-an-nfc-tag-reader-app#Configure-the-App-to-Detect-NFC-Tags)

Required tags under **NFC Tag Reading**:
- `NDEF`
- `TAG`

### Info.plist

The following entry is required to read ePassports. `A0000002471001` is the globally standardised Application Identifier (AID) for LDS1 — the core application on all electronic passports ([ICAO Doc 9303 Part 10, Section 3.6.1](https://www.icao.int/publications/doc-series/doc-9303)):

```xml
<key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
<array>
    <string>A0000002471001</string>
</array>
```

---

## Dependencies

To run the demos, the following dependencies are required:

- All `.xcframework` files must be placed in the `Dependencies` folder (provided separately).
- Required frameworks:
  - `Dependencies/document/Document.xcframework`
  - `Dependencies/facecamera/FaceCamera.xcframework`
  - `Dependencies/idrnd/IDLiveFaceCamera.xcframework`
  - `Dependencies/idrnd/IDLiveFaceIAD.xcframework`
  - `Dependencies/smart-capture/IDSSmartCapture.xcframework`
  - `Dependencies/smart-capture/IDSSmartCaptureResources.bundle`
  - `Dependencies/ozone/OzoneNFC.xcframework`
- Additional frameworks to be installed via Carthage:
  - `git "git@github.com:gbgplc-internal/identity-idscan-camera-ios.git" "main"`
  - `binary "lottie-ios.json" == 4.6.0`
  - `github "krzyzanowskim/OpenSSL" "1.1.2301"`

Run script to install:
  ```sh
  carthage update --use-xcframeworks
