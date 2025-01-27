import SwiftUI

@main
struct MyApp: App {
    var resourceVM = ResourceViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(resourceVM)
        }
    }
}
