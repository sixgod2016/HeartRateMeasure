//
//  BaseNavigationController.swift
//  HeartCare
//
//  Created by 六神 on 2019/5/3.
//  Copyright © 2019 222. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetting()
    }
    
    private func basicSetting() {
        view.backgroundColor = UIColor.white
        view.tintColor = MAIN_COLOR
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        /*navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]*/
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 { viewController.hidesBottomBarWhenPushed = true }
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        viewController.view.backgroundColor = UIColor.white
        super.pushViewController(viewController, animated: true)
    }

}
