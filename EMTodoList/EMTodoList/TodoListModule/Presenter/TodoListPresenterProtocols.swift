//
//  TodoListPresenterProtocols.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 30.11.2024.
//

protocol TodoListPresenterViewProtocol: AnyObject {
    func viewDidLoad()
    
    func didTapIsCompleted(todoId: Int64)
    
    func didEnterSearch(searchText: String)
    
    func didSelectTodo(todoId: Int64)
}

protocol TodoListPresenterInteractorProtocol: AnyObject {
    func didFetch(todos: [TodoTableCellEntity])
    
    func didUpdated(todo: TodoTableCellEntity)
}
