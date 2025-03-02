//
//  Model.swift
//  DeeplAPI
//
//  Created by Carlos Reyes on 12/17/24.
//

import Foundation

class TranslationAPI {
    
    static func translate(textToTranlate: String, targetLang: String = "EN-US") async throws -> String {
        print("...trying to translate: \(textToTranlate)")
        
        let apiKey = "da92502c-e4fe-44e6-b608-e74aaa48d87a:fx"
        
        guard let url = URL(string: "https://api-free.deepl.com/v2/translate") else {
            throw CustomError.URLCreation
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
            "target_lang": "\(targetLang)"
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw CustomError.HTTPResponse
        }
        
        //        let translation = try JSONSerialization.jsonObject(with: data) as? String
        let translation = try JSONDecoder().decode(TranslationsResponse.self, from: data)
        //        return translation ?? "Not able to serializate JSON"
        return translation.translations.first?.text ?? "something went wrong"
        
    }
}

class ResourceViewModel: ObservableObject {
    @Published var selectedResourceTitle = ""   //to store real-time value
    @Published var debouncedTitle = ""          //to store debounced value
    
    init() {
        setupTitleDebounce()
    }
    
    func setupTitleDebounce() {
        debouncedTitle = self.selectedResourceTitle
        $selectedResourceTitle
            .debounce(for: .seconds(0.75), scheduler: RunLoop.main)
            .assign(to: &$debouncedTitle)
    }
}

enum CustomError: Error {
    case URLCreation
    case HTTPResponse
    case JSONSerialization
}

struct TranslationsResponse: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let detectedSourceLanguage: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case detectedSourceLanguage = "detected_source_language"
        case text
    }
}
