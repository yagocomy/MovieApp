import UIKit

public class LoadingScreen: UIView {

    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()

    private let spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(blurView)
        blurView.contentView.addSubview(spinner)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),

            spinner.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: blurView.centerYAnchor)
        ])
    }

    public func show(in parent: UIView) {
        parent.addSubview(self)

        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            centerYAnchor.constraint(equalTo: parent.centerYAnchor),
            widthAnchor.constraint(equalToConstant: 120),
            heightAnchor.constraint(equalToConstant: 120)
        ])

        spinner.startAnimating()
        alpha = 0
        UIView.animate(withDuration: 0.25) { self.alpha = 1 }
    }

    public func hide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { _ in
            self.spinner.stopAnimating()
            self.removeFromSuperview()
        }
    }
}
