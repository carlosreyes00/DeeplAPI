import SwiftUI
import Combine

struct ContentView: View {
    
    @EnvironmentObject var resourceVM: ResourceViewModel
    @State var firstTranslation = ""
    @State var secondTranslation = ""
    @State var translations: [String] = ["Translation no. 1 this one is longer let's see where the limit is", "Translation no. 2"]
    
    var body: some View {
        VStack {
            TextField("Text", text: $resourceVM.selectedResourceTitle, axis: .vertical)
                .onChange(of: resourceVM.debouncedTitle) { title in
                    Task {
                        do {
                            if !title.isEmpty {
                                print(title)
                                async let firstTextTranslated = try await TranslationAPI.translate(textToTranlate: title,
                                                                                                   targetLang: "EN-US")
                                async let secondTextTranslated = try await TranslationAPI.translate(textToTranlate: title,
                                                                                                    targetLang: "FR")
                                try await translations = [firstTextTranslated, secondTextTranslated]
                                
                                print(translations)
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
                .textFieldStyle(MyStyle())
            Group {
                HStack (alignment: .top) {
                    TextField("\(translations[0])", text: $translations[0], axis: .vertical)
                        .foregroundStyle(.blue)
                    Button("EN") {
                        
                    }
                }
                HStack (alignment: .top) {
                    TextField("\(translations[1])", text: $translations[1], axis: .vertical)
                        .foregroundStyle(.orange)
                    Button("FR") {
                        
                    }
                }
            }
            .font(.callout)
            .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding()
    }
}


struct MyStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Gradient(colors: [.blue,.cyan.opacity(0.5),]), lineWidth:2)
            )
    }
}

#Preview {
    ContentView()
}
