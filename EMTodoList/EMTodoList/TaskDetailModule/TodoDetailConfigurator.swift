//
//  TodoDetailConfigurator.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 28.11.2024.
//

import Foundation

protocol TodoDetailConfiguratorProtocol: AnyObject {
    func configure(with viewController: TodoDetailViewController)
}

class TodoDetailConfigurator: TodoDetailConfiguratorProtocol {
    func configure(with viewController: TodoDetailViewController) {
        let presenter = TodoDetailPresenter(view: viewController)
        let interactor = TodoDetailInteractor(presenter: presenter)
        let router = TodoDetailRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
