//
//  BaseTabBarController.swift
//  HeartCare
//
//  Created by 六神 on 2019/5/3.
//  Copyright © 2019 222. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetting()
        configureItems()
    }
    
    private func basicSetting() {
        tabBar.tintColor = MAIN_COLOR
    }
    
    private func configureItems() {
        var testVC: UIViewController = RootViewController()
        testVC = configureItem(testVC, name: "measure")
        var chartVC: UIViewController = ChartViewController()
        chartVC = configureItem(chartVC, name: "chart")
        viewControllers = [testVC, chartVC]
    }
    
    private func configureItem(_ vc: UIViewController, name: String) -> BaseNavigationController {
        let img_n = UIImage(named: "\(name)_n")
        let img_s = UIImage(named: "\(name)_s")
        let item = UITabBarItem(title: name, image: img_n, selectedImage: img_s)
        vc.title = name
        vc.tabBarItem = item
        return BaseNavigationController(rootViewController: vc)
    }
    
}
