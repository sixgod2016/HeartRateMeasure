//
//  Date+Extension.swift
//  HeartCare
//
//  Created by 六神 on 2019/5/4.
//  Copyright © 2019 222. All rights reserved.
//

import Foundation

extension Date {
    func getTimeZone() -> TimeZone {
        return TimeZone.current
    }
    
    func toString() -> String {
        let formatter = DateFormatter()
        //        formatter.timeZone = getTimeZone()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let descrption = formatter.string(from: self)
        return descrption
    }
}
