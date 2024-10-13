import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
    }
}

enum Errors: Error {
    case URLCreation
    case HTTPResponse
}

func Translate(text: String) async throws {
    let url = URL(string: "url")
    
    guard (url != nil) else {
        throw Errors.URLCreation
    }
    
    let request = URLRequest(url: url!)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    if (response as? HTTPURLResponse)?.statusCode != 200 {
        throw Errors.HTTPResponse
    }
}
