## Invoice App (ProductCatalogApp)

### Overview
This is a SwiftUI iOS/macCatalyst app for managing invoices, customers, products, inventory, and payment receipts. Data is persisted with SwiftData and synchronized via CloudKit using a private iCloud container.

The app launches into a `Dashboard` composed from modular Swift Package components. Core domain models such as `Product`, `Inventory`, `Customer`, `Invoice`, `LineItem`, and `PaymentReceipt` are stored in a single SwiftData `ModelContainer` backed by CloudKit.

### Architecture and Modules
- **SwiftUI + SwiftData**: UI and persistence.
- **CloudKit**: Private database sync via container `iCloud.<hidden>`.
- **Modular SPM packages** (fetched via SSH):
  - **Core**: `git@github.com:aftabahmed1286/Core.git`
  - **Customer**: `git@github.com:aftabahmed1286/Customer.git`
  - **Dashboard**: `git@github.com:aftabahmed1286/Dashboard.git`
  - **Inventory**: `git@github.com:aftabahmed1286/Inventory.git`
  - **Invoice**: `git@github.com:aftabahmed1286/Invoice.git`
  - **PaymentReceipt**: `git@github.com:aftabahmed1286/PaymentReceipt.git`
  - **Product**: `git@github.com:aftabahmed1286/Product.git`

These packages are pinned on the `main` branch via Swift Package Manager (see `ProductCatalogApp.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`). You will need SSH access to `github.com` for the above repos.

### Requirements
- **Xcode**: 16
- **Apple Developer account** with iCloud capability
- **GitHub SSH key** configured locally for private repo access
- **Platforms**: iOS 26+ and/or macCatalyst 26+ (depending on your scheme/target)
- **Minimum deployment targets**: iOS 26, macCatalyst 26

### App Capabilities
- **iCloud (CloudKit)**: Uses private database with container `iCloud.<hidden>`
- **Background Modes**: `remote-notification` enabled (see `Info.plist`)

### Project Entry Point
- `ProductCatalogApp/App/ProductCatalogAppApp.swift` defines `@main` and creates a shared `ModelContainer`:
  - Models: `Product`, `Inventory`, `Customer`, `Invoice`, `LineItem`, `PaymentReceipt`
  - CloudKit configuration: private database on container `iCloud.<hidden>`
  - Root view: `Dashboard()`

### Getting Started
1. **Clone the repo**
   - Ensure your SSH key is added to your GitHub account.
   - Example: `git clone git@github.com:<your-org-or-user>/ProductCatalogApp.git`

2. **Open the project**
   - Open `ProductCatalogApp.xcodeproj` in Xcode.

3. **Resolve Swift Packages**
   - Xcode will automatically resolve packages on open.
   - If prompted, ensure you have SSH access to the listed package repos.

4. **Configure Signing & Capabilities**
   - In your target’s Signing settings, select your team.
   - Add the **iCloud** capability and choose your private container (e.g., `iCloud.<hidden>`).
   - Ensure **Background Modes** includes `Remote notifications`.

5. **CloudKit setup**
   - First run should be on a device/simulator signed-in to iCloud.
   - In development, SwiftData + CloudKit will create the container schema as needed. You can later deploy the schema in the CloudKit Dashboard if required.

6. **Run**
   - Select an iOS 26+ simulator or a device, then Build & Run.

### Troubleshooting
- **SPM package resolution fails (SSH)**
  - Verify SSH access: `ssh -T git@github.com`
  - Confirm your GitHub account has access to the private repos.
  - If needed, switch the package URLs to HTTPS in Xcode > Package Dependencies.

- **CloudKit errors (permission/container)**
  - Ensure iCloud is enabled in Signing & Capabilities and the container ID matches your private container (e.g., `iCloud.<hidden>`).
  - Make sure the Apple ID on your device/simulator is signed in to iCloud.

- **Schema or record type issues**
  - Clean build folder and run again to let SwiftData reinitialize.
  - In CloudKit Dashboard, verify the private database has the expected record types after a development run.

### Repository Layout (excerpt)
- `ProductCatalogApp/App/ProductCatalogAppApp.swift` — App entry and CloudKit/SwiftData setup
- `ProductCatalogApp/Info.plist` — App Info and background modes
- `ProductCatalogApp.xcodeproj` — Xcode project and SwiftPM configuration
- `Resources/Assets.xcassets` — App assets and icons

### License

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
