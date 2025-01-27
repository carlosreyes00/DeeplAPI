import SwiftUI
import Combine

struct ContentView: View {
    
    @EnvironmentObject var resourceVM: ResourceViewModel
    @State var textTranslated = ""
    
    
    var body: some View {
        Form {
            TextField("Text", text: $resourceVM.selectedResourceTitle)
                .onChange(of: resourceVM.debouncedTitle) { title in
                    Task {
                        do {
                            if !title.isEmpty {
                                print(title)
                                textTranslated = try await TranslationAPI.translate(textToTranlate: title)
                                print(textTranslated)
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            Text("\(textTranslated)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
