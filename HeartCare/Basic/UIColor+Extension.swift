//
//  UIColor+Extension.swift
//  HeartCare
//
//  Created by 六神 on 2019/5/4.
//  Copyright © 2019 222. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(HEX: String) {
        let scanner = Scanner(string: HEX)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(
            red : CGFloat(r) / 0xff,
            green : CGFloat(g) / 0xff,
            blue : CGFloat(b) / 0xff, alpha  : 1
        )
    }

}
