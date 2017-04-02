//
//  Task.swift
//  ToDoList_Realm
//
//  Created by zhuchenglong on 2017/4/2.
//  Copyright © 2017年 goodcoder.zcl. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    dynamic var notes = ""
    dynamic var isCompleted = false

}
