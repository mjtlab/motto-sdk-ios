//
//  GuideCommView.swift
//  mottoapp. guide_comm_step. added subview in VC
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import SwiftUI

class GuideCommView: UIView {
//    @Binding var isShowing: Bool
    var parentVC: GuideCommViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let modalView = UIStackView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = false
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    // category별 컨텐츠 영역 1. naver login =========================
    let loginView = UIStackView().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    let subjectLoginLabel = UILabel().then {
        $0.text = Words.naverLogin
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let midLineLoginView = UIView().then {
        $0.backgroundColor = .red
        $0.clipsToBounds = true
    }
    let descriptionLoginLabel = UILabel().then {
        $0.text = Description.loginNaver
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let bodyLoginImageBackView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    let bodyLoginImageView = UIImageView().then {
        $0.image = Utils.podImage(context: GuideCommView.self, img: "naver_process_login")
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    let centerLoginButton = UIButton().then {
        $0.backgroundColor = UIColor(hexCode: "f8a726")
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Dialog.ok, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    // category별 컨텐츠 영역 1. naver login =========================
    // category별 컨텐츠 영역 2. 상품찾아가기 ============================
    let goodsView = UIStackView().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    let subjectGoodsLabel = UILabel().then {
        $0.text = Words.findStore
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 20)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let midLineGoodsView = UIView().then {
        $0.backgroundColor = .red
        $0.clipsToBounds = true
    }
    let descriptionGoodsLabel = UILabel().then {
        $0.text = "빨간박스 상품 명을 클릭 후"
        $0.textColor = .red
        $0.font = .boldSystemFont(ofSize: 18)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let descriptionGoodsLabel_2 = UILabel().then {
        $0.text = "미션을 진행해주세요."
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 18)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let buttonGoodsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    let partGoodsButton = UIButton().then {
        $0.backgroundColor = UIColor(hexCode: "f8a726")
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.part, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    let closeGoodsButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.close, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    // category별 컨텐츠 영역 2. 상품찾아가기 ===========================
    // category별 컨텐츠 영역 3. 플레이스 더보기 =========================
    let placeView = UIStackView().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    let subjectPlaceLabel = UILabel().then {
        $0.text = Words.clickMore
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 20)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let midLinePlaceView = UIView().then {
        $0.backgroundColor = .red
        $0.clipsToBounds = true
    }
    let descriptionPlaceLabel = UILabel().then {
        $0.text = "더보기 -> 빨간 박스를"
        $0.textColor = .red
        $0.font = .boldSystemFont(ofSize: 18)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let descriptionPlaceLabel_2 = UILabel().then {
        $0.text = "클릭해주세요."
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 18)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let buttonPlaceStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    let partPlaceButton = UIButton().then {
        $0.backgroundColor = UIColor(hexCode: "f8a726")
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.part, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    let closePlaceButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.close, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    // category별 컨텐츠 영역 3. 플레이스 더보기 ========================
    // category별 컨텐츠 영역 4. 쇼핑 더보기 ===========================
    let shopView = UIStackView().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    let subjectShopLabel = UILabel().then {
        $0.text = "쇼핑 더보기 ->\n클릭해 주세요"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let midLineShopView = UIView().then {
        $0.backgroundColor = .red
        $0.clipsToBounds = true
    }
    let descriptionShopLabel = UILabel().then {
        $0.text = "(아래쪽 쇼핑탭에 있어요)"
        $0.textColor = .red
        $0.font = .boldSystemFont(ofSize: 20)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let buttonShopStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    let partShopButton = UIButton().then {
        $0.backgroundColor = UIColor(hexCode: "f8a726")
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.part, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    let closeShopButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.close, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    // category별 컨텐츠 영역 4. 쇼핑 더보기 ===========================
    // category별 컨텐츠 영역 5. 미션 실패 ============================
    let failView = UIStackView().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    let subjectFailLabel = UILabel().then {
        $0.textColor = .black
        $0.text = Words.failMission
        $0.font = .boldSystemFont(ofSize: 25)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let midLineFailView = UIView().then {
        $0.backgroundColor = .red
        $0.clipsToBounds = true
    }
    let bodyFailImageBackView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    let bodyFailImageView = UIImageView().then {
        $0.image = Utils.podImage(context: GuideCommView.self, img: "btn_mission_info")
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    let midTextFailView = UIView().then {
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
    }
    let descriptionFailLabel = UILabel().then {
        $0.textColor = .red
        $0.text = "[해당 페이지 안내사항 다시보기]"
        $0.font = .boldSystemFont(ofSize: 15)
        $0.numberOfLines = 0
        $0.sizeToFit()
        $0.textAlignment = .center
    }
    let descriptionFailLabel_2 = UILabel().then {
        $0.textColor = .black
        $0.text = "를 클릭하여"
        $0.font = .boldSystemFont(ofSize: 15)
        $0.numberOfLines = 0
        $0.sizeToFit()
        $0.textAlignment = .center
    }
    let descriptionFailLabel_3 = UILabel().then {
        $0.textColor = .black
        $0.text = "미션 수행 상품내용을 다시 확인해주세요"
        $0.font = .boldSystemFont(ofSize: 15)
        $0.numberOfLines = 0
        $0.sizeToFit()
        $0.textAlignment = .center
    }
    let centerFailButton = UIButton().then {
        $0.backgroundColor = UIColor(hexCode: "f8a726")
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Dialog.ok, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    // category별 컨텐츠 영역 5. 미션 실패 ============================
    // category별 컨텐츠 영역 6. place traffic ======================
    let trafficView = UIStackView().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    let subjectTrafficLabel = UILabel().then {
        $0.textColor = .black
        $0.text = Words.tourStore
        $0.font = .boldSystemFont(ofSize: 25)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let midLineTrafficView = UIView().then {
        $0.backgroundColor = .red
        $0.clipsToBounds = true
    }
    let descriptionTrafficLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "탭의 메뉴를 클릭하면 시간을 빠르게 줄일 수 있습니다."
        $0.font = .boldSystemFont(ofSize: 15)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let bodyTrafficImageBackView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    let bodyTrafficImageView = UIImageView().then {
        $0.image = Utils.podImage(context: GuideCommView.self, img: "place_traffic_guide1")
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    let bodyTrafficTipLabel = UIButton().then {
        $0.backgroundColor = .red
        $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
        $0.setTitle("Tip! 여러곳을 클릭하여 시간을 줄여보세요.", for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = false
        $0.isEnabled = false
    }
    let centerTrafficButton = UIButton().then {
        $0.backgroundColor = UIColor(hexCode: "f8a726")
        $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
        $0.setTitle(Dialog.ok, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // category별 컨텐츠 영역 6. place traffic ======================
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loginView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        goodsView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        placeView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        shopView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        failView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        trafficView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    func setLayout() {
        // arrange & constraint
        self.backgroundColor = .black.withAlphaComponent(0.3)
        self.addSubviews(
            loginView,
            goodsView,
            placeView,
            shopView,
            failView,
            trafficView
        )
        // =======================
        loginView.addSubviews(
            subjectLoginLabel,
            midLineLoginView,
            descriptionLoginLabel,
            bodyLoginImageBackView,
            bodyLoginImageView,
            centerLoginButton
        )
        // =======================
        // =======================
//        [subjectGoodsLabel, midLineGoodsView, descriptionGoodsLabel, descriptionGoodsLabel_2, buttonGoodsStackView]
//            .forEach(goodsView.addArrangedSubview(_:))
//        [partGoodsButton, closeGoodsButton]
//            .forEach(buttonGoodsStackView.addArrangedSubview(_:))
        goodsView.addSubviews(
            subjectGoodsLabel,
            midLineGoodsView,
            descriptionGoodsLabel,
            descriptionGoodsLabel_2,
            buttonGoodsStackView
        )
        buttonGoodsStackView.addSubviews(
            partGoodsButton,
            closeGoodsButton
        )
        // =======================
        // =======================
        placeView.addSubviews(
            subjectPlaceLabel,
            midLinePlaceView,
            descriptionPlaceLabel,
            descriptionPlaceLabel_2,
            buttonPlaceStackView
        )
        buttonPlaceStackView.addSubviews(
            partPlaceButton,
            closePlaceButton
        )
        // =======================
        // =======================
        shopView.addSubviews(
            subjectShopLabel,
            midLineShopView,
            descriptionShopLabel,
            buttonShopStackView
        )
        buttonShopStackView.addSubviews(
            partShopButton,
            closeShopButton
        )
        // =======================
        // =======================
        failView.addSubviews(
            subjectFailLabel,
            midLineFailView,
            bodyFailImageBackView,
            bodyFailImageView,
            midTextFailView,
            descriptionFailLabel_3,
            centerFailButton
        )
        midTextFailView.addSubviews(
            descriptionFailLabel,
            descriptionFailLabel_2
        )
        // =======================
        // =======================
        trafficView.addSubviews(
            subjectTrafficLabel,
            midLineTrafficView,
            descriptionTrafficLabel,
            bodyTrafficImageBackView,
            bodyTrafficImageView,
            bodyTrafficTipLabel,
            centerTrafficButton
        )
        
        // category별 컨텐츠 영역 1. naver login =========================
        self.loginView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(600)
        }
        self.subjectLoginLabel.snp.makeConstraints { make in
            make.bottom.equalTo(midLineLoginView.snp.top).offset(-15)
            make.centerX.equalTo(loginView.snp.centerX)
        }
        self.midLineLoginView.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLoginLabel.snp.top).offset(-15)
            make.centerX.equalTo(loginView.snp.centerX)
            make.height.equalTo(4)
            make.width.equalTo(50)
        }
        self.descriptionLoginLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bodyLoginImageBackView.snp.top).offset(-15)
            make.centerX.equalTo(loginView.snp.centerX)
        }
        self.bodyLoginImageBackView.snp.makeConstraints { make in
            make.top.equalTo(bodyLoginImageView.snp.top).offset(-5)
            make.bottom.equalTo(bodyLoginImageView.snp.bottom).offset(5)
            make.left.equalTo(bodyLoginImageView.snp.left).offset(-5)
            make.right.equalTo(bodyLoginImageView.snp.right).offset(5)
            make.centerX.equalTo(loginView.snp.centerX)
        }
        self.bodyLoginImageView.snp.makeConstraints { make in
            make.bottom.equalTo(centerLoginButton.snp.top).offset(-25)
            make.centerX.equalTo(loginView.snp.centerX)
            make.width.equalTo(280)
            make.height.equalTo(315)
        }
        self.centerLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(loginView.snp.centerX)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        // category별 컨텐츠 영역 1. naver login =========================
        // category별 컨텐츠 영역 2. 상품찾아가기 ===========================
        self.goodsView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(250)
        }
        self.subjectGoodsLabel.snp.makeConstraints { make in
            make.bottom.equalTo(midLineGoodsView.snp.top).offset(-15)
            make.centerX.equalTo(goodsView.snp.centerX)
        }
        self.midLineGoodsView.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionGoodsLabel.snp.top).offset(-15)
            make.centerX.equalTo(goodsView.snp.centerX)
            make.height.equalTo(4)
            make.width.equalTo(50)
        }
        self.descriptionGoodsLabel.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionGoodsLabel_2.snp.top).offset(-5)
            make.centerX.equalTo(goodsView.snp.centerX)
            make.height.equalTo(20)
        }
        self.descriptionGoodsLabel_2.snp.makeConstraints { make in
            make.bottom.equalTo(buttonGoodsStackView.snp.top).offset(-25)
            make.centerX.equalTo(goodsView.snp.centerX)
            make.height.equalTo(20)
        }
        self.buttonGoodsStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(goodsView.snp.centerX)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        self.partGoodsButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        self.closeGoodsButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        // category별 컨텐츠 영역 2. 상품찾아가기 ===========================
        // category별 컨텐츠 영역 3. 플레이스 더보기 ========================
        self.placeView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(250)
        }
        self.subjectPlaceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(midLinePlaceView.snp.top).offset(-15)
            make.centerX.equalTo(placeView.snp.centerX)
        }
        self.midLinePlaceView.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionPlaceLabel.snp.top).offset(-15)
            make.centerX.equalTo(placeView.snp.centerX)
            make.height.equalTo(4)
            make.width.equalTo(50)
        }
        self.descriptionPlaceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionPlaceLabel_2.snp.top).offset(-5)
            make.centerX.equalTo(placeView.snp.centerX)
            make.height.equalTo(20)
        }
        self.descriptionPlaceLabel_2.snp.makeConstraints { make in
            make.bottom.equalTo(buttonPlaceStackView.snp.top).offset(-25)
            make.centerX.equalTo(placeView.snp.centerX)
            make.height.equalTo(20)
        }
        self.buttonPlaceStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(placeView.snp.centerX)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        self.partPlaceButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        self.closePlaceButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        // category별 컨텐츠 영역 3. 플레이스 더보기 ========================
        // category별 컨텐츠 영역 4. 쇼핑 더보기 ===========================
        self.shopView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(250)
        }
        self.subjectShopLabel.snp.makeConstraints { make in
            make.bottom.equalTo(midLineShopView.snp.top).offset(-15)
            make.centerX.equalTo(shopView.snp.centerX)
        }
        self.midLineShopView.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionShopLabel.snp.top).offset(-15)
            make.centerX.equalTo(shopView.snp.centerX)
            make.height.equalTo(4)
            make.width.equalTo(50)
        }
        self.descriptionShopLabel.snp.makeConstraints { make in
            make.bottom.equalTo(buttonShopStackView.snp.top).offset(-25)
            make.centerX.equalTo(shopView.snp.centerX)
            make.height.equalTo(20)
        }
        self.buttonShopStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(shopView.snp.centerX)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        self.partShopButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        self.closeShopButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        // category별 컨텐츠 영역 4. 쇼핑 더보기 ===========================
        // category별 컨텐츠 영역 5. 미션 실패 ============================
        self.failView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(330)
        }
        self.subjectFailLabel.snp.makeConstraints { make in
            make.bottom.equalTo(midLineFailView.snp.top).offset(-15)
            make.centerX.equalTo(failView.snp.centerX)
        }
        self.midLineFailView.snp.makeConstraints { make in
            make.bottom.equalTo(bodyFailImageBackView.snp.top).offset(-15)
            make.centerX.equalTo(failView.snp.centerX)
            make.height.equalTo(4)
            make.width.equalTo(50)
        }
        self.bodyFailImageBackView.snp.makeConstraints { make in
            make.top.equalTo(bodyFailImageView.snp.top).offset(-5)
            make.bottom.equalTo(bodyFailImageView.snp.bottom).offset(5)
            make.left.equalTo(bodyFailImageView.snp.left).offset(-5)
            make.right.equalTo(bodyFailImageView.snp.right).offset(5)
            make.centerX.equalTo(failView.snp.centerX)
        }
        self.bodyFailImageView.snp.makeConstraints { make in
            make.bottom.equalTo(midTextFailView.snp.top).offset(-25)
            make.centerX.equalTo(failView.snp.centerX)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        let viewSize = descriptionFailLabel.intrinsicContentSize
        let viewSize2 = descriptionFailLabel_2.intrinsicContentSize
        self.midTextFailView.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionFailLabel_3.snp.top).offset(-5)
            make.centerX.equalTo(failView.snp.centerX)
            make.width.equalTo(viewSize.width + viewSize2.width + 40)
            make.height.equalTo(20)
        }
        self.descriptionFailLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
        self.descriptionFailLabel_2.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(descriptionFailLabel.snp.right)
        }
        self.descriptionFailLabel_3.snp.makeConstraints { make in
            make.bottom.equalTo(centerFailButton.snp.top).offset(-25)
            make.centerX.equalTo(failView.snp.centerX)
            make.height.equalTo(20)
        }
        self.centerFailButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(failView.snp.centerX)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        // category별 컨텐츠 영역 5. 미션 실패 ============================
        // category별 컨텐츠 영역 6. place traffic ======================
        self.trafficView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(320)
        }
        self.subjectTrafficLabel.snp.makeConstraints { make in
            make.bottom.equalTo(midLineTrafficView.snp.top).offset(-15)
            make.centerX.equalTo(trafficView.snp.centerX)
        }
        self.midLineTrafficView.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionTrafficLabel.snp.top).offset(-15)
            make.centerX.equalTo(trafficView.snp.centerX)
            make.height.equalTo(4)
            make.width.equalTo(50)
        }
        self.descriptionTrafficLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bodyTrafficImageBackView.snp.top).offset(-15)
            make.centerX.equalTo(trafficView.snp.centerX)
            make.height.equalTo(20)
        }
        self.bodyTrafficImageBackView.snp.makeConstraints { make in
            make.top.equalTo(bodyTrafficImageView.snp.top).offset(-5)
            make.bottom.equalTo(bodyTrafficImageView.snp.bottom).offset(5)
            make.left.equalTo(bodyTrafficImageView.snp.left).offset(-5)
            make.right.equalTo(bodyTrafficImageView.snp.right).offset(5)
            make.centerX.equalTo(trafficView.snp.centerX)
        }
        self.bodyTrafficImageView.snp.makeConstraints { make in
            make.bottom.equalTo(bodyTrafficTipLabel.snp.top).offset(-15)
            make.centerX.equalTo(trafficView.snp.centerX)
            make.width.equalTo(300)
        }
        self.bodyTrafficTipLabel.snp.makeConstraints { make in
            make.bottom.equalTo(centerTrafficButton.snp.top).offset(-25)
            make.centerX.equalTo(trafficView.snp.centerX)
            make.height.equalTo(24)
            make.width.equalTo(270)
        }
        self.centerTrafficButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(trafficView.snp.centerX)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        // category별 컨텐츠 영역 6. place traffic ======================
    }
}
