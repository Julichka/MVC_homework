//
//  Model.swift
//  TodoListHomework2
//
//  Created by Yuliia Khrupina on 2/27/22.
//

import Foundation

class TodoItem {
    var name: String
    var checked: Bool
    
    init(name: String, checked: Bool) {
        self.name = name
        self.checked = checked
    }
}

class Model {
    var todos = [
        TodoItem(name: "item 1", checked: true),
        TodoItem(name: "item 2", checked: false),
        TodoItem(name: "item 3", checked: false)
    ]
    
    func addItem(name: String, checked: Bool = false) {
        todos.append(TodoItem(name: name, checked: checked))
    }

    func removeItem(at index: Int) {
        todos.remove(at: index)
    }
    
    func update(at index: Int, with name: String) {
        todos[index].name = name
    }
    
    func sort(azSort: Bool) {
        if (azSort) {
            todos = todos.sorted { $0.name < $1.name }
        } else {
            todos = todos.sorted { $0.name > $1.name }
        }
    }
}
