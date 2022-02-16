//
//  MovieDetailViewController.swift
//  MACAQ-HQ
//
//  Created by Mohammed Al-Quraini on 2/11/22.
//

import UIKit
import Combine

class MovieDetailViewController: UIViewController {
    private let movie : Movie

    
    init(movie: Movie) {
            self.movie = movie
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    // combine
    private let viewModelCombine = ViewModelCombine.shared
    private let viewModelCompletion = ViewModelCompletion()
    
    private var subscribers = Set<AnyCancellable>()
    
    private var isFavourite : Bool = false
    
    private lazy var productionCompanies = [ProductionCompany]()
    
    // image view
    private lazy var movieImage : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray6
        imageView.cacheImage(from: "\(NetworkURLs.imagePath)\(movie.posterPath)")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // title label
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.font = font
        label.textColor = .darkText
        label.numberOfLines = 0
        label.text = movie.originalTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // overview label
    private lazy var overviewLabel : UILabel = {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.font = font
        label.textColor = .darkText
        label.numberOfLines = 0
        label.text = movie.overview
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var favouriteButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.layer.cornerRadius = button.bounds.size.width / 2
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.tintColor = .systemYellow
        button.backgroundColor = .systemGray6
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    // collection view
    private lazy var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.size.width/1), height: (view.frame.size.width/3))
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductionCompanyCollectionViewCell.self, forCellWithReuseIdentifier: ProductionCompanyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return collectionView
    }()
    
    
    //MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // add subview
        addSubviews()
        
        // set up binding
        setUpBinding()
        
        // updateUI
        updateUI()
    }
    
    // view did disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // cancel all subscriptions
        subscribers.cancelAll()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // safe area
        let safeArea = view.safeAreaLayoutGuide
        
        // movie image constraints
        movieImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20).isActive = true
        movieImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20).isActive = true
        movieImage.heightAnchor.constraint(equalToConstant: 250).isActive = true
        movieImage.widthAnchor.constraint(equalTo: movieImage.heightAnchor, multiplier: 3/4).isActive = true
        
        // title label
        titleLabel.topAnchor.constraint(equalTo: movieImage.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30).isActive = true
        
        // overview label
        overviewLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20).isActive = true
        overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        overviewLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10).isActive = true
        
        // favourite button
        favouriteButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20).isActive = true
        favouriteButton.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 20).isActive = true
        favouriteButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        favouriteButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        // collection view constraints
        collectionView.topAnchor.constraint(equalTo: favouriteButton.bottomAnchor, constant: 40).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
   
    }
    
    
    //MARK: - Functions
    
    // add subviews
    private func addSubviews(){
        view.addSubview(movieImage)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(favouriteButton)
        view.addSubview(collectionView)
    }
    
    // binding
    private func setUpBinding() {
        // fetch data from local storage
        viewModelCombine
            .$movieIds
            .receive(on: RunLoop.main)
            .sink(receiveValue: { favourites in
                self.isFavourite = favourites.contains(self.movie.id)
                self.updateUI()
            })
            .store(in: &subscribers)
        
        viewModelCombine.fetchCoreData()
        
        // production completion
        viewModelCompletion.getProductionCompanies(movie.id) { [weak self] productionCompanies in
            self?.productionCompanies = productionCompanies
            DispatchQueue.main.async {
                self?.collectionView.reloadData()

            }
        }
    }
    
    // updata UI
    private func updateUI(){
        if isFavourite {
            favouriteButton.imageView?.tintColor = .white
            favouriteButton.backgroundColor = .systemYellow
        } else {
            favouriteButton.imageView?.tintColor = .systemYellow
            favouriteButton.backgroundColor = .systemGray6
        }
    }
    
    // save movie
    @objc private func favouriteButtonPressed(){
        if !isFavourite {
            viewModelCombine.saveMovie(movie.id)
        } else {
            viewModelCombine.deleteData(movie.id)
        }
    }

}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MovieDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productionCompanies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductionCompanyCollectionViewCell.identifier, for: indexPath)
                as! ProductionCompanyCollectionViewCell
        cell.configureCell(with: productionCompanies[indexPath.row])
        
        return cell
    }
    
    
}
