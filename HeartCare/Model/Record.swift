//
//  Record.swift
//  HeartCare
//
//  Created by 六神 on 2019/5/3.
//  Copyright © 2019 222. All rights reserved.
//

import Foundation
import CoreData

final class Record: NSManagedObject {
    @NSManaged var id: Date
    @NSManaged var arr: [Int]
}
