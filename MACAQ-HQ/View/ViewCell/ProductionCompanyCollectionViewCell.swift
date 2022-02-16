//
//  ProductionCompanyCollectionViewCell.swift
//  MACAQ-HQ
//
//  Created by Mohammed Al-Quraini on 2/16/22.
//

import UIKit

class ProductionCompanyCollectionViewCell: UICollectionViewCell {
    static let identifier : String = "ProductionCompanyCollectionViewCell"
    
    
    // production company image view
    private lazy var pcImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // name label
    private lazy var nameLabel : UILabel = {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.font = font
        label.textColor = .darkText
        label.numberOfLines = 1
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // add subviews
        addSubviews()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // pc image view constraints
        pcImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pcImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        pcImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        pcImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3).isActive = true
        
        // name label
        nameLabel.topAnchor.constraint(equalTo: pcImageView.bottomAnchor, constant: 10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // add subviews
    private func addSubviews(){
        addSubview(pcImageView)
        addSubview(nameLabel)
        
    }
    
    // cell configuration
    func configureCell(with model : ProductionCompany){
        if let logoPath = model.logoPath {
            pcImageView.cacheImage(from: "\(NetworkURLs.imagePath)\(logoPath)")
        }
        
        nameLabel.text = model.name
    }


}
