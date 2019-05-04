//
//  Basic.swift
//  HeartCare
//
//  Created by 六神 on 2019/5/3.
//  Copyright © 2019 222. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = Int(UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT = Int(UIScreen.main.bounds.size.height)
let NAVI_HEIGHT = SCREEN_WIDTH >= 812 ? 64 : 88

let MAIN_COLOR = UIColor(HEX: "#333333")

private let userDefault = UserDefaults.standard
private let FIRST_TIME_KEY = "FIRST_TIME_KEY"

func setFirstTime(_ val: Bool) {
    userDefault.set(val, forKey: FIRST_TIME_KEY)
}

func getFirstTime() -> Bool {
    let val = userDefault.value(forKey: FIRST_TIME_KEY)
    if let val = val, (val as! Bool) == false {
        return false
    }
    return true
}
