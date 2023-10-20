//
//  SearchTableViewCell.swift
//  Movies
//
//  Created by Anton Petrov on 19.10.2023.
//

import Kingfisher
import UIKit

final class SearchTableViewCell: UITableViewCell {
    // MARK: - UI Elements

    private let containerView = UIView().configure {
        $0.layer.cornerRadius = Constants.StyleDefaults.cornerRadius
        $0.layer.shadowColor = UIColor.darkGray.cgColor
        $0.layer.shadowOffset = CGSize(width: 3, height: 3)
        $0.layer.shadowRadius = 3
        $0.layer.shadowOpacity = 0.4
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.layer.borderWidth = 0.5
    }

    private let posterImageView = UIImageView().configure {
        $0.kf.indicatorType = .activity
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = Constants.StyleDefaults.cornerRadius
    }

    private let gradientLayer = CAGradientLayer().configure {
        $0.colors = [UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        $0.locations = [0, 0.3, 0.7, 1]
    }

    private let noPosterLabel = NoPosterLabel()

    private let topHorizontalStackView = UIStackView().configure {
        $0.alignment = .top
    }

    private let titleLabel = UILabel().configure {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textColor = .white
        $0.numberOfLines = 0
    }

    private let yearLabel = UILabel().configure {
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textColor = .white
        $0.textAlignment = .right
        $0.numberOfLines = 1
    }

    private let bottomHorizontalStackView = UIStackView().configure {
        $0.alignment = .bottom
    }

    private let genresLabel = UILabel().configure {
        $0.font = .italicSystemFont(ofSize: 13)
        $0.textColor = .white
    }

    private let ratingView = RatingView()

    // MARK: - Properties

    static let reuseIdentifier = String(describing: SearchTableViewCell.self)
    private let smallPadding = Constants.StyleDefaults.smallPadding
    private let mediumPadding = Constants.StyleDefaults.mediumPadding
    private let bigItemSideSize = Constants.StyleDefaults.bigItemSideSize
    private let loaderFadeInterval: TimeInterval = 0.3

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupContainerView()
        setupImageView()
        setupTopElements()
        setupBottomElements()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        gradientLayer.frame = posterImageView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
        titleLabel.text = nil
        yearLabel.text = nil
        genresLabel.text = nil
        noPosterLabel.isHidden = true
        ratingView.configure(withRating: 0, votes: 0)
    }

    // MARK: - Configuration

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        genresLabel.text = movie.genres.map { $0.name }.joined(separator: Constants.StyleDefaults.pointSeparator)
        ratingView.configure(withRating: movie.rating, votes: movie.votes)
        let url = URL(string: movie.backdropImageURLString ?? movie.posterImageURLString ?? "")
        posterImageView.kf.setImage(with: url,
                                    options: [.transition(.fade(loaderFadeInterval))]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.noPosterLabel.isHidden = true
            case .failure:
                self.noPosterLabel.isHidden = false
            }
        }
    }

    // MARK: - Setup

    private func setupContainerView() {
        contentView.addSubview(containerView)
        containerView.anchor(top: topAnchor,
                             left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             paddingTop: smallPadding,
                             paddingLeft: mediumPadding,
                             paddingBottom: smallPadding,
                             paddingRight: mediumPadding)
    }

    private func setupImageView() {
        containerView.addSubview(posterImageView)
        posterImageView.fillSuperview()
        posterImageView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = posterImageView.bounds
        posterImageView.addSubview(noPosterLabel)
        noPosterLabel.fillSuperview()
    }

    private func setupTopElements() {
        containerView.addSubview(topHorizontalStackView)
        topHorizontalStackView.anchor(top: containerView.topAnchor,
                                      left: containerView.leftAnchor,
                                      right: containerView.rightAnchor,
                                      paddingTop: mediumPadding,
                                      paddingLeft: mediumPadding,
                                      paddingRight: mediumPadding)
        topHorizontalStackView.addArrangedSubview(titleLabel)
        topHorizontalStackView.addArrangedSubview(yearLabel)
    }

    private func setupBottomElements() {
        containerView.addSubview(bottomHorizontalStackView)
        bottomHorizontalStackView.anchor(left: containerView.leftAnchor,
                                         bottom: containerView.bottomAnchor,
                                         right: containerView.rightAnchor,
                                         paddingLeft: mediumPadding,
                                         paddingBottom: mediumPadding,
                                         paddingRight: mediumPadding)
        bottomHorizontalStackView.addArrangedSubview(genresLabel)
        bottomHorizontalStackView.addArrangedSubview(ratingView)
        ratingView.setDimensions(height: bigItemSideSize, width: bigItemSideSize)
    }
}
