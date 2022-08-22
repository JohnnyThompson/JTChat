//
//  ClassicTheme.swift
//  JTChat
//
//  Created by Евгений Карпов on 13.03.2022.
//

import UIKit

struct ClassicTheme: ThemesColorProtocol {
    var mainBackground = UIColor(named: "classicMainBackground") ?? .white
    var navigationBackground = UIColor(named: "classicNavigationBackground") ?? .white
    var onlineCell = UIColor(named: "classicOnlineCell") ?? .yellow
    var offlineCell = UIColor(named: "classicOfflineCell") ?? .gray
    var incomingCell = UIColor(named: "classicIncomingCell") ?? .gray
    var outgoingCell = UIColor(named: "classicOutgoingCell") ?? .darkGray
    var mainText = UIColor(named: "classicMainText") ?? .white
    var attributeText = UIColor(named: "classicAttributeText") ?? .darkGray
    var buttonBackground = UIColor(named: "classicButtonBackground") ?? .darkGray
    var profileImageBackground = UIColor(named: "classicProfileImageBackground") ?? .mainBackground
    var preferredStatusBarStyle: UIStatusBarStyle = .default
}
