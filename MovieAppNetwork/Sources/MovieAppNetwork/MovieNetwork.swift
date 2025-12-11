import UIKit

public enum MovieRequestType {
    case get
    case post
}

public final class MovieNetwork {
    private init() { }
    
    @MainActor public static let shared = MovieNetwork()
    
    public func request<T: Decodable>(_ url: String, token: String, type: MovieRequestType, response: T.Type, completion: @escaping @Sendable (Result<T, Error>) -> Void) {
        switch type {
        case .get:
            guard let url = URL(string: url) else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                
                do {
                    let users = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(users))
                } catch {
                    completion(.failure(error))
                }
                
            }.resume()
        case .post:
            break
        }
    }
}
