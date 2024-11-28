//
//  TaskConfigurator.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 28.11.2024.
//

import Foundation

protocol TaskDetailConfiguratorProtocol: AnyObject {
    func configure(with viewController: TaskDetailViewController)
}

class TaskDetailConfigurator: TaskDetailConfiguratorProtocol {
    func configure(with viewController: TaskDetailViewController) {
        let presenter = TaskDetailPresenter(view: viewController)
        let interactor = TaskDetailInteractor(presenter: presenter)
        let router = TaskDetailRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
