import SwiftData

public class MovieAppPersistence {
    @MainActor public static let shared = MovieAppPersistence()
    
    private var container: ModelContainer?
    private var context: ModelContext?
    
    private init() { }
    
    
    public func persistDataType<T: PersistentModel>(data: T.Type) {
        setupService(data: data)
    }
    
    public func saveData<T: PersistentModel>(data: T) {
        context?.insert(data)
    }
    
    public func getData<T: PersistentModel>(dataType: T.Type, completion: @escaping (Result<[T], Error>) -> Void) {
        extractData(type: dataType) { result in
            switch result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    private func setupService<T: PersistentModel>(data: T.Type) {
        do {
            container = try ModelContainer(for: data.self)
            if let container {
                context = ModelContext(container)
            }
        } catch {
            print("Error initializing database container:", error)
        }
    }
    
    private func extractData<T: PersistentModel>(type: T.Type, completion: (Result<[T], Error>) -> Void) {
        let descriptor = FetchDescriptor<T>()
        
        if let context = context {
            do {
                let data = try context.fetch(descriptor)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.success([]))
        }
    }
}
