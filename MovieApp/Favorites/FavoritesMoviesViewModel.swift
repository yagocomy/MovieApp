import Foundation
import MovieAppNetwork
import MovieAppPersistence

final class FavoritesMoviesViewModel {
    
    let movies: Observable<FavoritesMoviesModel?> = Observable(nil)
    let loading: Observable<Bool> = Observable(false)
    let error: Observable<Error?> = Observable(nil)
    let dataTOStore: Observable<FavoritesMoviesModel?> = Observable(nil)
    let isFavoriteEmpty: Observable<Bool> = Observable(true)
    
    func getFavorites() {
        loading.value = true
        MovieAppPersistence.shared.getData(dataType: MoviesPersistentModel.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.loading.value = false
            }
            switch result {
            case .success(let data):
                if data.isEmpty {
                    self?.isFavoriteEmpty.value = true
                } else {
                    self?.isFavoriteEmpty.value = false
                    self?.movies.value = .init(movies: data)
                }
            case .failure(let error):
                self?.error.value = error
            }
        }
    }
}
