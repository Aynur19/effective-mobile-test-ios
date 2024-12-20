//
//  TodoDetailConfigurator.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 28.11.2024.
//

class TodoDetailConfigurator: TodoDetailConfiguratorProtocol {
    static func createModule(
        for todoId: Int64? = nil,
        delegate: TodoDetailModuleDelegate
    ) -> TodoDetailViewController {
        let viewController = TodoDetailViewController()
        let presenter = TodoDetailPresenter(view: viewController, delegate: delegate)
        let interactor = TodoDetailInteractor(presenter: presenter, isNewTodo: todoId == nil)
        let router = TodoDetailRouter(viewController: viewController)
        
        viewController.configure(todoId: todoId, presenter: presenter)
        presenter.configure(interactor: interactor, router: router)
        
        return viewController
    }
}
