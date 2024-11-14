//
//  MovieDetailsViewController.swift
//  moviesAPI
//
//  Created by ntvlbl on 14.11.2024.
//
import UIKit
import SnapKit

class MovieDetailsViewController: UIViewController {
    private let movie: Movie
    private let scrollView = UIScrollView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let ratingLabel = UILabel()
    private let starRatingView = UIStackView()
    private let genreStackView = UIStackView()
    private let overviewLabel = UILabel()
    private let overviewTextLabel = UILabel()

    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure(with: movie)
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "MovieDB"
        
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
  
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10
        scrollView.addSubview(posterImageView)
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.6)
            make.height.equalTo(posterImageView.snp.width).multipliedBy(1.5)
        }
        
     
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        scrollView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
    
        releaseDateLabel.font = .systemFont(ofSize: 16, weight: .medium)
        releaseDateLabel.textColor = .darkGray
        releaseDateLabel.textAlignment = .center
        scrollView.addSubview(releaseDateLabel)
        
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

     
        ratingLabel.font = .systemFont(ofSize: 16, weight: .medium)
        ratingLabel.textColor = .darkGray
        ratingLabel.textAlignment = .center
        scrollView.addSubview(ratingLabel)
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        
        starRatingView.axis = .horizontal
        starRatingView.spacing = 4
        scrollView.addSubview(starRatingView)
        
        starRatingView.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
      
        genreStackView.axis = .horizontal
        genreStackView.spacing = 8
        genreStackView.distribution = .fillEqually
        scrollView.addSubview(genreStackView)
        
        genreStackView.snp.makeConstraints { make in
            make.top.equalTo(starRatingView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
  
        overviewLabel.text = "Overview"
        overviewLabel.font = .boldSystemFont(ofSize: 18)
        scrollView.addSubview(overviewLabel)
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(genreStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
    
        overviewTextLabel.font = .systemFont(ofSize: 16)
        overviewTextLabel.numberOfLines = 0
        scrollView.addSubview(overviewTextLabel)
        
        overviewTextLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func configure(with movie: Movie) {
        titleLabel.text = movie.title
        releaseDateLabel.text = "Release date: \(movie.releaseDate)"
        ratingLabel.text = "\(movie.voteAverage)/10"

   
        let starCount = Int(movie.voteAverage / 2)
        for _ in 0..<starCount {
            let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
            starImageView.tintColor = .orange
            starRatingView.addArrangedSubview(starImageView)
        }
        
        if let posterPath = movie.posterPath {
            NetworkingManager.shared.loadImage(posterPath: posterPath) { [weak self] image in
                self?.posterImageView.image = image
            }
        }
        
      
        for genreID in movie.genreIDS {
            if let genreName = GenreManager.shared.getGenreName(by: genreID) {
                let genreButton = UIButton(type: .system)
                genreButton.setTitle(genreName, for: .normal)
                genreButton.backgroundColor = UIColor(red: 153/255, green: 0, blue: 0, alpha: 1) 
                genreButton.setTitleColor(.white, for: .normal)
                genreButton.layer.cornerRadius = 10
                genreStackView.addArrangedSubview(genreButton)
            }
        }
        
        overviewTextLabel.text = movie.overview
    }
}
