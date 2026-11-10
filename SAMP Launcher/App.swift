import SwiftUI

@main
struct SAMPLauncherApp: App {
    @StateObject private var store = ServerStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
