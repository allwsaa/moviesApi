//
//  ViewController.swift
//  moviesAPI
//
//  Created by ntvlbl on 14.11.2024.
//
import UIKit
import SnapKit

class ViewController: UIViewController {
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = []
    private var genres: [String] = [] 

    private let genreScrollView = UIScrollView()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 16
        let itemWidth = (UIScreen.main.bounds.width - (spacing * 3)) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.7)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMovies()
    }

    private func setupUI() {
        title = "MovieDB"
        view.backgroundColor = .white

        setupGenreScrollView()
        setupCollectionView()
    }

    private func setupGenreScrollView() {
        genreScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(genreScrollView)
        
        genreScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(genreScrollView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func fetchMovies() {
        NetworkingManager.shared.getMovies { [weak self] movies in
            self?.movies = movies
            self?.filteredMovies = movies
            self?.extractGenres()
            self?.setupGenreButtons()
            self?.collectionView.reloadData()
        }
    }

    private func extractGenres() {
        var uniqueGenres: Set<String> = []
        for movie in movies {
            for genreID in movie.genreIDS {
                if let genreName = GenreManager.shared.getGenreName(by: genreID) {
                    uniqueGenres.insert(genreName)
                }
            }
        }
        genres = Array(uniqueGenres).sorted()
    }

    private func setupGenreButtons() {
        let allMoviesButton = UIButton(type: .system)
        allMoviesButton.setTitle("All", for: .normal)
        allMoviesButton.setTitleColor(.black, for: .normal)
        allMoviesButton.backgroundColor = .darkGray
        allMoviesButton.layer.cornerRadius = 15
        allMoviesButton.clipsToBounds = true
        allMoviesButton.addTarget(self, action: #selector(showAllMovies), for: .touchUpInside)
        genreScrollView.addSubview(allMoviesButton)
        
        allMoviesButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(90)
        }

        for (index, genre) in genres.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(genre, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .lightGray
            button.layer.cornerRadius = 15
            button.clipsToBounds = true
            button.tag = index
            button.addTarget(self, action: #selector(genreButtonTapped(_:)), for: .touchUpInside)
            
            genreScrollView.addSubview(button)
            
            button.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset((index + 1) * 100 + 10) // Учитываем "Все фильмы"
                make.centerY.equalToSuperview()
                make.height.equalTo(30)
                make.width.equalTo(90)
            }
        }
        
        genreScrollView.contentSize = CGSize(width: (genres.count + 1) * 100, height: 40)
    }

    @objc private func showAllMovies() {
        filteredMovies = movies
        collectionView.reloadData()
    }

    @objc private func genreButtonTapped(_ sender: UIButton) {
        let selectedGenre = genres[sender.tag]
        filterMovies(by: selectedGenre)
    }

    private func filterMovies(by genre: String) {
        filteredMovies = movies.filter { movie in
            movie.genreIDS.contains { genreID in
                GenreManager.shared.getGenreName(by: genreID) == genre
            }
        }
        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        cell.configure(with: filteredMovies[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = filteredMovies[indexPath.row]
        let detailVC = MovieDetailsViewController(movie: movie)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
