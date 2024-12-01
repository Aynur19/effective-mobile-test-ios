//
//  TodoListPresenterProtocols.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 30.11.2024.
//

protocol TodoListPresenterViewProtocol: AnyObject {
    func viewDidLoad()
    
    func didTapIsCompleted(todoId: Int64)
    
    func didTapOnCell(todoId: Int64)
    
    func didEnterSearch(searchText: String)
    
    func didSelectToEdit(todoId: Int64)
    
    func didSelectToShare(todoId: Int64)
    
    func didSelectToDelete(todoId: Int64)
    
    func didTapCreateTodo()
}

protocol TodoListPresenterInteractorProtocol: AnyObject {
    func didFetch(todos: [TodoTableCellEntity])
    
    func didUpdate(todo: TodoTableCellEntity)
    
    func didDelete(todo: TodoTableCellEntity)
}
