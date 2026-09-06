# Infinity-Marble-Design-iPhone-CRM
CRM
Native SwiftUI conversion of the supplied `infinity-marble-crm.tsx` interface.

Included:
- Pipeline: Inquiry → Quoted → Approved → Fabrication → Installed
- Clients
- Inventory / collections
- Project editor
- Quote and invoice numbering
- WhatsApp deep link with pre-filled CRM message
- Business settings and webhook field
- Local persistence using UserDefaults + Codable
- iPhone touch-first navigation with TabView, NavigationStack, sheets, swipe actions and native forms

Target: iOS 17+

The supplied React app used `window.storage`; this conversion replaces that browser-only persistence with native local persistence. The WhatsApp webhook is retained as a configuration field, but direct network POST integration should be added through a secure backend/n8n endpoint rather than exposing credentials in the app.

Open the Swift files in a new Xcode iOS App project named `InfinityMarbleCRM`, target iOS 17+, and add all files to the target.
