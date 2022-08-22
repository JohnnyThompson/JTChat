//
//  DayTheme.swift
//  JTChat
//
//  Created by Евгений Карпов on 13.03.2022.
//

import UIKit

struct DayTheme: ThemesColorProtocol {
    var mainBackground = UIColor(named: "dayMainBackground") ?? .white
    var navigationBackground = UIColor(named: "dayNavigationBackground") ?? .white
    var onlineCell = UIColor(named: "dayOnlineCell") ?? .yellow
    var offlineCell = UIColor(named: "dayOfflineCell") ?? .gray
    var incomingCell = UIColor(named: "dayIncomingCell") ?? .gray
    var outgoingCell = UIColor(named: "dayOutgoingCell") ?? .darkGray
    var mainText = UIColor(named: "dayMainText") ?? .black
    var attributeText = UIColor(named: "dayAttributeText") ?? .darkGray
    var buttonBackground = UIColor(named: "dayButtonBackground") ?? .darkGray
    var profileImageBackground = UIColor(named: "dayProfileImageBackground") ?? .mainBackground
    var preferredStatusBarStyle: UIStatusBarStyle = .darkContent
}
