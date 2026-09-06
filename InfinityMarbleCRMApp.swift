import SwiftUI

@main
struct InfinityMarbleCRMApp: App {
    @State private var store = CRMStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
        }
    }
}
