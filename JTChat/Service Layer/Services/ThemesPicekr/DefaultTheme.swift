//
//  DefaultTheme.swift
//  JTChat
//
//  Created by Евгений Карпов on 13.03.2022.
//

import UIKit

struct DefaultTheme: ThemesColorProtocol {
    var mainBackground = UIColor(named: "mainBackground") ?? .white
    var navigationBackground = UIColor(named: "navigationBackground") ?? .white
    var onlineCell = UIColor(named: "onlineCell") ?? .yellow
    var offlineCell = UIColor(named: "offlineCell") ?? .gray
    var incomingCell = UIColor(named: "incomingCell") ?? .gray
    var outgoingCell = UIColor(named: "outgoingCell") ?? .darkGray
    var mainText = UIColor(named: "mainText") ?? .white
    var attributeText = UIColor(named: "attributeText") ?? .darkGray
    var buttonBackground = UIColor(named: "buttonBackground") ?? .darkGray
    var profileImageBackground = UIColor(named: "profileImageBackground") ?? .mainBackground
    var preferredStatusBarStyle: UIStatusBarStyle = .default
}
