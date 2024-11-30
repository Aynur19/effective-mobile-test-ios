//
//  TodoDetailPresenter.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 28.11.2024.
//

import Foundation

protocol TodoDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    func didFetchTask(_ task: TodoDetailEntity)
}

class TodoDetailPresenter: TodoDetailPresenterProtocol {
    weak var view: TodoDetailViewProtocol?
    var interactor: TodoDetailInteractorProtocol!
    var router: TodoDetailRouterProtocol!
    
    required init(view: TodoDetailViewProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        interactor.fetchTask()
    }

    func didFetchTask(_ task: TodoDetailEntity) {
        view?.showTask(task)
    }
}
