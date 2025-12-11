import UIKit
import MovieAppUI

final class FavoritesMoviesViewController: UIViewController {
    private var movieView = FavoritesMoviesView()
    private var viewModel = FavoritesMoviesViewModel()
    let loader = LoadingScreen()
    
    override func loadView() {
        super.loadView()

        view = movieView
        setupBindings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavorites()
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
        
        viewModel.isFavoriteEmpty.bind { [weak self] isFavoriteEmpty in
            if isFavoriteEmpty {
                self?.movieView.showEmptyMessage(hideMessage: false)
            } else {
                self?.movieView.showEmptyMessage(hideMessage: true)
            }
        }
    }
}
