//
//  GuideView.swift
//  mottoapp. guide_step. added subview in VC
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import SwiftUI

class GuideView: UIView {
    var parentVC: GuideViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // category별 컨텐츠 영역 1. place save =========================
    let placeView = UIStackView().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
    }
    let subjectLabel = UILabel().then {
        $0.text = Words.save
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midLineView = UIView().then {
        $0.backgroundColor = .red
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let descriptionLabel = UILabel().then {
        $0.text = Description.clickSave
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bodyImageBackView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bodyImageView = UIImageView().then {
        $0.image = Utils.podImage(context: GuideView.self, img: "naver_process2")
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let partButton = UIButton().then {
        $0.backgroundColor = UIColor(hexCode: "f8a726")
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.part, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let closeButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.close, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // category별 컨텐츠 영역 1. place save =========================
    // category별 컨텐츠 영역 1-1. place alarm ======================
    let alarmView = UIStackView().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
    }
    let subjectAlarmLabel = UILabel().then {
        $0.text = Words.alarm_save
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midLineAlarmView = UIView().then {
        $0.backgroundColor = .red
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let descriptionAlarmLabel = UILabel().then {
        $0.text = Description.clickAlarm
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 15)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bodyImageAlarmBackView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bodyImageAlarmView = UIImageView().then {
        $0.image = Utils.podImage(context: GuideView.self, img: "naver_place_alarm_save_guide")
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let buttonAlarmStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let partAlarmButton = UIButton().then {
        $0.backgroundColor = UIColor(hexCode: "f8a726")
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.part, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let closeAlarmButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.close, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // category별 컨텐츠 영역 1-1. place alarm ======================
    // category별 컨텐츠 영역 2. guide blog 1 =======================
    let blogView = UIStackView().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
    }
    let subjectBlogLabel = UILabel().then {
        $0.text = Words.share
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let midLineBlogView = UIView().then {
        $0.backgroundColor = .red
        $0.clipsToBounds = true
    }
    let descriptionBlogLabel = UILabel().then {
        $0.text = Description.clickShare
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let bodyImageBlogBackView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    let bodyImageBlogView = UIImageView().then {
        $0.image = Utils.podImage(context: GuideView.self, img: "naver_process_blog")
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    let buttonStackBlogView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    let partBlogButton = UIButton().then {
        $0.backgroundColor = UIColor(hexCode: "f8a726")
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.part, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    let closeBlogButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.close, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    // category별 컨텐츠 영역 2. guide blog 1 =======================
    // category별 컨텐츠 영역 3. guide blog 2 =======================
    let blog2View = UIStackView().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
    }
    let subjectBlog2Label = UILabel().then {
        $0.text = Words.shareAndCheck
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let midLineBlog2View = UIView().then {
        $0.backgroundColor = .red
        $0.clipsToBounds = true
    }
    let descriptionBlog2Label = UILabel().then {
        $0.text = Description.clickShareAndCheck
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let bodyImageBlog2BackView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    let bodyImageBlog2View = UIImageView().then {
        $0.image = Utils.podImage(context: GuideView.self, img: "naver_process_blog2")
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    let buttonStackBlog2View = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    let partBlog2Button = UIButton().then {
        $0.backgroundColor = UIColor(hexCode: "f8a726")
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.part, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    let closeBlog2Button = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Words.close, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
    }
    // category별 컨텐츠 영역 3. guide blog 2 =======================
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        blogView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        blog2View.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    func setLayout() {
        // arrange & constraint
        self.backgroundColor = .black.withAlphaComponent(0.3)
        self.addSubviews(
            placeView,
            alarmView,
            blogView,
            blog2View
        )
        placeView.addSubviews(
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
        alarmView.addSubviews(
            subjectAlarmLabel,
            midLineAlarmView,
            descriptionAlarmLabel,
            bodyImageAlarmBackView,
            bodyImageAlarmView,
            buttonAlarmStackView
        )
        buttonAlarmStackView.addSubviews(
            partAlarmButton,
            closeAlarmButton
        )
        blogView.addSubviews(
            subjectBlogLabel,
            midLineBlogView,
            descriptionBlogLabel,
            bodyImageBlogBackView,
            bodyImageBlogView,
            buttonStackBlogView
        )
        buttonStackBlogView.addSubviews(
            partBlogButton,
            closeBlogButton
        )
        blog2View.addSubviews(
            subjectBlog2Label,
            midLineBlog2View,
            descriptionBlog2Label,
            bodyImageBlog2BackView,
            bodyImageBlog2View,
            buttonStackBlog2View
        )
        buttonStackBlog2View.addSubviews(
            partBlog2Button,
            closeBlog2Button
        )
        
        self.placeView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(485)
        }
        self.subjectLabel.snp.makeConstraints { make in
            make.bottom.equalTo(midLineView.snp.top).offset(-15)
            make.centerX.equalTo(placeView.snp.centerX)
        }
        self.midLineView.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-15)
            make.centerX.equalTo(placeView.snp.centerX)
            make.height.equalTo(4)
            make.width.equalTo(50)
        }
        self.descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bodyImageBackView.snp.top).offset(-5)
            make.centerX.equalTo(placeView.snp.centerX)
            make.height.equalTo(20)
        }
        self.bodyImageBackView.snp.makeConstraints { make in
            make.top.equalTo(bodyImageView.snp.top).offset(-5)
            make.bottom.equalTo(bodyImageView.snp.bottom).offset(5)
            make.left.equalTo(bodyImageView.snp.left).offset(-5)
            make.right.equalTo(bodyImageView.snp.right).offset(5)
            make.centerX.equalTo(placeView.snp.centerX)
        }
        self.bodyImageView.snp.makeConstraints { make in
            make.bottom.equalTo(buttonStackView.snp.top).offset(-25)
            make.centerX.equalTo(placeView.snp.centerX)
            make.width.equalTo(280)
            make.height.equalTo(245)
        }
        self.buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(placeView.snp.centerX)
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
        self.alarmView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(370)
        }
        self.subjectAlarmLabel.snp.makeConstraints { make in
            make.bottom.equalTo(midLineAlarmView.snp.top).offset(-15)
            make.centerX.equalTo(alarmView.snp.centerX)
        }
        self.midLineAlarmView.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionAlarmLabel.snp.top).offset(-15)
            make.centerX.equalTo(alarmView.snp.centerX)
            make.height.equalTo(4)
            make.width.equalTo(50)
        }
        self.descriptionAlarmLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bodyImageAlarmBackView.snp.top).offset(-5)
            make.centerX.equalTo(alarmView.snp.centerX)
        }
        self.bodyImageAlarmBackView.snp.makeConstraints { make in
            make.top.equalTo(bodyImageAlarmView.snp.top).offset(-5)
            make.bottom.equalTo(bodyImageAlarmView.snp.bottom).offset(5)
            make.left.equalTo(bodyImageAlarmView.snp.left).offset(-5)
            make.right.equalTo(bodyImageAlarmView.snp.right).offset(5)
            make.centerX.equalTo(alarmView.snp.centerX)
            make.height.equalTo(130)
        }
        self.bodyImageAlarmView.snp.makeConstraints { make in
            make.bottom.equalTo(buttonAlarmStackView.snp.top).offset(-25)
            make.centerX.equalTo(alarmView.snp.centerX)
            make.width.equalTo(300)
//            make.height.equalTo(170)
        }
        self.buttonAlarmStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(alarmView.snp.centerX)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        self.partAlarmButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        self.closeAlarmButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        // ================================================
        self.blogView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(500)
        }
        self.subjectBlogLabel.snp.makeConstraints { make in
            make.bottom.equalTo(midLineBlogView.snp.top).offset(-15)
            make.centerX.equalTo(blogView.snp.centerX)
        }
        self.midLineBlogView.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionBlogLabel.snp.top).offset(-15)
            make.centerX.equalTo(blogView.snp.centerX)
            make.height.equalTo(4)
            make.width.equalTo(50)
        }
        self.descriptionBlogLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bodyImageBlogBackView.snp.top).offset(-5)
            make.centerX.equalTo(blogView.snp.centerX)
            make.height.equalTo(20)
        }
        self.bodyImageBlogBackView.snp.makeConstraints { make in
            make.top.equalTo(bodyImageBlogView.snp.top).offset(-5)
            make.bottom.equalTo(bodyImageBlogView.snp.bottom).offset(5)
            make.left.equalTo(bodyImageBlogView.snp.left).offset(-5)
            make.right.equalTo(bodyImageBlogView.snp.right).offset(5)
            make.centerX.equalTo(blogView.snp.centerX)
        }
        self.bodyImageBlogView.snp.makeConstraints { make in
            make.bottom.equalTo(buttonStackBlogView.snp.top).offset(-25)
            make.centerX.equalTo(blogView.snp.centerX)
            make.width.equalTo(280)
            make.height.equalTo(310)
        }
        self.buttonStackBlogView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(blogView.snp.centerX)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        self.partBlogButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        self.closeBlogButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        // ================================================
        self.blog2View.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(500)
        }
        self.subjectBlog2Label.snp.makeConstraints { make in
            make.bottom.equalTo(midLineBlog2View.snp.top).offset(-15)
            make.centerX.equalTo(blog2View.snp.centerX)
        }
        self.midLineBlog2View.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionBlog2Label.snp.top).offset(-15)
            make.centerX.equalTo(blog2View.snp.centerX)
            make.height.equalTo(4)
            make.width.equalTo(50)
        }
        self.descriptionBlog2Label.snp.makeConstraints { make in
            make.bottom.equalTo(bodyImageBlog2BackView.snp.top).offset(-5)
            make.centerX.equalTo(blog2View.snp.centerX)
            make.height.equalTo(20)
        }
        self.bodyImageBlog2BackView.snp.makeConstraints { make in
            make.top.equalTo(bodyImageBlog2View.snp.top).offset(-5)
            make.bottom.equalTo(bodyImageBlog2View.snp.bottom).offset(5)
            make.left.equalTo(bodyImageBlog2View.snp.left).offset(-5)
            make.right.equalTo(bodyImageBlog2View.snp.right).offset(5)
            make.centerX.equalTo(blog2View.snp.centerX)
        }
        self.bodyImageBlog2View.snp.makeConstraints { make in
            make.bottom.equalTo(buttonStackBlog2View.snp.top).offset(-25)
            make.centerX.equalTo(blog2View.snp.centerX)
            make.width.equalTo(280)
            make.height.equalTo(310)
        }
        self.buttonStackBlog2View.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(blog2View.snp.centerX)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        self.partBlog2Button.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        self.closeBlog2Button.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48)
        }
    }
}
