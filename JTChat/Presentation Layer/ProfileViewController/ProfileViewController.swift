//
//  ProfileViewController.swift
//  JTChat
//
//  Created by Евгений Карпов on 01.03.2022.
//

import UIKit

final class ProfileViewController: EmittedViewController, ProfileViewDelegate {
    // MARK: - Properties
    
    private let storageService: StorageServiceProtocol = StorageService(logIsEnable: true)
    private let coreDataService: CoreDataServicePersonProtocol = CoreDataService(logIsEnable: true)
    private let imageService: ImageServiceProtocol = ImageService()
    
    private var delegate: ProfileViewControllerDelegate?
    private var fullNameCache: String?
    private var aboutMeCache: String?
    private var locationCache: String?
    private var photoViewSize: CGFloat {
        view.bounds.height / 4.5
    }
    private var saveButtonWidth: CGFloat {
        view.bounds.width * 0.8
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = ProfileView(
            delegate: self,
            textFieldDelegate: self,
            photoViewSize: photoViewSize,
            saveButtonWidth: saveButtonWidth
        )
        view.accessibilityIdentifier = "profileView"
        self.view = view
        self.delegate = view
        loadProfileData()
    }
    
    // MARK: - Private methods
    
    private func showSuccessAlert() {
        let ac = UIAlertController(title: "Данные успешно сохранены", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.delegate?.closedAnimations()
        }
        ac.addAction(okButton)
        self.present(ac, animated: true)
    }
    
    private func showFailureAlert(with action: @escaping() -> Void) {
        delegate?.activityIndicatorIsAnimating(false)
        let ac = UIAlertController(title: "Данные успешно сохранены", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.delegate?.closedAnimations()
        }
        let retryButton = UIAlertAction(title: "Повторить", style: .destructive) { _ in
            action()
            return
        }
        ac.addAction(okButton)
        ac.addAction(retryButton)
        self.present(ac, animated: true)
    }
    
    private func loadProfileData() {
        let dbPerson = coreDataService.getPerson()
        var person = Person()
        person.fullName = dbPerson?.fullName ?? ""
        person.aboutMe = dbPerson?.aboutMe ?? ""
        person.location = dbPerson?.location ?? ""
        fullNameCache = dbPerson?.fullName
        aboutMeCache = dbPerson?.aboutMe
        locationCache = dbPerson?.location
        delegate?.updatePerson(person: person)
        
        guard let imageData = storageService.loadPhoto() else {
            delegate?.changeName(with: person.fullName)
            delegate?.makeLabelVisible(bool: true)
            return
        }
        
        delegate?.setImage(image: UIImage(data: imageData))
        delegate?.makeLabelVisible(bool: false)
    }
    
    private func loadFromNetwork() {
        let vc = ImageListViewController(updatableVC: self)
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
    
    // MARK: - Actions
    
    func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    func editImageButtonTapped() {
        let ac = UIAlertController(
            title: "Загрузить фото",
            message: nil,
            preferredStyle: .actionSheet
        )
        ac.addAction(UIAlertAction(
            title: "Выбрать из галереи",
            style: .default,
            handler: { [weak self] _ in
                self?.addPhotoFromFile()
            }
        ))
        ac.addAction(UIAlertAction(
            title: "Камера",
            style: .default,
            handler: { [weak self] _ in
                self?.addPhotoFromCamera()
            }
        ))
        ac.addAction(UIAlertAction(
            title: "Загрузить из интернета",
            style: .default,
            handler: { [weak self] _ in
                self?.loadFromNetwork()
            }
        ))
        ac.addAction(UIAlertAction(
            title: "Удалить фото",
            style: .destructive,
            handler: { [weak self]_ in
                self?.storageService.deletePhoto()
                self?.delegate?.setImage(image: nil)
                self?.delegate?.makeLabelVisible(bool: true)
            }))
        ac.addAction(UIAlertAction(
            title: "Отмена",
            style: .cancel
        ))
        present(ac, animated: true)
    }
    
    func editProfileButtonTapped() {
        let person = delegate?.getPerson()
        fullNameCache = person?.fullName
        aboutMeCache = person?.aboutMe
        locationCache = person?.location
    }
    
    func saveChangesButtonTapped() {
        let person = delegate?.getPerson()
        // Добавить Result в completion
        coreDataService.modifyPerson(
            fullName: person?.fullName ?? "",
            aboutMe: person?.aboutMe ?? "",
            location: person?.location ?? ""
        ) { [weak self] in
            self?.delegate?.activityIndicatorIsAnimating(false)
            self?.showSuccessAlert()
        }
    }
    
    func cancelChangesButtonTapped() {
        var person = Person()
        person.fullName = fullNameCache ?? ""
        person.aboutMe = aboutMeCache ?? ""
        person.location = locationCache ?? ""
        delegate?.updatePerson(person: person)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func addPhotoFromFile() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func addPhotoFromCamera() {
        let picker = UIImagePickerController()
        
        guard
            UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        else {
            let alert = UIAlertController(
                title: "Warning",
                message: "You don't have camera",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        picker.sourceType = UIImagePickerController.SourceType.camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func saveAndUpdate(with image: UIImage?) {
        if let image = image {
            let imageData = image.jpegData(compressionQuality: 0.8)
            storageService.savePhoto(data: imageData)
        }
        
        delegate?.setImage(image: image)
        delegate?.makeLabelVisible(bool: false)
        delegate?.openAnimations()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        saveAndUpdate(with: image)
        dismiss(animated: true)
    }
}
// MARK: - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Updatable

extension ProfileViewController: Updatable {
    func updateAndSave(with stringURL: String) {
        imageService.getImageData(with: stringURL) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                self.saveAndUpdate(with: image)
            case .failure:
                self.showFailureAlert { [weak self] in
                    self?.loadFromNetwork()
                }
            }
        }
    }
}
