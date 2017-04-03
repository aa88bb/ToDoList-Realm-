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
    var currentCreateAction:UIAlertAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lists = myRealm.objects(TaskList.self)
        taskListTableView.setEditing(false, animated: true)
        taskListTableView.reloadData()
    }
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        isEditingMode = !isEditingMode
        taskListTableView.setEditing(isEditingMode, animated: true)
        taskListTableView.reloadData()
    }
    
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        displayAlertToAddTaskList(nil)
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete") { (action, indexpath) in
            let listToBeDeleted = self.lists[indexpath.row]
            
            try! self.myRealm.write {
                self.myRealm.delete(listToBeDeleted)
                self.taskListTableView.reloadData()
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexpath) in
            let listToBeEdit = self.lists[indexpath.row]
            self.displayAlertToAddTaskList(listToBeEdit)
        }
        return [deleteAction,editAction]
    }
    
    
    
    func displayAlertToAddTaskList(_ updatedList:TaskList!){
        var title = "New Task List"
        var doneTitle = "Create"
        
        if updatedList != nil {
            title = "Update Task List"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "write the name of your task list.", preferredStyle: .alert)
        let createAction = UIAlertAction(title: doneTitle, style: .default) { (action) in
            let listName = alertController.textFields?.first?.text
            if updatedList != nil {
                try! self.myRealm.write {
                    updatedList.name = listName!
                    self.taskListTableView.reloadData()
                }
            }else{
                let newTaskList = TaskList()
                newTaskList.name = listName!
                try! self.myRealm.write {
                    self.myRealm.add(newTaskList)
                    self.taskListTableView.reloadData()
                }
            }
        }
        alertController.addAction(createAction)
        createAction.isEnabled = false
        self.currentCreateAction = createAction
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Task List Name"
            textfield.clearButtonMode = .always
            textfield.addTarget(self, action: #selector(self.listNameFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            if updatedList != nil {
                textfield.text = updatedList.name
            }
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func listNameFieldDidChange(_ textField:UITextField){
        self.currentCreateAction.isEnabled = (textField.text?.characters.count)! > 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "openTasks", sender: self.lists[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tasksVC = segue.destination as! TasksVC
        tasksVC.selectedList = sender as! TaskList
    }
}
