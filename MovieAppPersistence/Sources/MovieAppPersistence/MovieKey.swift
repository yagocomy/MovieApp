import Foundation

@MainActor
enum KeyConstants {
    static func loadAPIKeys() async throws  {
        let request = NSBundleResourceRequest(tags: ["APIKey"])
        try await request.beginAccessingResources()
        
        let url = Bundle.main.url(forResource: "APIKey", withExtension: "json")!
        let data = try Data(contentsOf: url)
        APIKeys.storage = try JSONDecoder().decode([String: String].self, from: data)
        
        request.endAccessingResources()
    }
    
    enum APIKeys {
        @MainActor static var storage = [String: String]()
        @MainActor static var accesToken: String { storage["access_token"] ?? "" }
        @MainActor static var apiKey: String { storage["api_key"] ?? "" }
    }
}
