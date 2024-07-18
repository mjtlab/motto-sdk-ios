//
//  DialogView.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import SnapKit
import Then

class DialogView: UIView {
    
    var ticketImage = ["ticket1.png", "ticket2.png", "ticket3.png"]
    var timer: Timer?
    var parentVC: DialogViewController?
    
    private let popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    private let bodyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
    }
    // slot
    private let slotView = UIPickerView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = false
    }
    private let slotBorderView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.red.cgColor
        $0.layer.borderWidth = 1
        $0.clipsToBounds = false
    }
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    private let descLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 15)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    private let descLabel2 = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    private let centerButton = UIButton().then {
        $0.backgroundColor = .baseRed
        $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = false
        $0.isEnabled = false
    }
    
    init() {
        self.titleLabel.text = "\(Motto.currentRound)회"
        self.descLabel.text = Description.loadCampaign
        self.centerButton.setTitle(Dialog.ok, for: .normal)
        super.init(frame: .zero)
        
        self.backgroundColor = .black.withAlphaComponent(0.3)
        self.addSubview(self.popupView)
        [self.titleLabel, self.slotView, self.slotBorderView, self.bodyStackView, self.centerButton]
            .forEach(self.popupView.addSubview(_:))
        [self.descLabel, self.descLabel2]
            .forEach(self.bodyStackView.addArrangedSubview(_:))
        
        self.popupView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        self.slotView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.left.right.equalToSuperview().inset(100)
            $0.height.equalTo(70)
            $0.width.equalTo(100)
        }
        self.bodyStackView.snp.makeConstraints {
            $0.top.equalTo(slotView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
        }
        self.slotBorderView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(100)
            $0.height.equalTo(50)
            $0.width.equalTo(100)
        }
        self.centerButton.snp.makeConstraints {
            $0.top.equalTo(self.bodyStackView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(20)
            $0.left.right.equalToSuperview().inset(35)
            $0.height.equalTo(48)
        }
        
        slotView.delegate = self
        slotView.dataSource = self
        slotView.isUserInteractionEnabled = false
        slotView.reloadAllComponents()
        slotView.subviews.first?.subviews.last?.backgroundColor = UIColor.white
        
        centerButton.addTarget(self, action: #selector(goMission), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveTicket), name: .mission, object: nil)
        
        trigger()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func goMission() {
        parentVC?.goMission()
    }
    
    @objc func receiveTicket(_ notification: Notification) {
        let getValue = notification.object as! Int
       
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.timer?.invalidate()
            
            if getValue == 0 {
                self.parentVC?.alertMsg()
            } else {
                switch getValue {
                case 1,2,3:
                    self.slotView.selectRow(getValue-1, inComponent: 0, animated: false)
                default:
                    self.parentVC?.alertMsg()
                }
            }
            self.centerButton.isEnabled = true
            self.descLabel.text = Description.receiveCampaign
            self.descLabel2.text = Description.receiveCampaign2
        }
    }
    
    func trigger() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(scrollRandomly), userInfo: nil, repeats: true)
    }

    @objc func scrollRandomly() {
        let row:Int = Int.random(in: 0..<300)
        self.slotView.selectRow(row, inComponent: 0, animated: true)
    }
}

extension UIColor {
    func asImage(_ width: CGFloat = UIScreen.main.bounds.width, _ height: CGFloat = 1.0) -> UIImage {
        let size: CGSize = CGSize(width: width, height: height)
        let image: UIImage = UIGraphicsImageRenderer(size: size).image { context in
            setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return image
    }
}

extension DialogView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ticketImage.count * 100
    }
}
extension DialogView: UIPickerViewDelegate {
    // 피커 뷰의 높이 설정
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let imageView = UIImageView(image: Utils.podImage(context: DialogView.self, img: ticketImage[row % ticketImage.count]))
        imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 50) // 이미지 뷰의 프레임 크기 설정
        
        if #available(iOS 14.0, *) { pickerView.subviews[1].backgroundColor = .clear }
        
        return imageView
    }
}
