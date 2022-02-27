//
//  ViewController.swift
//  TodoListHomework2
//
//  Created by Yuliia Khrupina on 2/26/22.
//

import UIKit

class Cell: UITableViewCell {
    
    var delegate: CellDelegate?
    
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var delete: UIButton!
    
    @IBOutlet weak var edit: UIButton!
    
    
    @IBOutlet weak var check: UIButton!
    
    @IBAction func onDelete(_ sender: Any) {
        delegate?.deleteCell(cell: self)
    }
    
}

protocol CellDelegate {
    func editCell(cell: Cell)
    func deleteCell(cell: Cell)
}

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var sort: UIButton!
    
    var dialog = UIAlertController()
    
    var model: Model = Model()
    
    var azSort: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        table.dataSource = self
    }
    
    @IBAction func onAddClicked(_ sender: Any) {
        dialog = UIAlertController(title: "Create new task", message: nil, preferredStyle: .alert)
        
        dialog.addTextField { (textField: UITextField) in
            textField.placeholder = "Task name"
            textField.addTarget(self, action: #selector(self.textChangeListener(_:)), for: .editingChanged)
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (createAlert) in
            // add new task
            
            guard let unwrTextFieldValue = self.dialog.textFields?[0].text else {
                return
            }
            
            self.model.addItem(name: unwrTextFieldValue)
            self.model.sort(azSort: self.azSort)
            self.table.reloadData()
            
            
        }
        
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)

        dialog.addAction(closeAction)
        dialog.addAction(addAction)
        present(dialog, animated: true, completion: nil)
        addAction.isEnabled = false
    }
    
    @objc func textChangeListener(_ sender: UITextField) {

            guard let senderText = sender.text, dialog.actions.indices.contains(1) else {
                return
            }

            let action = dialog.actions[1]
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.model.todos[indexPath.row].checked = !self.model.todos[indexPath.row].checked
        self.table.reloadData()
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! Cell
        
        cell.delegate = self
        
        cell.name?.text = self.model.todos[indexPath.row].name
        cell.check?.isHidden = !self.model.todos[indexPath.row].checked
        return cell
    
    }
}

extension ViewController: CellDelegate {
    
    // MARK: - Cell Protocol Stubs
    
    
    func editCell(cell: Cell) {
        
        
        
    }
    
    func deleteCell(cell: Cell) {
        
        let indexPath = table.indexPath(for: cell)
        
        guard let unwrIndexPath = indexPath else {
            return
        }
        
        model.removeItem(at: unwrIndexPath.row)
        table.reloadData()
    }

}
