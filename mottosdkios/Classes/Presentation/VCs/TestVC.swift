//
//  TestVC.swift
//  mottoapp
//
//  Created by MHD on 2024/04/30.
//

import UIKit

class TestVC: UIViewController {
    private let button = {
        let button = UIButton()
        button.setTitle("scrollToBottom", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.blue, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let tableView = {
        let view = UITableView()
        view.allowsSelection = false
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.bounces = true
        view.showsVerticalScrollIndicator = true
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.estimatedRowHeight = 34
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dataSource = (0...100).map(String.init)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.addAction(
            UIAction { [weak self] _ in
                self?.tableView.scrollToBottom(completion: {
                    print("finish!")
                })
            }, for: .touchUpInside
        )
        tableView.dataSource = self
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 16),
        ])
    }
}

extension TestVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
}

//extension UIScrollView {
//    func scrollToBottom(completion: (() -> ())? = nil) {
//        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
//        if(bottomOffset.y > 0) {
//            setContentOffset(offset: bottomOffset, animated: true, completion: completion)
//        }
//    }
//    
//    func setContentOffset(offset: CGPoint, animated: Bool, completion: (() -> ())? = nil) {
//        let keypath = "contentOffsetAnimationDuration"
//        guard let duration = value(forKey: keypath) as? Double else { return }
//        
//        setContentOffset(offset, animated: true)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
//            completion?()
//        }
//    }
//}
