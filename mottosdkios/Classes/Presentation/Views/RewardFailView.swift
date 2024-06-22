//
//  RewardFailView.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import SnapKit
import Then

class RewardFailView: UIView {
    
    var parentVC: RewardFailViewController?
    
    let popupView = UIView().then {
        $0.backgroundColor = .white
    }
    let bodyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
        
        $0.distribution = .fill
    }
    let subjectLabel = UILabel().then {
        $0.text = "적립오류"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 20)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let midLineView = UIView().then {
        $0.backgroundColor = .red
        $0.clipsToBounds = true
    }
    let descriptionLabel = UILabel().then {
        $0.text = "미션에 실패했습니다.\n해당 페이지로 돌아가 미션을\n다시 수행해주세요."
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let centerButton = UIButton().then {
        $0.backgroundColor = .baseRed
        $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
        $0.setTitle("재시도", for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = false
    }
    let bottomButton = UIButton().then {
        $0.backgroundColor = .white
        $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(UIColor(hexCode: "707070"), for: .normal)
        $0.setTitleColor(UIColor(hexCode: "707070"), for: .highlighted)
    }
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .black.withAlphaComponent(0.3)
        self.addSubview(popupView)
        popupView.addSubview(bodyStackView)
        [subjectLabel, midLineView, descriptionLabel, centerButton, bottomButton]
            .forEach(bodyStackView.addArrangedSubview(_:))
        
        popupView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(40)
            $0.centerY.equalToSuperview()
        }
        bodyStackView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        subjectLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.centerX.equalToSuperview()
        }
        midLineView.snp.makeConstraints {
            $0.top.equalTo(subjectLabel.snp.top).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(4)
            $0.width.equalTo(50)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(midLineView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        centerButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
        bottomButton.snp.makeConstraints {
            $0.top.equalTo(centerButton.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(20)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
        
        // 다시하기. 전 페이지로 돌아간다.
        centerButton.addTarget(self, action: #selector(retryMission), for: .touchUpInside)
        bottomButton.addTarget(self, action: #selector(cancelMission), for: .touchUpInside)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func retryMission() {
        parentVC?.retryMission()
    }
    @objc func cancelMission() {
        parentVC?.dismiss(animated: false)
    }
}
