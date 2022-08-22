//
//  NightTheme.swift
//  JTChat
//
//  Created by Евгений Карпов on 13.03.2022.
//

import UIKit

struct NightTheme: ThemesColorProtocol {
    var mainBackground = UIColor(named: "nightMainBackground") ?? .white
    var navigationBackground = UIColor(named: "nightNavigationBackground") ?? .white
    var onlineCell = UIColor(named: "nightOnlineCell") ?? .yellow
    var offlineCell = UIColor(named: "nightOfflineCell") ?? .gray
    var incomingCell = UIColor(named: "nightIncomingCell") ?? .gray
    var outgoingCell = UIColor(named: "nightOutgoingCell") ?? .darkGray
    var mainText = UIColor(named: "nightMainText") ?? .white
    var attributeText = UIColor(named: "nightAttributeText") ?? .darkGray
    var buttonBackground = UIColor(named: "nightButtonBackground") ?? .darkGray
    var profileImageBackground = UIColor(named: "nightProfileImageBackground") ?? .mainBackground
    var preferredStatusBarStyle: UIStatusBarStyle = .lightContent
}
