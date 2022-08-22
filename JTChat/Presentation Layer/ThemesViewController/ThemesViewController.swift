//
//  ThemesViewController.swift
//  JTChat
//
//  Created by Евгений Карпов on 13.03.2022.
//

import UIKit

final class ThemesViewController: EmittedViewController {
    // MARK: - Outlets
    
    @IBOutlet var defaultView: UIView!
    @IBOutlet var defaultIn: UIView!
    @IBOutlet var defaultOut: UIView!
    
    @IBOutlet var classicView: UIView!
    @IBOutlet var classicIn: UIView!
    @IBOutlet var classicOut: UIView!

    @IBOutlet var dayView: UIView!
    @IBOutlet var dayIn: UIView!
    @IBOutlet var dayOut: UIView!

    @IBOutlet var nightView: UIView!
    @IBOutlet var nightIn: UIView!
    @IBOutlet var nightOut: UIView!

    @IBOutlet var defaultLabel: UILabel!
    @IBOutlet var classicLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var nightLabel: UILabel!

    // MARK: - Properties
    
    weak var delegate: ThemesPickerDelegate?
    var userDefaults = UserDefaults.standard
    
    // MARK: - Initialization
    
    convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, closure: @escaping() -> Void) {
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadBorderColor()
    }
    
    // MARK: - Private methods
    
    private func changeTheme(with tag: Int) {
        userDefaults.set(tag, forKey: "CurrentTheme")
        delegate?.updateTheme()
        updateColor()
    }

    @objc private func defaultButtonTapped() {
        changeTheme(with: 1)
        defaultView.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    @objc private func classicButtonTapped() {
        changeTheme(with: 2)
        classicView.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    @objc private func dayButtonTapped() {
        changeTheme(with: 3)
        dayView.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    @objc private func nightButtonTapped() {
        changeTheme(with: 4)
        nightView.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    private func setupUI() {
        setupNavBar()
        configureViews()
        addGestureRecognizers()
    }

    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Settings"
    }

    private func configureViews() {
        view.backgroundColor = .mainBackground
        view.subviews.forEach {
            switch $0.tag {
            case 1:
                $0.layer.cornerRadius = Constants.mainCornerRadius
                $0.layer.borderWidth = 3
                $0.layer.borderColor = UIColor.gray.cgColor
            default:
                $0.layer.cornerRadius = Constants.inOutCornerRadius
            }
        }
        configureLabel()
    }
    
    private func addGestureRecognizers() {
        defaultView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(defaultButtonTapped)))
        defaultLabel.isUserInteractionEnabled = true
        defaultLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(defaultButtonTapped)))
        
        classicView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(classicButtonTapped)))
        classicLabel.isUserInteractionEnabled = true
        classicLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(classicButtonTapped)))
        
        dayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dayButtonTapped)))
        dayLabel.isUserInteractionEnabled = true
        dayLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dayButtonTapped)))
        
        nightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nightButtonTapped)))
        nightLabel.isUserInteractionEnabled = true
        nightLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nightButtonTapped)))
    }

    private func configureLabel() {
        defaultLabel.textColor = .mainText()
        classicLabel.textColor = .mainText()
        dayLabel.textColor = .mainText()
        nightLabel.textColor = .mainText()
    }
    
    private func loadBorderColor() {
        switch userDefaults.integer(forKey: "CurrentTheme") {
        case 2:
            classicView.layer.borderColor = UIColor.systemBlue.cgColor
        case 3:
            dayView.layer.borderColor = UIColor.systemBlue.cgColor
        case 4:
            nightView.layer.borderColor = UIColor.systemBlue.cgColor
        default:
            defaultView.layer.borderColor = UIColor.systemBlue.cgColor
        }
    }

    private func updateColor(withDuration: TimeInterval = 0.4) {
        UIView.animate(withDuration: withDuration) { [weak self] in
            guard let self = self else { return }
            self.configureViews()
            if let customNavigation = self.navigationController as? RootNavigationController {
                customNavigation.setupNavigationController()
            }
        }
        setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: - Constants

extension ThemesViewController {
    struct Constants {
        static let mainCornerRadius: CGFloat = 10
        static let inOutCornerRadius: CGFloat = 5
    }
}
