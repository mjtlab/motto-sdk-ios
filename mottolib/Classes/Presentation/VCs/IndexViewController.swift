//
//  IndexViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import SnapKit
import Then

final class IndexViewController: UIViewController {
    private var currentPageIndex = 0 {
        didSet {
            if currentPageIndex == 3 { currentPageIndex = oldValue }
            moveInPageViewController(currIndex: oldValue, targetIndex: currentPageIndex)
        }
    }

    private let topTabBarView = TopTabBarView()
    private let backgroundView = UIView().then {
        $0.backgroundColor = .baseWhite
        $0.isHidden = false
    }
    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal)

    private lazy var controllers: [UIViewController] = TopTabBarView.TopTab.allCases.map({ $0.viewController })

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .baseWhite
        
        
//        Motto.uid = UserDefaults.standard.string(forKey: "uid") ?? ""
        Motto.adid = UserDefaults.standard.string(forKey: "adid") ?? ""
//        Motto.pubkey = (Config.pubkey == MLDefine.pub_key) ? MLDefine.pub_key : Config.pubkey
        Motto.isLaunched = true
        
        setDelegate()
        setLayout()
        setPageViewController()
    }

    // MARK: - Func
    func setLayout() {
        view.addSubviews(
            topTabBarView,
            backgroundView,
            pageViewController.view
        )
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(topTabBarView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(topTabBarView.snp.bottom)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        topTabBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Utils.getHeight(40))
        }
    }
    
    private func setPageViewController() {
        self.addChild(pageViewController)

        pageViewController.didMove(toParent: self)

        guard let firstVC = controllers.first,
              let homeVC = firstVC as? NewHomeViewController
        else {
            return
        }

        pageViewController.setViewControllers(
            [homeVC],
            direction: .forward,
            animated: true)
        
        let scrollView = pageViewController.view.subviews
            .compactMap { $0 as? UIScrollView }
            .first
        
        scrollView!.bounces = false
        scrollView!.showsVerticalScrollIndicator = false
    }
    
    private func setDelegate() {
        topTabBarView.delegate = self
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }

    private func moveInPageViewController(currIndex: Int, targetIndex: Int) {
        guard targetIndex >= 0 && targetIndex < controllers.count else { return }
        let direction: UIPageViewController.NavigationDirection = currIndex < targetIndex
        ? .forward
        : .reverse
        pageViewController.setViewControllers([controllers[targetIndex]], direction: direction, animated: true)
        topTabBarView.setIndicatorBar(to: targetIndex)
    }
}

// MARK: - Protocol extension
extension IndexViewController: TopTabBarViewProtocol {
    func moveToTargetViewController(index: Int) {
        if index == 1 || index == 2 {
            if Motto.uid == "" {
                let alert = UIAlertController(title: Title.serviceInfo, message: Description.needLogin, preferredStyle: .alert)
                let yes = UIAlertAction(title: Dialog.ok, style: .destructive) {_ in
                    // 로그인 이동
                    let viewcontroller = AccountViewController()
                    viewcontroller.dataFromVC = "SELF"
                    viewcontroller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                    self.present(viewcontroller, animated: true, completion: nil)
                }
                let no = UIAlertAction(title: Dialog.cancel, style: .cancel, handler: nil)
                
                alert.addAction(no)
                alert.addAction(yes)
                
                self.present(alert, animated: true, completion: nil)
                self.currentPageIndex = 0
            } else {
                self.currentPageIndex = index
            }
        } else if index == 3 {
            // 새로운 뷰컨 띄운다.
            let viewcontroller = NewHallOfFameViewController()
            viewcontroller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(viewcontroller, animated: false, completion: nil)
            
            self.currentPageIndex = index
        } else {
            self.currentPageIndex = index
        }
    }
}

// MARK: - Protocol extension
extension IndexViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let targetVC = pendingViewControllers.first,
              let targetIndex = controllers.firstIndex(of: targetVC)
        else { return }
        topTabBarView.setIndicatorBar(to: targetIndex)
    }


    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVC = pageViewController.viewControllers?.first,
              let currentPageIndex = controllers.firstIndex(of: currentVC)
        else { return }

        if !topTabBarView.checkIsBarAndPageInSameIndex(for: currentPageIndex) {
            topTabBarView.setIndicatorBar(to: currentPageIndex)
        }
    }
}
// MARK: - Protocol extension
extension IndexViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        return nil
    }
}
