import UIKit
import Kingfisher

public protocol MovieTableViewCellDelegate: AnyObject {
    func didPressLike(isLiked: Bool, index: Int)
}

public final class MovieTableViewCell: UITableViewCell {
    public static let identifier: String = "MovieTableViewCell"
    
    private lazy var moviewPosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var moviewTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var moviewDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieLikedButton: MovieLikeButton = {
        let button = MovieLikeButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.delegate = self
        return button
    }()
    
    private lazy var expandCollapseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var currentIndex: Int = 0
    private var isStateExpanded: Bool = false
    public var hideLikeButton: Bool = false
    
    public weak var delegate: MovieTableViewCellDelegate?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        if isStateExpanded {
            moviewDescription.numberOfLines = 0
            expandCollapseImageView.image = UIImage(systemName: "chevron.up")
        } else {
            moviewDescription.numberOfLines = 3
            expandCollapseImageView.image = UIImage(systemName: "chevron.down")
        }
    }
    
    private func setupViews() {
        contentView.addSubview(moviewPosterImageView)
        contentView.addSubview(moviewTitle)
        contentView.addSubview(moviewDescription)
        contentView.addSubview(movieLikedButton)
        contentView.addSubview(expandCollapseImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            moviewPosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            moviewPosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            moviewPosterImageView.widthAnchor.constraint(equalToConstant: 60),
            moviewPosterImageView.heightAnchor.constraint(equalToConstant: 60),
            
            moviewTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            moviewTitle.leadingAnchor.constraint(equalTo: moviewPosterImageView.trailingAnchor, constant: 16),
            moviewTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            moviewDescription.topAnchor.constraint(equalTo: moviewTitle.bottomAnchor, constant: 8),
            moviewDescription.leadingAnchor.constraint(equalTo: moviewPosterImageView.trailingAnchor, constant: 16),
            moviewDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            moviewDescription.bottomAnchor.constraint(equalTo: movieLikedButton.topAnchor, constant: -16),
            
            movieLikedButton.widthAnchor.constraint(equalToConstant: 30),
            movieLikedButton.heightAnchor.constraint(equalToConstant: 30),
            movieLikedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            movieLikedButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            expandCollapseImageView.widthAnchor.constraint(equalToConstant: 20),
            expandCollapseImageView.heightAnchor.constraint(equalToConstant: 20),
            expandCollapseImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            expandCollapseImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
    
    public func setupData(image: String, title: String, description: String, index: Int, expanded: Bool = false, hideLikeButton: Bool = false) {
        moviewPosterImageView.kf.setImage(
            with: URL(string: "https://image.tmdb.org/t/p/original\(image)"),
            placeholder: UIImage(systemName: "popcorn.fill"),
            options: [
                .transition(.fade(0.4)),
                .cacheOriginalImage
            ]
        )
        
        moviewTitle.text = title
        moviewDescription.text = description
        currentIndex = index
        isStateExpanded = expanded
        movieLikedButton.isHidden = hideLikeButton
        
        if expanded {
            moviewDescription.numberOfLines = 0
            expandCollapseImageView.image = UIImage(systemName: "chevron.up")
        } else {
            moviewDescription.numberOfLines = 3
            expandCollapseImageView.image = UIImage(systemName: "chevron.down")
            
        }
    }
}

extension MovieTableViewCell: MovieLikeButtonDelegate {
    nonisolated public func didPressLike(isLiked: Bool) {
        delegate?.didPressLike(isLiked: isLiked, index: currentIndex)
    }
}
