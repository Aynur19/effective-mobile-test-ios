//
//  TodoDetailView.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import UIKit

class TodoDetailViewController: UIViewController {
    private var presenter: TodoDetailPresenterViewProtocol!
    private var todoId: Int64!
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let maxHeaderHeight: CGFloat = 150
    private let minHeaderHeight: CGFloat = 60

    private var isKeyboardVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setipSubscriptions()
        presenter.viewDidLoad(for: todoId)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .firstBaseline
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Task Name
    private lazy var todoNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = TodoDetailAssets.Strings.todoName.string
        textField.font = UIFont.boldSystemFont(ofSize: 34)
        textField.textColor = TodoDetailAssets.Colors.todoNameFg.color
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: Task Created On
    private lazy var taskCreatedOnLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = TodoDetailAssets.Colors.todoCreatedOnFg.color
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func taskCreatedOnAttributedText(_ text: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.12

        return NSMutableAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )
    }
    
    // MARK: Task Description
    private lazy var taskDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textColor = TodoDetailAssets.Colors.todoDescriptionFg.color
        textView.textAlignment = .natural
        textView.returnKeyType = .done
        
        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = true
        textView.showsVerticalScrollIndicator = true    
        textView.showsHorizontalScrollIndicator = false
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private func taskDescriptionAttributedText(_ text: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        
        return NSMutableAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.kern: -0.43,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular),
                NSAttributedString.Key.foregroundColor: TodoDetailAssets.Colors.todoDescriptionFg.color,
            ]
        )
    }
}

extension TodoDetailViewController: TodoDetailViewConfiguratorProtocol {
    func configure(todoId: Int64?, presenter: TodoDetailPresenterViewProtocol) {
        self.presenter = presenter
        self.todoId = todoId ?? 0
    }
}


extension TodoDetailViewController: TodoDetailViewPresenterProtocol {
    func show(todo: TodoDetailEntity?) {
        guard let todo else {
            let alertController = UIAlertController(
                title: NotificationsAssets.Strings.titleError.string,
                message: NotificationsAssets.Strings.messageNotFetchTodoByIdError.string,
                preferredStyle: .alert
            )
            
            alertController.addAction(.init(title: "OK", style: .default))
            
            return present(alertController, animated: true)
        }
        
        todoNameTextField.text = todo.name
        
        let createdOnText = taskCreatedOnAttributedText(todo.createdOn.todoShortDate)
        taskCreatedOnLabel.attributedText = createdOnText
        
        let descriptionText = taskDescriptionAttributedText(todo.description)
        taskDescriptionTextView.attributedText = descriptionText
    }
}

extension TodoDetailViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = TodoDetailAssets.Strings.todo.string
        navigationItem.titleView?.tintColor = TodoDetailAssets.Colors.todoNameFg.color
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(todoNameTextField)
        stackView.addArrangedSubview(taskCreatedOnLabel)
        stackView.addArrangedSubview(taskDescriptionTextView)
    }
    
    private func setipSubscriptions() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        setupStackViewConstraints()
        setupTaskNameTextFieldConstraints()
        setupTaskCreatedOnLabelConstraints()
        setupTaskDescriptionTextViewConstraints()
    }
    
    func setupStackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -40),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupTaskNameTextFieldConstraints() {
        NSLayoutConstraint.activate([
            todoNameTextField.topAnchor.constraint(equalTo: stackView.topAnchor),
            todoNameTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            todoNameTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            todoNameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }
    
    func setupTaskCreatedOnLabelConstraints() {
        NSLayoutConstraint.activate([
            taskCreatedOnLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            taskCreatedOnLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            taskCreatedOnLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }
    
    func setupTaskDescriptionTextViewConstraints() {
        NSLayoutConstraint.activate([
            taskDescriptionTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            taskDescriptionTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            taskDescriptionTextView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }
    
    // MARK: - Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        if !isKeyboardVisible {
            UIView.animate(withDuration: 0.7) {
                self.view.layoutIfNeeded()
                self.stackView.setCustomSpacing(30, after: self.taskDescriptionTextView)
                self.view.frame.size.height = self.view.frame.height - keyboardFrame.height
            }
            
            isKeyboardVisible = true
        }
    }
        
    @objc private func keyboardWillHide(notification: NSNotification) {
        if isKeyboardVisible {
            UIView.animate(withDuration: 0.7) {
                self.view.layoutIfNeeded()
                self.stackView.setCustomSpacing(10, after: self.taskDescriptionTextView)
                self.view.frame.size.height = UIScreen.main.bounds.height
            }
            isKeyboardVisible = false
        }
    }
}
