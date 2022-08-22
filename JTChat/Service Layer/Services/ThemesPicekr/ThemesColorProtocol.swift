//
//  ThemesColorProtocol.swift
//  JTChat
//
//  Created by Евгений Карпов on 13.03.2022.
//

import UIKit

protocol ThemesColorProtocol {
    var mainBackground: UIColor { get }
    var navigationBackground: UIColor { get }
    var onlineCell: UIColor { get }
    var offlineCell: UIColor { get }
    var incomingCell: UIColor { get }
    var outgoingCell: UIColor { get }
    var mainText: UIColor { get }
    var attributeText: UIColor { get }
    var buttonBackground: UIColor { get }
    var profileImageBackground: UIColor { get }
    var preferredStatusBarStyle: UIStatusBarStyle { get }
}
