//
//  ImageListViewController.swift
//  JTChat
//
//  Created by Evgeny on 27.04.2022.
//

import UIKit

class ImageListViewController: EmittedViewController {
    // MARK: - Properties
    
    private let imageNetworkService: ImagesNetworkServiceProtocol = ImagesNetworkService()
    private let reuseIdentifier = "collectionCell"
    
    private var images: Images = []
    private var cellSide: CGFloat {
        return (collectionView.frame.width - Constant.offset * 2) / 3
    }
    
    private weak var updatableVC: Updatable?
    
    // MARK: - Views
    
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .mainBackground
        
        return collectionView
    }()
    
    // MARK: - Initialization
    
    init(updatableVC: Updatable) {
        super.init(nibName: nil, bundle: nil)
        self.updatableVC = updatableVC
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        collectionView.register(ImageListCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        imageNetworkService.fetchImages { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let images):
                self.images = images
                self.collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        setupConstraints()
    }
}

// MARK: - UICollectionViewDataSource

extension ImageListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        guard let imageCell = cell as? ImageListCellProtocol else {
            return cell
        }
        
        imageCell.setupUI(with: images[indexPath.item].previewURL)
        
        return imageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
}

// MARK: - UICollectionViewDelegate

extension ImageListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stringURL = images[indexPath.row].webformatURL
        updatableVC?.updateAndSave(with: stringURL)
        self.dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: cellSide, height: cellSide)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constant.offset
    }
}

// MARK: - Setup constraints

extension ImageListViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.offset),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constant.inset),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constant.offset),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constant.inset)
        ])
    }
}

// MARK: - Constants

extension ImageListViewController {
    private struct Constant {
        static let offset: CGFloat = 16
        static let inset: CGFloat = -16
    }
}
