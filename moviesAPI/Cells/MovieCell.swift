//
//  MovieCell.swift
//  moviesAPI
//
//  Created by ntvlbl on 14.11.2024.
//
import UIKit
import SnapKit

class MovieCell: UICollectionViewCell {
    static let identifier = "MovieCell"

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Настройка изображения постера
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10 // Закругленные углы
        posterImageView.layer.masksToBounds = true

        // Настройка заголовка
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2

        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)

        // Расположение элементов в ячейке
        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(1.5) // Соотношение сторон
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview().inset(5)
        }
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        if let posterPath = movie.posterPath {
            NetworkingManager.shared.loadImage(posterPath: posterPath) { [weak self] image in
                self?.posterImageView.image = image
            }
        } else {
            posterImageView.image = UIImage(systemName: "film")
        }
    }
}
