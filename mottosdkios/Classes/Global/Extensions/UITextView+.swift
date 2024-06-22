//
//  UITextView+.swift
//  mottoapp
//
//  Created by MHD on 2024/05/17.
//

import Foundation
import UIKit

extension UITextView {
    func alignVerticallyCenter() {
        var topInset = (self.bounds.size.height - self.contentSize.height*self.zoomScale) / 2
        topInset = topInset < 0.0 ? 0.0 : topInset
        self.contentInset.top = topInset
    }
}
