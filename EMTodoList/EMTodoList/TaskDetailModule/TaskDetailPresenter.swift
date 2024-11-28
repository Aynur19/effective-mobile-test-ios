//
//  TaskDetailPresenter.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 28.11.2024.
//

import Foundation

protocol TaskDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    func didFetchTask(_ task: TaskDetailEntity)
}

class TaskDetailPresenter: TaskDetailPresenterProtocol {
    weak var view: TaskDetailViewProtocol?
    var interactor: TaskDetailInteractorProtocol!
    var router: TaskDetailRouterProtocol!
    
    required init(view: TaskDetailViewProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        interactor.fetchTask()
    }

    func didFetchTask(_ task: TaskDetailEntity) {
        view?.showTask(task)
    }
}
