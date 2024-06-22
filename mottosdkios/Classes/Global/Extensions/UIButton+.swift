//
//  UIButton+.swift
//  mottoapp
//
//  Created by MHD on 2024/05/17.
//

import UIKit

extension UIButton {
    func makeVerticalButton(imageAlign: String) {
        var configuration = UIButton.Configuration.filled()
                
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.boldSystemFont(ofSize: 20)

        var subtitleContainer = AttributeContainer()
        subtitleContainer.foregroundColor = UIColor.white.withAlphaComponent(0.5)

        configuration.attributedTitle = AttributedString("Title", attributes: titleContainer)
        configuration.attributedSubtitle = AttributedString("Subtitle", attributes: subtitleContainer)
        configuration.image = UIImage(systemName: "swift")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 30)
        configuration.imagePadding = 10
        configuration.background.cornerRadius = 10

        // 이미지가 왼쪽
        configuration.titleAlignment = .leading
        let leftButton = UIButton(configuration: configuration)

        // 이미지가 상단
        configuration.imagePlacement = .top
        let topButton = UIButton(configuration: configuration)

        // 이미지가 오른쪽
        configuration.imagePlacement = .trailing
        let rightButton = UIButton(configuration: configuration)

        // 이미지가 하단
        configuration.imagePlacement = .bottom
        let bottomButton = UIButton(configuration: configuration)
    }
    
    func alignMainButton(context: AnyClass, imageName: String, textValue: String) {
        var configuration = UIButton.Configuration.filled()
                
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.boldSystemFont(ofSize: 14)

        configuration.attributedTitle = AttributedString(textValue, attributes: titleContainer)
//        configuration.image = UIImage(named: imageName)
        configuration.image = Utils.podImage(context: context, img: imageName)
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 30)
        configuration.imagePadding = 10
        configuration.background.cornerRadius = 16
        configuration.baseBackgroundColor = .colorGrayF3
        configuration.baseForegroundColor = .black

        configuration.imagePlacement = .top
        self.configuration = configuration
        
        self.configurationUpdateHandler = { btn in
            switch btn.state {
                case .highlighted:
                    btn.configuration?.baseBackgroundColor = .lightGray
                default:
                    btn.configuration?.baseBackgroundColor = .colorGrayF3
            }
        }
    }
    
    func makeRetryButton(context: AnyClass, imageName: String, textValue: String) {
        var configuration = UIButton.Configuration.filled()
                
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.boldSystemFont(ofSize: 14)

        configuration.attributedTitle = AttributedString(textValue, attributes: titleContainer)
        configuration.image = Utils.podImage(context: context, img: imageName)
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 30)
        configuration.imagePadding = 8
        configuration.background.cornerRadius = 16
        configuration.baseBackgroundColor = .colorGrayF3
        configuration.baseForegroundColor = .black

        configuration.imagePlacement = .top
        self.configuration = configuration
        
        self.configurationUpdateHandler = { btn in
            switch btn.state {
                case .highlighted:
                    btn.configuration?.baseBackgroundColor = .lightGray
                default:
                    btn.configuration?.baseBackgroundColor = .colorGrayF3
            }
        }
    }
    
    func makeConfirmButton(context: AnyClass, imageName: String, textValue: String) {
        var configuration = UIButton.Configuration.filled()
                
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.boldSystemFont(ofSize: 14)

        configuration.attributedTitle = AttributedString(textValue, attributes: titleContainer)
        configuration.image = Utils.podImage(context: context, img: imageName)
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 30)
        configuration.imagePadding = 8
        configuration.background.cornerRadius = 16
        configuration.baseBackgroundColor = .red
        configuration.baseForegroundColor = .white

        configuration.imagePlacement = .top
        self.configuration = configuration
        
        self.configurationUpdateHandler = { btn in
            btn.configuration?.baseBackgroundColor = .red
        }
    }
}
