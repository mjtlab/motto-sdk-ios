//
//  FavorView.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
//import SwiftUI

class FavorView: UIView {
    var parentVC: FavorViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 각 category별로 모두 동일한 component를 쓴다. 일단 하나로 쓰면서 변경하는 것으로 하자.
    // category별 컨텐츠 영역 1. alarm =========================
    let alarmView = UIStackView().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
    }
    let subjectLabel = UILabel().then {
        $0.text = Words.alarm
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let midLineView = UIView().then {
        $0.backgroundColor = .red
        $0.clipsToBounds = true
    }
    let descriptionLabel = UILabel().then {
        $0.text = Description.requestAlarm
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let bodyImageBackView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    let bodyImageView = UIImageView().then {
        $0.image = Utils.podImage(context: FavorView.self, img: "naver_process_alarm")
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    let partButton = UIButton().then {
        $0.backgroundColor = UIColor(hexCode: "f8a726")
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.part, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    let closeButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.close, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    // category별 컨텐츠 영역 1. alarm =========================
    // category별 컨텐츠 영역 2. zzim =======================
    let zzimView = UIStackView().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
    }
    let subjectZzimLabel = UILabel().then {
        $0.text = "상품찜"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midLineZzimView = UIView().then {
        $0.backgroundColor = .red
        $0.clipsToBounds = true
    }
    let descriptionZzimLabel = UILabel().then {
        $0.text = "그림과 같이 '찜'을 눌러주세요!"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let bodyImageZzimBackView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    let bodyImageZzimView = UIImageView().then {
        $0.image = Utils.podImage(context: FavorView.self, img: "naver_process_zzim")
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    let buttonStackZzimView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    let partZzimButton = UIButton().then {
        $0.backgroundColor = UIColor(hexCode: "f8a726")
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.part, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    let closeZzimButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.close, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    // category별 컨텐츠 영역 2. zzim =======================
    
    override func layoutSubviews() {
        super.layoutSubviews()
        alarmView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        zzimView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    func setLayout() {
        // arrange & constraint
        self.backgroundColor = .black.withAlphaComponent(0.3)
        self.addSubviews(
            alarmView,
            zzimView
        )
        alarmView.addSubviews(
            subjectLabel,
            midLineView,
            descriptionLabel,
            bodyImageBackView,
            bodyImageView,
            buttonStackView
        )
        buttonStackView.addSubviews(
            partButton,
            closeButton
        )
        zzimView.addSubviews(
            subjectZzimLabel,
            midLineZzimView,
            descriptionZzimLabel,
            bodyImageZzimBackView,
            bodyImageZzimView,
            buttonStackZzimView
        )
        buttonStackZzimView.addSubviews(
            partZzimButton,
            closeZzimButton
        )
        
        self.alarmView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(630)
        }
        self.subjectLabel.snp.makeConstraints { make in
            make.bottom.equalTo(midLineView.snp.top).offset(-15)
            make.centerX.equalTo(alarmView.snp.centerX)
        }
        self.midLineView.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-15)
            make.centerX.equalTo(alarmView.snp.centerX)
            make.height.equalTo(4)
            make.width.equalTo(50)
        }
        self.descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bodyImageBackView.snp.top).offset(-5)
            make.centerX.equalTo(alarmView.snp.centerX)
            make.height.equalTo(20)
        }
        self.bodyImageBackView.snp.makeConstraints { make in
            make.top.equalTo(bodyImageView.snp.top).offset(-5)
            make.bottom.equalTo(bodyImageView.snp.bottom).offset(5)
            make.left.equalTo(bodyImageView.snp.left).offset(-5)
            make.right.equalTo(bodyImageView.snp.right).offset(5)
            make.centerX.equalTo(alarmView.snp.centerX)
        }
        self.bodyImageView.snp.makeConstraints { make in
            make.bottom.equalTo(buttonStackView.snp.top).offset(-25)
            make.centerX.equalTo(alarmView.snp.centerX)
            make.width.equalTo(280)
            make.height.equalTo(400)
        }
        self.buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(alarmView.snp.centerX)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        self.partButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        self.closeButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        // ================================================
        self.zzimView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(550)
        }
        self.subjectZzimLabel.snp.makeConstraints { make in
            make.bottom.equalTo(midLineZzimView.snp.top).offset(-15)
            make.centerX.equalTo(zzimView.snp.centerX)
        }
        self.midLineZzimView.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionZzimLabel.snp.top).offset(-15)
            make.centerX.equalTo(zzimView.snp.centerX)
            make.height.equalTo(4)
            make.width.equalTo(50)
        }
        self.descriptionZzimLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bodyImageZzimBackView.snp.top).offset(-10)
            make.centerX.equalTo(zzimView.snp.centerX)
            make.height.equalTo(20)
        }
        self.bodyImageZzimBackView.snp.makeConstraints { make in
            make.top.equalTo(bodyImageZzimView.snp.top).offset(5)
            make.bottom.equalTo(bodyImageZzimView.snp.bottom).offset(-5)
            make.left.equalTo(bodyImageZzimView.snp.left).offset(-5)
            make.right.equalTo(bodyImageZzimView.snp.right).offset(5)
            make.centerX.equalTo(zzimView.snp.centerX)
        }
        self.bodyImageZzimView.snp.makeConstraints { make in
            make.bottom.equalTo(buttonStackZzimView.snp.top).offset(-25)
            make.centerX.equalTo(zzimView.snp.centerX)
            make.width.equalTo(290)
            make.height.equalTo(310)
        }
        self.buttonStackZzimView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(zzimView.snp.centerX)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        self.partZzimButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        self.closeZzimButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
    }
}
