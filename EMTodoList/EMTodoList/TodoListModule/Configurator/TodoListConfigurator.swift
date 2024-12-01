//
//  TodoListConfigurator.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 29.11.2024.
//

class TodoListConfigurator: TodoListConfiguratorProtocol {
    static func createModule(with todo: TodoListEntity) {
        let viewController = TodoListViewController()
    }
    
    func configure(with viewController: TodoListViewController) {
        let presenter = TodoListPresenter(view: viewController)
        let interactor = TodoListInteractor(presenter: presenter)
        let router = TodoListRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
