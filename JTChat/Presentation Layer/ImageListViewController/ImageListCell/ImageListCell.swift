//
//  ImageListCell.swift
//  JTChat
//
//  Created by Evgeny on 28.04.2022.
//

import UIKit

class ImageListCell: UICollectionViewCell {
    // MARK: - Public properties
    
    let imageService: ImageServiceProtocol = ImageService()
    
    // MARK: - Views
    
    private lazy var shadowView: ShadowView = {
        let shadowView = ShadowView()
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        
        return shadowView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.isHidden = false
        ai.style = .large
        ai.translatesAutoresizingMaskIntoConstraints = false
        
        return ai
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .mainText()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    // MARK: - Public methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        activityIndicator.stopAnimating()
    }
}

// MARK: - ImageListCellProtocol

extension ImageListCell: ImageListCellProtocol {
    func setupUI(with stringURL: String) {
        self.addSubview(shadowView)
        shadowView.addSubview(imageView)
        shadowView.addSubview(activityIndicator)
        setupConstraints()
        activityIndicator.startAnimating()
        imageService.getImageData(with: stringURL) { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let data):
                self.imageView.image = UIImage(data: data)
            case .failure:
                self.imageView.image = UIImage(systemName: "camera.circle")
            }
        }
    }
}

// MARK: - SetupConstraints

extension ImageListCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: self.topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: shadowView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: shadowView.centerYAnchor),
            
            imageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor)
        ])
    }
}
