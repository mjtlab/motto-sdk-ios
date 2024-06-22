//
//  TopTabBarCollectionViewCell.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit

final class TopTabBarCollectionViewCell: UICollectionViewCell {
    private let titleLabel = UILabel().then {
        $0.textColor = .baseGray4
        $0.font = UIFont.boldSystemFont(ofSize: 16)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func getTitleFrameWidth() -> CGFloat {
        self.titleLabel.frame.width
    }
    
    func getTabCellFrameWidth() -> CGFloat {
        contentView.frame.width
    }

    func configureCell(title: String) {
        titleLabel.text = title
    }
}
