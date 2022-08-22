//
//  ProfileView.swift
//  JTChat
//
//  Created by Evgeny on 18.04.2022.
//

import UIKit

class ProfileView: UIView {
    
    // MARK: - Private properties
    
    private let photoViewSize: CGFloat
    private let saveButtonWidth: CGFloat
    private let delegate: ProfileViewDelegate?
    private let textFieldDelegate: UITextFieldDelegate?
    
    // MARK: - Views
    
    private lazy var headerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .navigationBackground()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "My Profile"
        label.font = .helvetica26Bold
        label.textColor = .mainText()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "headerLabel"
        
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.titleLabel?.font = .helvetica19Medium
        button.titleLabel?.textAlignment = .right
        button.setTitleColor(.mainText(), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "cancelButton"
        
        return button
    }()
    
    private lazy var photoImage: InitialsImageViewProtocol = {
        let view = InitialsImageView(fullName: "Имя Фамилия")
        view.layer.cornerRadius = photoViewSize / 2
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "photoImage"
        
        return view
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainBackground
        button.layer.cornerRadius = photoViewSize / 6
        button.addTarget(self, action: #selector(editImageButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "editButton"
        
        return button
    }()
    
    private lazy var editButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera.circle")
        imageView.tintColor = .mainText()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.isHidden = true
        ai.style = .large
        ai.color = .mainText()
        ai.translatesAutoresizingMaskIntoConstraints = false
        
        return ai
    }()
    
    private lazy var fullNameTextField: UITextField = {
        let textField = ProfileTextField(placeholder: "Имя Фамилия", font: .helvetica24Bold)
        textField.delegate = textFieldDelegate
        textField.accessibilityIdentifier = "fullNameTextField"
        
        return textField
    }()
    
    private lazy var aboutMeTextField: UITextField = {
        let textField = ProfileTextField(placeholder: "О себе")
        textField.delegate = textFieldDelegate
        textField.accessibilityIdentifier = "aboutMeTextField"
        
        return textField
    }()
    
    private lazy var locationTextField: UITextField = {
        let textField = ProfileTextField(placeholder: "Город, страна")
        textField.delegate = textFieldDelegate
        textField.accessibilityIdentifier = "locationTextField"
        
        return textField
    }()
    
    private lazy var saveChangesButton: ProfileButton = {
        let button = ProfileButton(title: "Save")
        button.accessibilityIdentifier = "saveChangesButton"
        return button
    }()
    private lazy var editProfileButton: ProfileButton = {
        let button = ProfileButton(title: "Edit")
        button.accessibilityIdentifier = "editProfileButton"
        return button
    }()
    private lazy var cancelChangesButton: ProfileButton = {
        let button = ProfileButton(title: "Cancel")
        button.accessibilityIdentifier = "cancelChangesButton"
        return button
    }()
    
    // MARK: - Initialization
    
    init(delegate: ProfileViewDelegate, textFieldDelegate: UITextFieldDelegate, photoViewSize: CGFloat, saveButtonWidth: CGFloat) {
        self.delegate = delegate
        self.textFieldDelegate = textFieldDelegate
        self.photoViewSize = photoViewSize
        self.saveButtonWidth = saveButtonWidth
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        photoViewSize = 0
        saveButtonWidth = 0
        delegate = nil
        textFieldDelegate = nil
        super.init(coder: coder)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        self.backgroundColor = .mainBackground
        configureButtons()
        configureViews()
        setupConstraints()
    }
    
    private func configureViews() {
        self.addSubview(headerContainerView)
        headerContainerView.addSubview(headerLabel)
        headerContainerView.addSubview(cancelButton)
        self.addSubview(photoImage)
        self.addSubview(activityIndicator)
        self.addSubview(editButton)
        editButton.addSubview(editButtonImage)
        self.addSubview(fullNameTextField)
        self.addSubview(aboutMeTextField)
        self.addSubview(locationTextField)
        self.addSubview(saveChangesButton)
        self.addSubview(editProfileButton)
        self.addSubview(cancelChangesButton)
    }
    
    private func configureButtons() {
        saveChangesButton.isHidden = true
        cancelChangesButton.isHidden = true
        changeOpacity(for: cancelChangesButton, to: 0)
        saveChangesButton.addTarget(self, action: #selector(saveChangesButtonTapped), for: .touchUpInside)
        editProfileButton.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        cancelChangesButton.addTarget(self, action: #selector(cancelChangesButtonTapped), for: .touchUpInside)
    }
    
    private func changeOpacity(for button: UIButton, to value: Float) {
        button.layer.opacity = value
    }
    
    private func configBeforeSave() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        photoImage.image == nil ? photoImage.makeLabelVisible(true) : photoImage.makeLabelVisible(false)
    }
    
    private func textFieldIsEnable(_ bool: Bool) {
        fullNameTextField.isEnabled = bool
        aboutMeTextField.isEnabled = bool
        locationTextField.isEnabled = bool
    }
    
    private func cancelStartAnimation() {
        let vertical = CABasicAnimation(keyPath: "position.y")
        vertical.fromValue = cancelChangesButton.layer.position.y - 5
        vertical.toValue = cancelChangesButton.layer.position.y + 5
        let horizontal = CABasicAnimation(keyPath: "position.x")
        horizontal.fromValue = cancelChangesButton.layer.position.x - 5
        horizontal.toValue = cancelChangesButton.layer.position.x + 5
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.toValue = NSNumber(value: Double.pi / 10)
        rotate.fromValue = NSNumber(value: -Double.pi / 10)
        
        let group = CAAnimationGroup()
        group.duration = 0.25
        group.repeatCount = .infinity
        group.autoreverses = true
        
        group.animations = [rotate, vertical, horizontal]
        cancelChangesButton.layer.add(group, forKey: "shakeAnimation")
    }
    
    private func cancelStopAnimation() {
        let position = CABasicAnimation(keyPath: "position")
        position.toValue = cancelChangesButton.layer.position
        cancelChangesButton.layer.add(position, forKey: "changePosition")
    }
    // MARK: - Actions
    
    @objc
    private func closeButtonTapped() {
        delegate?.closeButtonTapped()
    }
    
    @objc
    private func editImageButtonTapped() {
        delegate?.editImageButtonTapped()
    }
    
    @objc
    private func saveChangesButtonTapped() {
        configBeforeSave()
        cancelChangesButton.isEnabled = false
        textFieldIsEnable(false)
        delegate?.saveChangesButtonTapped()
        photoImage.changeName(with: fullNameTextField.text ?? "")
    }
    
    @objc
    private func editProfileButtonTapped() {
        openAnimations()
        textFieldIsEnable(true)
        cancelChangesButton.isEnabled = true
        delegate?.editProfileButtonTapped()
        fullNameTextField.becomeFirstResponder()
    }
    
    @objc
    private func cancelChangesButtonTapped() {
        textFieldIsEnable(false)
        delegate?.cancelChangesButtonTapped()
        closedAnimations()
    }
}

// MARK: - ProfileViewControllerDelegate

extension ProfileView: ProfileViewControllerDelegate {
    func setImage(image: UIImage?) {
        photoImage.image = image
        if image == nil {
            photoImage.changeName(with: fullNameTextField.text)
        }
    }
    
    func makeLabelVisible(bool: Bool) {
        photoImage.makeLabelVisible(bool)
    }
    
    func changeName(with: String?) {
        photoImage.changeName(with: with)
    }
    
    func getPerson() -> Person {
        var person = Person()
        person.fullName = fullNameTextField.text ?? ""
        person.aboutMe = aboutMeTextField.text ?? ""
        person.location = locationTextField.text ?? ""
        
        return person
    }
    
    func updatePerson(person: Person?) {
        fullNameTextField.text = person?.fullName ?? ""
        aboutMeTextField.text = person?.aboutMe ?? ""
        locationTextField.text = person?.location ?? ""
    }
    
    func activityIndicatorIsAnimating(_ bool: Bool) {
        bool ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func openAnimations() {
        cancelChangesButton.isHidden = false
        saveChangesButton.isHidden = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.editProfileButton.transform = CGAffineTransform(translationX: 0, y: -60)
            self.changeOpacity(for: self.saveChangesButton, to: 1)
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.cancelStartAnimation()
            self.changeOpacity(for: self.cancelChangesButton, to: 1)
            self.editProfileButton.isHidden = true
        }
    }
    
    func closedAnimations() {
        editProfileButton.isHidden = false
        self.changeOpacity(for: self.cancelChangesButton, to: 0)
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.cancelStopAnimation()
            self.changeOpacity(for: self.editProfileButton, to: 1)
            self.editProfileButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.changeOpacity(for: self.saveChangesButton, to: 0)
        } completion: { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.cancelChangesButton.isHidden = true
            self.saveChangesButton.isHidden = true
        }
    }
}

// MARK: - Setup Constraints

extension ProfileView {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerContainerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerContainerView.heightAnchor.constraint(equalToConstant: Constants.headerHeight),
            headerLabel.topAnchor.constraint(
                equalTo: headerContainerView.topAnchor,
                constant: Constants.medOffset
            ),
            headerLabel.leadingAnchor.constraint(
                equalTo: headerContainerView.leadingAnchor,
                constant: Constants.basicOffset
            ),
            cancelButton.trailingAnchor.constraint(
                equalTo: headerContainerView.trailingAnchor,
                constant: Constants.basicInset
            ),
            cancelButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            photoImage.topAnchor.constraint(
                equalTo: headerContainerView.bottomAnchor,
                constant: Constants.smallOffset
            ),
            photoImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            photoImage.heightAnchor.constraint(equalToConstant: photoViewSize),
            photoImage.widthAnchor.constraint(equalToConstant: photoViewSize)
        ])
        NSLayoutConstraint.activate([
            editButton.heightAnchor.constraint(equalToConstant: photoViewSize / 3),
            editButton.widthAnchor.constraint(equalToConstant: photoViewSize / 3),
            editButton.bottomAnchor.constraint(equalTo: photoImage.bottomAnchor),
            editButton.trailingAnchor.constraint(equalTo: photoImage.trailingAnchor),
            editButtonImage.topAnchor.constraint(equalTo: editButton.topAnchor),
            editButtonImage.trailingAnchor.constraint(equalTo: editButton.trailingAnchor),
            editButtonImage.leadingAnchor.constraint(equalTo: editButton.leadingAnchor),
            editButtonImage.bottomAnchor.constraint(equalTo: editButton.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            fullNameTextField.topAnchor.constraint(
                equalTo: photoImage.bottomAnchor,
                constant: Constants.fullNameOffset
            ),
            fullNameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            aboutMeTextField.topAnchor.constraint(
                equalTo: fullNameTextField.bottomAnchor,
                constant: Constants.fullNameOffset
            ),
            aboutMeTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            locationTextField.topAnchor.constraint(
                equalTo: aboutMeTextField.bottomAnchor,
                constant: Constants.smallOffset
            ),
            locationTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            saveChangesButton.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                constant: Constants.saveButtonBottomInset
            ),
            saveChangesButton.heightAnchor.constraint(equalToConstant: Constants.saveButtonHeigh),
            saveChangesButton.widthAnchor.constraint(equalToConstant: saveButtonWidth),
            saveChangesButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cancelChangesButton.bottomAnchor.constraint(
                equalTo: saveChangesButton.topAnchor,
                constant: -10
            ),
            cancelChangesButton.heightAnchor.constraint(equalToConstant: Constants.saveButtonHeigh),
            cancelChangesButton.widthAnchor.constraint(equalToConstant: saveButtonWidth),
            cancelChangesButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: cancelChangesButton.topAnchor),
            editProfileButton.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                constant: Constants.saveButtonBottomInset
            ),
            editProfileButton.heightAnchor.constraint(equalToConstant: Constants.saveButtonHeigh),
            editProfileButton.widthAnchor.constraint(equalToConstant: saveButtonWidth),
            editProfileButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

// MARK: - Constants

extension ProfileView {
    private struct Constants {
        static let cornerRadius: CGFloat = 7
        static let headerHeight: CGFloat = 96
        static let basicOffset: CGFloat = 16
        static let basicInset: CGFloat = -16
        static let medOffset: CGFloat = 37
        static let smallOffset: CGFloat = 7
        static let photoLabelOffset: CGFloat = 39
        static let photoLabelInset: CGFloat = -39
        static let editButtonSize: CGFloat = 70
        static let fullNameOffset: CGFloat = 32
        static let aboutMeOffset: CGFloat = 79
        static let saveButtonBottomInset: CGFloat = -30
        static let saveButtonHeigh: CGFloat = 50
    }
}
