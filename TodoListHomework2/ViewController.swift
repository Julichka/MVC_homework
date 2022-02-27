//
//  ViewController.swift
//  TodoListHomework2
//
//  Created by Yuliia Khrupina on 2/26/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var sort: UIButton!
    
    var alert = UIAlertController()
    
    var model: Model = Model()
    
    var azSort: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(UITableViewCell.self,
                               forCellReuseIdentifier: "TableViewCell")
        table.dataSource = self
    }
    
    @IBAction func onAddClicked(_ sender: Any) {
        alert = UIAlertController(title: "Create new task", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Put your task here"
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        let createAlertAction = UIAlertAction(title: "Create", style: .default) { (createAlert) in
            // add new task
            
            guard let unwrTextFieldValue = self.alert.textFields?[0].text else {
                return
            }
            
            self.model.addItem(name: unwrTextFieldValue)
            self.model.sort(azSort: self.azSort)
            self.table.reloadData()
            
            
        }
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(cancelAlertAction)
        alert.addAction(createAlertAction)
        present(alert, animated: true, completion: nil)
        createAlertAction.isEnabled = false
    }
    
    @objc func alertTextFieldDidChange(_ sender: UITextField) {

            guard let senderText = sender.text, alert.actions.indices.contains(1) else {
                return
            }

            let action = alert.actions[1]
            action.isEnabled = senderText.count > 0
        }
    
    @IBAction func onEdit(_ sender: Any) {
        model.removeItem(at: 0)
        self.table.reloadData()
    }
    
    @IBAction func onSort(_ sender: Any) {
        self.azSort = !self.azSort
        model.sort(azSort: self.azSort)
        self.table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.todos.count
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "TableViewCell",
                                                 for: indexPath)
        cell.textLabel?.text = self.model.todos[indexPath.row].name
        return cell
    }
}

