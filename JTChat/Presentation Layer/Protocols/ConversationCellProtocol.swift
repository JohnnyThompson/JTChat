//
//  ConversationCellProtocol.swift
//  JTChat
//
//  Created by Евгений Карпов on 17.03.2022.
//

import Foundation

protocol ConversationCellProtocol {
    func setupUI<T: Any>(with model: T, data: Data?)
    func startAnimating()
}
