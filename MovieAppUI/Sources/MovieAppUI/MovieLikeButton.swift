import UIKit

public protocol MovieLikeButtonDelegate: AnyObject {
    func didPressLike(isLiked: Bool)
}

public class MovieLikeButton: UIButton {
    private var isLiked = false {
        didSet {
            updateUI()
        }
    }
    
    private lazy var likedMovie: UIImage = {
        let image = UIImage(systemName: "heart.fill")!
        return image
    }()
    
    private lazy var unlikedMovie: UIImage = {
        let image = UIImage(systemName: "heart")!
        return image
    }()
    
    public weak var delegate: MovieLikeButtonDelegate?
    
    public init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI() {
        let image = isLiked ? likedMovie : unlikedMovie
        setImage(image, for: .normal)
        
        tintColor = isLiked ? .red : .gray
    }
    
    @objc private func tapped() {
        isLiked.toggle()
        delegate?.didPressLike(isLiked: isLiked)
    }
}
