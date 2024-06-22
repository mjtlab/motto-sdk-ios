//
//  Images.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit

struct Images {

    struct GetNumber {
        static var topMenu: UIImage { .load(named: "topMenu") }
    }

    struct MyMotto {
        static var topMenu: UIImage { .load(named: "topMenu") }
    }

    struct WinNumber {
        static var topMenu: UIImage { .load(named: "topMenu") }
    }
    struct Honor {
        static var topMenu: UIImage { .load(named: "topMenu") }
    }
}


extension UIImage {
    static func load(named imageName: String) -> UIImage {
        guard let image = Utils.podImage(context: self, img: imageName) else {
            return UIImage()
        }
        image.accessibilityIdentifier = imageName
        return image
    }

    func resize(to size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
