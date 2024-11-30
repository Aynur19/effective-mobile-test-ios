//
//  TodoListView.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 29.11.2024.
//

import Foundation
import UIKit

class TodoListViewController: UIViewController {
    var presenter: TodoListPresenterViewProtocol!
    let configurator: TodoListConfiguratorProtocol = TodoListConfigurator()
    
    private let tableView = UITableView()
    private var todos = [TodoTableCellEntity]()
    private let tableCellId = "TodoTableCellView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        title = "Todos"
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoTableCellView.self, forCellReuseIdentifier: tableCellId)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
    }
}

extension TodoListViewController: TodoListViewProtocol {
    func show(todos: [TodoTableCellEntity]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.todos = todos
            tableView.reloadData()
        }
    }
    
    func update(todo: TodoTableCellEntity) {
        guard let idx = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        todos[idx] = todo
        
        let indexPath = IndexPath(row: idx, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}


extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellId, for: indexPath) as! TodoTableCellView
        
        let todo = todos[indexPath.row]
        cell.show(todo: todo)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        presenter?.didSelectTodo(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TodoListViewController: TodoTableCellViewDelegate {
    func didTapIsCompleted(for todoId: Int64) {
        presenter.didTapIsCompleted(todoId: todoId)
    }
}
