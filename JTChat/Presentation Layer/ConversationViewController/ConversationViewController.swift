//
//  ConversationViewController.swift
//  JTChat
//
//  Created by Евгений Карпов on 08.03.2022.
//

import UIKit
import CoreData

final class ConversationViewController: EmittedViewController, ConversationVCDelegate {
    // MARK: - Properties
    
    private let fetchedResultControllerDelegate = FetchedResultControllerDelegate()
    private let firestoreService: FirestoreServiceMessagesProtocol = FirestoreService(logIsEnable: true)
    private let coreDataService: CoreDataServiceMessagesProtocol = CoreDataService()
    private let imageService: ImageServiceProtocol = ImageService()
    
    private var channel: DBChannel
    private var fullName = ""
    
    private lazy var fetchedResultsController: NSFetchedResultsController<DBMessage> = {
        let context = coreDataService.viewContext
        let fetchRequest = DBMessage.fetchRequest()
        
        if let identifier = channel.identifier {
            fetchRequest.predicate = NSPredicate(format: "channelID = %@", identifier)
        }
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(DBMessage.created), ascending: false)
        ]

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        
        fetchedResultControllerDelegate.delegate = self
        controller.delegate = fetchedResultControllerDelegate

        do {
            try controller.performFetch()
        } catch {
            print(error.localizedDescription)
        }

        return controller
    }()
    
    // MARK: - Views
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .mainBackground
        tableView.register(UINib(nibName: "ConversationIncomingCell", bundle: nil), forCellReuseIdentifier: "ConversationIncomingCell")
        tableView.register(UINib(nibName: "ConversationOutgoingCell", bundle: nil), forCellReuseIdentifier: "ConversationOutgoingCell")
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var sendMessageView: UIView = {
        let view = UIView()
        view.backgroundColor = .navigationBackground()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.tintColor = .mainText()
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.setImage(UIImage(systemName: "arrow.up.square.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var sendImageButton: UIButton = {
        let button = UIButton()
        button.tintColor = .mainText()
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var messageTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 15
        var attribute = [NSAttributedString.Key: AnyObject]()
        attribute[.foregroundColor] = UIColor.attributeText()
        let attributedString = NSAttributedString(string: "    Сообщение...", attributes: attribute)
        textField.attributedPlaceholder = attributedString
        textField.font = .helvetica16
        textField.backgroundColor = .mainBackground
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.mainText().cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.delegate = self
        
        return textField
    }()
    
    // MARK: - Initialization
    
    init(channel: DBChannel, indexPath: IndexPath) {
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
        title = channel.name
    }
    
    required init?(coder: NSCoder) {
        self.channel = DBChannel()
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullName = coreDataService.getPerson()?.fullName ?? ""
        setupUI()
        addSnapshotListener()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        configureViews()
        setupConstraints()
        registerKbNotification()
    }
    
    private func addSnapshotListener() {
        guard let identifier = channel.identifier else {
            return
        }
        
        firestoreService.addMessagesSnapshotListener(for: identifier) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.coreDataService.addMessage(message: $0, to: self.channel)
        } modified: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.coreDataService.modifyMessage(message: $0, on: self.channel)
        } deleted: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.coreDataService.deleteMessage(message: $0, on: self.channel)
        }
    }
    
    private func configureViews() {
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .mainBackground
        view.addSubview(tableView)
        view.addSubview(sendMessageView)
        sendMessageView.addSubview(sendImageButton)
        sendMessageView.addSubview(messageTextField)
        sendMessageView.addSubview(sendMessageButton)
        sendMessageButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        sendImageButton.addTarget(self, action: #selector(sendImage), for: .touchUpInside)
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeKeyboard)))
    }
    
    private func registerKbNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func translationView(x: CGFloat, y: CGFloat) {
        tableView.transform = CGAffineTransform(translationX: x, y: y)
        sendMessageView.transform = CGAffineTransform(translationX: x, y: y)
        messageTextField.transform = CGAffineTransform(translationX: x, y: y)
        sendMessageButton.transform = CGAffineTransform(translationX: x, y: y)
    }
    
    private func configureCell(cell: UITableViewCell, with message: DBMessage, indexPath: IndexPath) -> UITableViewCell {
        guard let messageCell = cell as? ConversationCell else {
            return cell
        }
        
        messageCell.startAnimating()
        messageCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        messageCell.selectionStyle = .none
        
        if let content = message.content {
            imageService.getImageData(with: content) { result in
                switch result {
                case .success(let data):
                    messageCell.setupUI(with: message, data: data)
                case .failure:
                    messageCell.setupUI(with: message, data: nil)
                }
            }
        } else {
            messageCell.setupUI(with: message, data: nil)
        }
        
        messageCell.layoutSubviews()
        return messageCell
    }
    
    // MARK: - Actions
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        self.view.frame.origin.y = 0 - keyboardSize.height + 20
    }
    
    @objc
    private func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc
    private func closeKeyboard() {
        messageTextField.endEditing(true)
    }
    
    @objc
    private func sendMessage() {
        closeKeyboard()
        guard
            let text = messageTextField.text,
            text != "",
            let identifier = channel.identifier
        else {
            return
        }
        
        let message = Message(messageText: text, fullName: fullName)
        firestoreService.sendMessage(message: message, for: identifier)
        messageTextField.text = ""
    }
    
    @objc
    private func sendImage() {
        let vc = ImageListViewController(updatableVC: self)
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }

        return sections[section].numberOfObjects
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = fetchedResultsController.object(at: indexPath)
        let currentId = UIDevice.current.identifierForVendor?.uuidString ?? "Strange SenderID"
        
        guard currentId == message.senderId else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationIncomingCell", for: indexPath)

            return configureCell(cell: cell, with: message, indexPath: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationOutgoingCell", for: indexPath)
        
        return configureCell(cell: cell, with: message, indexPath: indexPath)
    }
}

// MARK: - UITextFieldDelegate

extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: - UITableViewDelegate

extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            guard
                let self = self,
                let identifier = self.channel.identifier
            else {
                return
            }
            
            let message = self.fetchedResultsController.object(at: indexPath)
            self.firestoreService.deleteMessage(message: message, for: identifier)
        }
        action.image = UIImage(systemName: "nosign")
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: - Setup constraints

extension ConversationViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sendMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sendMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sendMessageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sendMessageView.heightAnchor.constraint(equalToConstant: 70),
            
            sendMessageButton.trailingAnchor.constraint(equalTo: sendMessageView.trailingAnchor, constant: -16),
            sendMessageButton.topAnchor.constraint(equalTo: sendMessageView.topAnchor, constant: 10),
            sendMessageButton.widthAnchor.constraint(equalToConstant: 30),
            sendMessageButton.heightAnchor.constraint(equalToConstant: 30),
            
            sendImageButton.leadingAnchor.constraint(equalTo: sendMessageView.leadingAnchor, constant: 16),
            sendImageButton.topAnchor.constraint(equalTo: sendMessageView.topAnchor, constant: 10),
            sendImageButton.widthAnchor.constraint(equalToConstant: 30),
            sendImageButton.heightAnchor.constraint(equalToConstant: 30),
            
            messageTextField.leadingAnchor.constraint(equalTo: sendImageButton.trailingAnchor, constant: 5),
            messageTextField.trailingAnchor.constraint(equalTo: sendMessageButton.leadingAnchor, constant: -5),
            messageTextField.topAnchor.constraint(equalTo: sendMessageView.topAnchor, constant: 10),
            messageTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: sendMessageView.topAnchor, constant: -5)
        ])
    }
}

// MARK: - Updatable

extension ConversationViewController: Updatable {
    func updateAndSave(with stringURL: String) {
        messageTextField.text = stringURL
        sendMessage()
    }
}
