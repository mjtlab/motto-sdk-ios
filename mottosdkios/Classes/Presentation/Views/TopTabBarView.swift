//
//  TopTabBarView.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit

protocol TopTabBarViewProtocol: AnyObject {
    func moveToTargetViewController(index: Int)
}

final class TopTabBarView: BaseView {

    @frozen
    enum TopTab: String, CaseIterable {
        case home = "모또얻기"
        case myMotto = "내모또"
        case prizeNumber = "당첨번호"
        case hallOfFame = "명예전당"

        var viewController: UIViewController {
            switch self {
            case .home:
                return Motto.makeNewHomeViewController()
            case .myMotto:
                return Motto.makeMyMottoViewController()
            case .prizeNumber:
                return Motto.makePrizeNumberViewController()
            case .hallOfFame:
                return Motto.makeHallOfFameViewController()
            }
        }
    }

    private var targetIndex: Int = 0 {
        didSet {
            moveIndicatorbar(targetIndex: targetIndex)
        }
    }

    var delegate: TopTabBarViewProtocol?

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let indicatorUnderLineView = UIView().then {
        // 혹 필요할 수도 있어서.
        $0.backgroundColor = .clear
    }
    private let indicatorView = UIView().then {
        $0.backgroundColor = .baseBlack
    }

    override func setStyle() {
        collectionView.do {
            $0.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
            $0.delegate = self
            $0.dataSource = self
            $0.register(TopTabBarCollectionViewCell.self, forCellWithReuseIdentifier: TopTabBarCollectionViewCell.className)
        }
    }

    override func setLayout() {
        self.addSubviews(
            collectionView,
            indicatorUnderLineView,
            indicatorView
        )
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(indicatorUnderLineView.snp.top)
        }
        indicatorUnderLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalToSuperview()
        }
        indicatorView.snp.makeConstraints { make in
            make.bottom.equalTo(indicatorUnderLineView.snp.top)
            make.leading.equalToSuperview()
            make.width.equalTo(89)
            make.height.equalTo(3)
        }
    }
}

extension TopTabBarView {
    func moveIndicatorbar(targetIndex: Int) {
        let indexPath = IndexPath(item: targetIndex, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        guard let cell = collectionView.cellForItem(at: indexPath) as? TopTabBarCollectionViewCell else { return }

        indicatorView.snp.remakeConstraints { make in
            make.centerX.equalTo(cell)
            make.width.equalTo(cell.getTabCellFrameWidth())
            make.height.equalTo(3)
            make.bottom.equalTo(indicatorUnderLineView.snp.top)
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

    func setIndicatorBar(to targetIndex: Int) {
        self.targetIndex = targetIndex
    }

    func checkIsBarAndPageInSameIndex(for currentIndex: Int) -> Bool {
        return self.targetIndex == currentIndex
    }
}


extension TopTabBarView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(collectionView.frame.width) / TopTab.allCases.count - 8 
        let size = CGSize(width: width, height: width)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension TopTabBarView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let targetIndex = indexPath.item
        self.targetIndex = targetIndex
        delegate?.moveToTargetViewController(index: targetIndex)
    }
}

extension TopTabBarView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TopTab.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopTabBarCollectionViewCell.className, for: indexPath) as? TopTabBarCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        let title = TopTab.allCases[indexPath.item].rawValue
        cell.configureCell(title: title)

        return cell
    }
}
