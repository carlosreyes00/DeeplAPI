import SwiftUI
import Combine

struct ContentView: View {
    
    @EnvironmentObject var resourceVM: ResourceViewModel
    
    var body: some View {
        TextField("Text", text: $resourceVM.selectedResourceTitle)
            .onChange(of: resourceVM.debouncedTitle) { title in
                print(title)
            }
            .padding()
    }
}

#Preview {
    ContentView()
}
