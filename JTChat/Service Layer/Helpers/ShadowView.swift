//
//  ShadowView.swift
//  JTChat
//
//  Created by Evgeny on 10.05.2022.
//

import UIKit

final class ShadowView: UIView {
    
    // MARK: - Public properties
    
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }

    // MARK: - Private methods
    
    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
