import UIKit
import MovieAppUI
import MovieAppPersistence

final class MoviesViewController: UIViewController {
    private var movieView = MoviesView()
    private var viewModel = MoviesViewModel()
    let loader = LoadingScreen() 
    
    override func loadView() {
        super.loadView()
        
        MovieAppPersistence.shared.persistDataType(data: MoviesPersistentModel.self)
        
        view = movieView
        movieView.delegate = self
        
        setupBindings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchMovies()
    }
    
    private func setupBindings() {
        viewModel.movies.bind { [weak self] data in
            self?.movieView.data = data?.movies
        }
        
        viewModel.loading.bind { [weak self] isLoading in
            guard let self = self else {
                return
            }
            
            if isLoading {
                self.loader.show(in: self.view)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self.loader.hide()
                }
            }
        }
        
        viewModel.error.bind { [weak self] error in
            if error != nil {
                self?.movieView.showMessage()
            }
        }
    }
}

extension MoviesViewController: MoviesViewDelegate {
    func didPressLike(isLike: Bool, index: Int) {
        viewModel.saveToFavorites(index: index)
    }
}

