//
//  RatingView.swift
//  Movies
//
//  Created by Anton Petrov on 20.10.2023.
//

import UIKit

final class RatingView: UIView {
    // MARK: - UI Elements

    private let stackView = UIStackView().configure {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = -2
    }

    private let ratingLabel = UILabel().configure {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .white
        $0.textAlignment = .center
    }

    private let votesLabel = UILabel().configure {
        $0.font = UIFont.italicSystemFont(ofSize: 8)
        $0.textColor = .white
        $0.textAlignment = .center
    }

    private let diagramLayer = CAShapeLayer().configure {
        $0.strokeColor = UIColor.red.cgColor
        $0.fillColor = UIColor.clear.cgColor
        $0.lineWidth = 5
    }

    // MARK: - Properties

    private let maxRating: CGFloat = 10.0
    private let decimalStringFormat = "%.1f"
    private var circlePath: UIBezierPath {
        UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                     radius: (bounds.width - diagramLayer.lineWidth) / 2,
                     startAngle: -CGFloat.pi / 2,
                     endAngle: 1.5 * CGFloat.pi, clockwise: true)
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayerAttributes()
    }

    // MARK: - Configuration

    func configure(withRating rating: CGFloat, votes: Int) {
        guard rating >= 0, rating <= maxRating else { return }
        ratingLabel.text = String(format: decimalStringFormat, rating)
        diagramLayer.strokeColor = getColor(for: rating).cgColor
        if rating > 0 {
            diagramLayer.strokeEnd = rating / maxRating
            votesLabel.text = "\(votes)"
        } else {
            diagramLayer.strokeEnd = 1
            votesLabel.text = ""
        }
    }

    // MARK: - Setup

    private func setupViews() {
        backgroundColor = .black
        layer.addSublayer(diagramLayer)
        setupStackView()
    }

    private func setupStackView() {
        addSubview(stackView)
        stackView.center(inView: self)
        stackView.addArrangedSubview(ratingLabel)
        stackView.addArrangedSubview(votesLabel)
    }

    private func setupLayerAttributes() {
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
        diagramLayer.path = circlePath.cgPath
    }

    // MARK: - Helpers

    private func getColor(for rating: CGFloat) -> UIColor {
        guard rating > 0 else { return .red }
        let ratio = rating / maxRating
        if ratio <= 0.5 {
            return UIColor(red: 1, green: ratio * 2, blue: 0, alpha: 1)
        } else {
            return UIColor(red: 1 - (ratio - 0.5) * 2, green: 1, blue: 0, alpha: 1)
        }
    }
}
