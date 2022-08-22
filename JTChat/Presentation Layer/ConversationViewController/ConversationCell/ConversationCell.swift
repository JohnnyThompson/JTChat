//
//  ConversationCell.swift
//  JTChat
//
//  Created by Евгений Карпов on 08.03.2022.
//

import UIKit

final class ConversationCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageMessage: UIImageView!
    
    // MARK: - Private methods
    
    private func configureViews() {
        activateImageMessage(false)
        activityIndicator.hidesWhenStopped = true
        
        imageMessage.contentMode = .scaleAspectFill
        
        self.backgroundColor = .mainBackground
        messageLabel.textColor = .mainText()
        dateLabel.textColor = .attributeText()
        
        containerView.layer.cornerRadius = 7
        containerView.backgroundColor = .incomingCell()
    }
    
    private func activateImageMessage(_ isActive: Bool) {
        imageMessage.isHidden = !isActive
        messageLabel.isHidden = isActive
    }
}

// MARK: - ConversationCellProtocol

extension ConversationCell: ConversationCellProtocol {
    func setupUI<T: Any>(with model: T, data: Data?) {
        guard let message = model as? DBMessage else {
            return
        }
        
        activityIndicator.stopAnimating()
        configureViews()
        
        if let data = data {
            self.activateImageMessage(true)
            imageMessage.image = UIImage(data: data)
        } else {
            messageLabel.text = message.content
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        dateLabel.text = formatter.string(from: message.created ?? Date())
        
        if nameLabel != nil {
            nameLabel?.text = message.senderName
            containerView.backgroundColor = .outgoingCell()
        }
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
}
