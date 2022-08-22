//
//  ConversationListViewController.swift
//  JTChat
//
//  Created by Евгений Карпов on 07.03.2022.
//

import UIKit
import CoreData

final class ConversationListViewController: EmittedViewController, ConversationVCDelegate {
    // MARK: - Properties
    
    private let themesPicker = ThemesPicker()
    private let fetchedResultControllerDelegate = FetchedResultControllerDelegate()
    private let firestoreService: FirestoreServiceChannelsProtocol = FirestoreService(logIsEnable: true)
    
    private var coreDataService: CoreDataServiceChannelsProtocol = CoreDataService(logIsEnable: true)
    
    private lazy var fetchedResultsController: NSFetchedResultsController<DBChannel> = {
        let context = coreDataService.viewContext
        let fetchRequest = DBChannel.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(DBChannel.lastActivity), ascending: false)
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
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ConversationListCell", bundle: nil), forCellReuseIdentifier: "ConversationListCell")
        setupNavBar()
        setupUI()
        addSnapshotListener()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        setupColors()
        setupNavBar()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        setupNavBar()
        setupColors()
        configureViews()
        setupConstraints()
    }

    private func configureViews() {
        view.addSubview(tableView)
    }

    private func setupColors() {
        view.backgroundColor = .mainBackground
        tableView.backgroundColor = .mainBackground
    }

    private func setupNavBar() {
        if let customNavigation = navigationController as? RootNavigationController {
            customNavigation.setupNavigationController()
        }
        title = "Channels"
        let setupButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        navigationItem.leftBarButtonItem = setupButton
        let profileButton = UIBarButtonItem(
            image: UIImage(systemName: "person.crop.circle"),
            style: .plain,
            target: self,
            action: #selector(profileButtonTapped)
        )
        profileButton.accessibilityIdentifier = "ProfileButton"
        let addChannel = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addNewChanel)
        )
        navigationItem.rightBarButtonItems = [profileButton, addChannel]
    }
    
    private func addSnapshotListener() {
        firestoreService.addChannelsSnapshotListener { [weak self] in
            self?.coreDataService.addChannel(channel: $0)
        } modified: { [weak self] in
            self?.coreDataService.modifyChannel(channel: $0)
        } deleted: { [weak self] in
            self?.coreDataService.deleteChannel(channel: $0)
        }
    }
    // MARK: - Actions
    
    @objc
    private func profileButtonTapped() {
        let profileVC = ProfileViewController()
        profileVC.transitioningDelegate = self
        present(profileVC, animated: true)
    }
    
    @objc
    private func settingsButtonTapped() {
        let themesPickerVC = ThemesViewController(nibName: "ThemesViewController", bundle: nil)
        themesPickerVC.delegate = themesPicker
        navigationController?.pushViewController(themesPickerVC, animated: true)
    }
    
    @objc
    private func addNewChanel() {
        let alertController = UIAlertController(title: "Создать новый канал", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Название канала"
        }
        let okAction = UIAlertAction(
            title: "Добавить",
            style: .default) { [weak self] _ in
                guard let text = alertController.textFields?.first?.text, !text.isEmpty else { return }
                let channel = Channel(channelName: text)
                self?.firestoreService.addChanel(channel: channel)
            }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
// MARK: - UITableViewDataSource

extension ConversationListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath)
        
        guard let chatCell = cell as? ConversationListCell else {
            return cell
        }
        
        let channel = fetchedResultsController.object(at: indexPath)
        chatCell.setupUI(with: channel, data: nil)
        return chatCell
    }
}
// MARK: - UITableViewDelegate

extension ConversationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let channel = fetchedResultsController.object(at: indexPath)
        let conversationVC = ConversationViewController(channel: channel, indexPath: indexPath)
        self.navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            guard
                let self = self,
                let identifier = self.fetchedResultsController.object(at: indexPath).identifier
            else {
                return
            }
            
            self.firestoreService.deleteChannel(channelId: identifier)
        }
        action.image = UIImage(systemName: "nosign")
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: - Setup constraints

extension ConversationListViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ConversationListViewController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return CustomViewTransition()
    }
}
