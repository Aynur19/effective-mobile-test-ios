//
//  TodoListViewProtocols.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 30.11.2024.
//

protocol TodoTableCellViewDelegate: AnyObject {
    func didTapIsCompleted(for todoId: Int64)
}


protocol TodoTableCellViewProtocol {
    func show(todo: TodoTableCellEntity, searchText: String)
}


protocol TodoListViewProtocol: AnyObject {
    func reload()
    
    func show(todos: [TodoTableCellEntity])
    
    func update(todo: TodoTableCellEntity)
    
    func delete(todo: TodoTableCellEntity)
}
