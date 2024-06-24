//
//  NSObject+.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
