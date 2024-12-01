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
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var todos = [TodoTableCellEntity]()
    private let tableCellId = "TodoTableCellView"
    private var searchText = ""
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        let spacer = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let createTodoButton = UIBarButtonItem(
            image: TodoListAssets.Images.createToolbarBtn.image,
            style: .plain,
            target: self,
            action: #selector(didTapCreateTodo)
        )
        
        let todoCountLabel = UIBarButtonItem(customView: todoCountLabel)
        
        toolbar.setItems([spacer, todoCountLabel, spacer, createTodoButton], animated: false)
        return toolbar
    }()
    
    private lazy var todoCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        setupUI()
        setupSearchController()
        setupTableViewConstraints()
        setupBottomBarConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        title = TodoListAssets.Strings.viewTitle.string
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        if todos.isEmpty {
            presenter.viewDidLoad()
        }
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(toolBar)
        
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

    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: toolBar.topAnchor),
        ])
    }
    
    private func setupBottomBarConstraints() {
        NSLayoutConstraint.activate([
            toolBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func didTapCreateTodo() {
        presenter.didTapCreateTodo()
    }
    
    private func updateTodosCount() {
        if let label = toolBar.items?[1].customView as? UILabel {
            label.text = String(
                format: TodoListAssets.Strings.tasksCount.string,
                todos.count
            )
            label.sizeToFit()
        }
    }
}

extension TodoListViewController: TodoListViewProtocol {
    func reload() {
        guard searchText.isEmpty else {
            return presenter.didEnterSearch(searchText: searchText)
        }
        
        presenter.viewDidLoad()
    }
    
    func show(todos: [TodoTableCellEntity]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.todos = todos
            tableView.reloadData()
            updateTodosCount()
        }
    }
    
    func update(todo: TodoTableCellEntity) {
        guard let idx = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        todos[idx] = todo
        
        let indexPath = IndexPath(row: idx, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            self?.updateTodosCount()
        }
    }
    
    func delete(todo: TodoTableCellEntity) {
        guard let idx = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        let indexPath = IndexPath(row: idx, section: 0)
        
        DispatchQueue.main.async { [weak self] in
            self?.todos.remove(at: idx)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            self?.updateTodosCount()
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
        presenter.didTapOnCell(todoId: todoId)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let selectedTodo = todos[indexPath.row]
        
        return UIContextMenuConfiguration(
            identifier: indexPath as NSIndexPath,
            previewProvider: nil
        ) { [weak self] _ in
            return self?.getContextMenu(todoId: selectedTodo.id)
        }
    }
    
    private func getContextMenu(todoId: Int64) -> UIMenu {
        UIMenu(
            children: [
                getTodoEditAction(todoId: todoId),
                getTodoShareAction(todoId: todoId),
                getTodoDeleteAction(todoId: todoId)
            ]
        )
    }
    
    private func getTodoEditAction(todoId: Int64) -> UIAction {
        .init(
            title: ContextMenuAssets.Strings.editAction.string,
            image: ContextMenuAssets.Images.editAction.image
        ) { [weak self] _ in
            self?.presenter.didSelectToEdit(todoId: todoId)
        }
    }
    
    private func getTodoShareAction(todoId: Int64) -> UIAction {
        .init(
            title: ContextMenuAssets.Strings.shareAction.string,
            image: ContextMenuAssets.Images.shareAction.image
        ) { [weak self] _ in
            self?.presenter.didSelectToShare(todoId: todoId)
        }
    }
    
    private func getTodoDeleteAction(todoId: Int64) -> UIAction {
        .init(
            title: ContextMenuAssets.Strings.deleteAction.string,
            image: ContextMenuAssets.Images.deleteAction.image,
            attributes: .destructive
        ) { [weak self] _ in
            self?.presenter.didSelectToDelete(todoId: todoId)
        }
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
