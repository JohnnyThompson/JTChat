//
//  InitialsImageView.swift
//  JTChat
//
//  Created by Евгений Карпов on 19.03.2022.
//

import UIKit

final class InitialsImageView: UIImageView {
    
    // MARK: - Private properties
    
    private var fullName: String

    // MARK: - Views
    
    private lazy var initialsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainText()
        label.font = .helvetica120Medium
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        return label
    }()

    // MARK: - Initialization
    
    init(fullName: String) {
        self.fullName = fullName
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fullName = ""
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Private methods
    
    private func setupUI() {
        configureViews()
        changeName(with: fullName)
        setupConstraints()
    }

    private func configureViews() {
        self.backgroundColor = .profileImageBackground()
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(initialsLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            initialsLabel.topAnchor.constraint(equalTo: self.topAnchor),
            initialsLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 20),
            initialsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            initialsLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - InitialsImageViewProtocol

extension InitialsImageView: InitialsImageViewProtocol {
    func changeName(with fullName: String?) {
        guard let fullName = fullName, !fullName.isEmpty else {
            makeLabelVisible(false)
            return
        }
        
        let words = fullName.components(separatedBy: " ")
        var result: String = ""
        words.forEach {
            guard let element = $0.first else {
                return
            }
            
            result += String(element)
        }
        initialsLabel.text = result
    }
    
    func makeLabelVisible(_ isVisible: Bool) {
        initialsLabel.isHidden = !isVisible
    }
}
