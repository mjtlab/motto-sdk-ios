//
//  String+.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    func getTextContentSize() -> CGSize {
        let label = UILabel()
        label.text = self
        return label.intrinsicContentSize
    }
//    func getTextContentSize(withFont font: UIFont) -> CGSize {
//        let label = UILabel()
//        label.font = font
//        label.text = self
//        return label.intrinsicContentSize
//    }
}
