//
//  MoviewTableViewCell.swift
//  MACAQ-HQ

//  Created by Mohammed Al-Quraini on 2/12/22.
//

import UIKit
import CoreData

class MoviewTableViewCell: UITableViewCell {
    
    // identifier
    static let identifier : String = "MoviewTableViewCell"
    
    // movie image
    private lazy var movieImage : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // star image
    private lazy var favouriteImage : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.tintColor = .systemYellow
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "star")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // title label
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.font = font
        label.textColor = .darkText
        label.numberOfLines = 1
        label.text = "Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // overview label
    private lazy var overviewLabel : UILabel = {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.font = font
        label.textColor = .darkText
        label.numberOfLines = 3
        label.text = "Overview"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // add subviews
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // movie image constraints
        movieImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        movieImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        movieImage.heightAnchor.constraint(equalTo: heightAnchor, constant: -40).isActive = true
        movieImage.widthAnchor.constraint(equalTo: movieImage.heightAnchor, multiplier: 10/9).isActive = true
        
        // title label
        titleLabel.topAnchor.constraint(equalTo: movieImage.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        
        // overview label
        overviewLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20).isActive = true
        overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        overviewLabel.trailingAnchor.constraint(equalTo: favouriteImage.leadingAnchor, constant: -20).isActive = true
        
        // favourite image view
        favouriteImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        favouriteImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        favouriteImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        favouriteImage.widthAnchor.constraint(equalTo: favouriteImage.heightAnchor).isActive = true
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        movieImage.image = nil
        titleLabel.text = nil
        overviewLabel.text = nil
    }
    
    // add subviews
    private func addSubviews(){
        addSubview(movieImage)
        addSubview(titleLabel)
        addSubview(overviewLabel)
        addSubview(favouriteImage)
        
    }
    
    // cell configuration
    func cofigureCell(with movie : Movie, isFavourite : Bool){
        movieImage.cacheImage(from: "\(NetworkURLs.imagePath)\(movie.posterPath)")
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        favouriteImage.image = UIImage(systemName: isFavourite ? "star.fill" : "star")
        
        
    }



}
