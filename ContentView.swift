import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
                .task {
                    do {
                        try await Translate(textToTranlate: "hola a todos, cómo están?")
                    } catch {
                        print(error)
                    }
                }
        }
    }
}

enum NetworkError: Error {
    case URLCreation
    case HTTPResponse
}

func Translate(textToTranlate: String) async throws {
    
    let apiKey = "da92502c-e4fe-44e6-b608-e74aaa48d87a:fx"
    
    guard let url = URL(string: "https://api-free.deepl.com/v2/translate") else {
        throw NetworkError.URLCreation
    }
    
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = [
        "Host": "api-free.deepl.com",
        "Authorization": "DeepL-Auth-Key \(apiKey)",
        "User-Agent": "YourApp/1.2.3",
        "Content-Length": "45",
        "Content-Type": "application/json"
    ]
    
    let body: [String: Any] = [
        "text": ["\(textToTranlate)"],
        "target_lang": "EN-US"
    ]
    
    request.httpBody = try JSONSerialization.data(withJSONObject: body)
    
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        throw NetworkError.HTTPResponse
    }
    
    print(try JSONSerialization.jsonObject(with: data))
    
}
