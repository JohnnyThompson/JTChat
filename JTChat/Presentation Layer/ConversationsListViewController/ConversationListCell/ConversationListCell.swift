//
//  ConversationListCell.swift
//  JTChat
//
//  Created by Евгений Карпов on 07.03.2022.
//

import UIKit

final class ConversationListCell: UITableViewCell, ConversationCellProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!

    // MARK: - Private properties
    
    private var channel: DBChannel?

    // MARK: - Initialization
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public method
    
    func setupUI<T: Any>(with model: T, data: Data?) {
        guard let channel = model as? DBChannel else {
            return
        }
        
        self.channel = channel
        configureViews()
        setupColors()
    }
    
    func startAnimating() {
        
    }

    // MARK: - Private methods
    
    private func configureViews() {
        guard let channel = channel else {
            return
        }
        
        self.selectionStyle = .none
        nameLabel.text = channel.name
        messageLabel.text = channel.lastMessage
        
        if let date = channel.lastActivity {
            let now = Date()
            let starOfDay = Calendar.current.startOfDay(for: now)
            let yesterday = starOfDay - 1
            let formatter = DateFormatter()
            formatter.dateFormat = date <= yesterday ? "dd MMM" : "HH:mm"
            dateLabel.text = formatter.string(from: date)
        }
    }
    
    private func setupColors() {
        nameLabel.textColor = .mainText()
        messageLabel.textColor = .mainText()
        dateLabel.textColor = .attributeText()
    }
}
