//
//  MissionFailView.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import SnapKit
import Then

class MissionFailView: UIView {
    
    var parentVC: MissionFailViewController?
    
    let popupView = UIView().then {
        $0.backgroundColor = .white
    }
    let bodyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 15
        $0.alignment = .center
        $0.distribution = .fill
    }
    let subjectLabel = UILabel().then {
        $0.text = "미션실패"
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
        $0.setTitle("다시하기", for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = false
    }
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .black.withAlphaComponent(0.3)
        self.addSubview(popupView)
        popupView.addSubview(bodyStackView)
        [subjectLabel, midLineView, descriptionLabel, centerButton]
            .forEach(bodyStackView.addArrangedSubview(_:))
        
        popupView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.centerY.equalToSuperview()
        }
        bodyStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(25)
            $0.bottom.equalToSuperview().inset(25)
        }
        subjectLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        midLineView.snp.makeConstraints {
            $0.top.equalTo(subjectLabel.snp.bottom).offset(12)
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
            $0.bottom.equalToSuperview().inset(20)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
        
        centerButton.addTarget(self, action: #selector(retryMission), for: .touchUpInside)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func retryMission() {
        parentVC?.retryMission()
    }
}
