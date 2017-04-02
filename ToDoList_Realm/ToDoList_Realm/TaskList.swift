//
//  TaskList.swift
//  ToDoList_Realm
//
//  Created by zhuchenglong on 2017/4/2.
//  Copyright © 2017年 goodcoder.zcl. All rights reserved.
//

import Foundation
import RealmSwift

class TaskList: Object {
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    let tasks = List<Task>()

}
