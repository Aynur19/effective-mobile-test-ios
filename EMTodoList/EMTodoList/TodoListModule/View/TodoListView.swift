//
//  TodoListView.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 29.11.2024.
//

import Foundation
import UIKit
import EMCore

class TodoListViewController: UIViewController {
    var presenter: (TodoListPresenterViewProtocol & TodoDetailModuleDelegate)!
    let configurator: TodoListConfiguratorProtocol = TodoListConfigurator()
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var todos = [TodoTableCellEntity]()
    private let tableCellId = "TodoTableCellView"
    private var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        setupUI()
        setupSearchController()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        title = TodoListAssets.Strings.viewTitle.string
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoTableCellView.self, forCellReuseIdentifier: tableCellId)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = TodoListAssets.Strings.searchPlaceholder.string
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
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
    
    func delete(todo: TodoTableCellEntity) {
        guard let idx = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        let indexPath = IndexPath(row: idx, section: 0)
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


extension TodoListViewController: TodoTableCellViewDelegate {
    func didTapIsCompleted(for todoId: Int64) {
        presenter.didTapIsCompleted(todoId: todoId)
    }
}


extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellId, for: indexPath) as! TodoTableCellView
        
        let todo = todos[indexPath.row]
        cell.show(todo: todo, searchText: searchText)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todoId = todos[indexPath.row].id
        presenter.didSelectTodo(todoId: todoId)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension TodoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        print("Поиск по строке: '\(searchText)'")
        self.searchText = searchText
        presenter.didEnterSearch(searchText: searchText)
    }
}
