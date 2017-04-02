//
//  TaskListsVC.swift
//  ToDoList_Realm
//
//  Created by zhuchenglong on 2017/4/2.
//  Copyright © 2017年 goodcoder.zcl. All rights reserved.
//

import UIKit
import RealmSwift

class TaskListsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var taskListTableView: UITableView!
    let myRealm = try! Realm()
    var lists:Results<TaskList>!
    var isEditingMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lists = myRealm.objects(TaskList.self)
        taskListTableView.setEditing(false, animated: true)
        taskListTableView.reloadData()
    }
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        
    }
    
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        
    }
    

    @IBAction func sortAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            lists = lists.sorted(byKeyPath: "name", ascending: true)
        }else{
            lists = lists.sorted(byKeyPath: "createdAt", ascending: false)
        }
        taskListTableView.reloadData()
    }
    
    
    
    //tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lists == nil {
            return 0
        }else {
            return lists.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        let list = lists[indexPath.row]
        cell.textLabel?.text = list.name
        cell.detailTextLabel?.text = "\(list.tasks.count) tasks."
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "openTasks", sender: self.lists[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tasksVC = segue.destination as! TasksVC
        tasksVC.selectedList = sender as! TaskList
    }
}
