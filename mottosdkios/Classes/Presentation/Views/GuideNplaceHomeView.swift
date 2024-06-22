//
//  NplaceHomeView.swift
//  mottoapp. nplace guide home. added subview
//
//  Created by MHD on 2024/02/13.
//

import UIKit

class GuideNplaceHomeView: UIView {
    
    var parentVC: AdMissionViewController?
    
    let bottomModalView = UIStackView().then {
        $0.backgroundColor = UIColor(r: 252, g: 181, b: 188)
        $0.layer.borderColor = UIColor(r: 255, g: 67, b: 86).cgColor
        $0.layer.borderWidth = 1
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
    }
    let searchLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let lineView = UIView().then {
        $0.backgroundColor = .red
    }
    // 텍스트뷰
    let keywordTextView = UITextView().then {
        $0.isEditable = false
        $0.textColor = .black
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textAlignment = .center
    }
    let bottomLabelView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 2
        $0.alignment = .center
    }
    let searchKeyWordLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let searchRedLabel = UILabel().then {
        $0.textColor = .red
        $0.font = .boldSystemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomModalView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    init() {
        self.searchLabel.text = "검색하기"
        self.searchKeyWordLabel.text = "위 검색어로"
        self.searchRedLabel.text = "검색해주세요."
        super.init(frame: .zero)
        
        self.backgroundColor = .baseWhite
        self.addSubview(self.bottomModalView)
        [self.searchLabel, self.lineView, self.keywordTextView, self.bottomLabelView]
            .forEach(self.bottomModalView.addSubview(_:))
        [self.searchKeyWordLabel, self.searchRedLabel]
            .forEach(self.bottomLabelView.addSubview(_:))
        
        self.bottomModalView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.searchLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalTo(bottomModalView.snp.centerX)
            make.height.equalTo(40)
        }
        self.lineView.snp.makeConstraints { make in
            make.top.equalTo(searchLabel.snp.bottom).offset(10)
            make.centerX.equalTo(bottomModalView.snp.centerX)
            make.height.equalTo(5)
            make.width.equalTo(50)
        }
        self.keywordTextView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.centerX.equalTo(bottomModalView.snp.centerX)
            make.height.equalTo(65)
            make.width.equalTo(300)
        }
        self.bottomLabelView.snp.makeConstraints { make in
            make.top.equalTo(keywordTextView.snp.bottom).offset(15)
            make.centerX.equalTo(keywordTextView.snp.centerX)
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
        self.searchKeyWordLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(40)
        }
        self.searchRedLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(searchKeyWordLabel.snp.right).offset(3)
            make.height.equalTo(40)
        }
    }
    required init?(coder: NSCoder) { fatalError() }
}
