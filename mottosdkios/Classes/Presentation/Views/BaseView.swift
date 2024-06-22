//
//  BaseView.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setStyle() {}

    // Hierarchy, Constraints setting
    func setLayout() {

    }
}
