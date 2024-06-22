//
//  LoadingIndicator.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit

class LoadingIndicator {
    static func showLoading() {
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            let windowsScene = scenes.first as? UIWindowScene
            let window = windowsScene?.windows.last

            let loadingIndicatorView: UIActivityIndicatorView
            if let existedView = window?.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                loadingIndicatorView.frame = (window?.frame)!
                loadingIndicatorView.color = .brown
                window?.addSubview(loadingIndicatorView)
            }

            loadingIndicatorView.startAnimating()
        }
    }
    
    static func hideLoading() {
        let scenes = UIApplication.shared.connectedScenes
        let windowsScene = scenes.first as? UIWindowScene
        let window = windowsScene?.windows.last
        
        DispatchQueue.main.async {
            window?.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
