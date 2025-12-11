import Foundation
import MovieAppNetwork
import MovieAppPersistence

final class MoviesViewModel {
    
    let movies: Observable<MoviesModel?> = Observable(nil)
    let loading: Observable<Bool> = Observable(false)
    let error: Observable<Error?> = Observable(nil)
    let dataTOStore: Observable<MoviesModel?> = Observable(nil)
    
    func fetchMovies() {
        loading.value = true
        
        MovieNetwork.shared.request(
            "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1",
            token: KeyAccess.APIKeys.accesToken,
            type: .get,
            response: MoviesRequestModel.self) {
                [weak self] result in
                
                DispatchQueue.main.async {
                    self?.loading.value = false
                }
                
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.movies.value = .init(movies: data)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.error.value = error
                    }
                }
            }
    }
    
    func saveToFavorites(index: Int) {
        let result = ResultPersistent(
            adult: movies.value?.movies.results[safe: index]?.adult ?? false,
            backdropPath: movies.value?.movies.results[safe: index]?.backdropPath ?? "",
            genreIDS: movies.value?.movies.results[safe: index]?.genreIDS ?? [],
            id: movies.value?.movies.results[safe: index]?.id ?? 0,
            originalLanguage: movies.value?.movies.results[safe: index]?.originalLanguage ?? "",
            originalTitle: movies.value?.movies.results[safe: index]?.originalTitle ?? "",
            overview: movies.value?.movies.results[safe: index]?.overview ?? "",
            popularity: movies.value?.movies.results[safe: index]?.popularity ?? 0,
            posterPath: movies.value?.movies.results[safe: index]?.posterPath ?? "",
            releaseDate: movies.value?.movies.results[safe: index]?.releaseDate ?? "",
            title: movies.value?.movies.results[safe: index]?.title ?? "",
            video: movies.value?.movies.results[safe: index]?.video ?? false,
            voteAverage: movies.value?.movies.results[safe: index]?.voteAverage ?? 0,
            voteCount: movies.value?.movies.results[safe: index]?.voteCount ?? 0
        )
        
        MovieAppPersistence.shared.persistDataType(data: MoviesPersistentModel.self)
        MovieAppPersistence.shared.saveData(
            data: MoviesPersistentModel(
                id: UUID().uuidString,
                page: movies.value?.movies.page ?? 0,
                results: result,
                totalPages: movies.value?.movies.totalPages ?? 0,
                totalResults: movies.value?.movies.totalResults ?? 0)
        )
    }
    
    func getMoviesFromPersistence(completion: @escaping (Result<[MoviesPersistentModel], Error>) -> Void) {
        MovieAppPersistence.shared.getData(dataType: MoviesPersistentModel.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension Collection {
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
