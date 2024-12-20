//
//  TodoDetailView.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import UIKit

class TodoDetailViewController: UIViewController {
    private var presenter: TodoDetailPresenterViewProtocol!
    private var todo: TodoDetailEntity!
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        title = TodoDetailAssets.Strings.todo.string
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView?.tintColor = TodoDetailAssets.Colors.todoNameFg.color
        
        presenter.viewDidLoad(for: todo.id)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateTodo()
        if todoIsChanged {
            presenter.viewWillDisappear(todo: todo)
        }
        
        super.viewWillDisappear(animated)
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
    
    private lazy var todoNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = TodoDetailAssets.Strings.todoName.string
        textField.font = UIFont.boldSystemFont(ofSize: 34)
        textField.textColor = TodoDetailAssets.Colors.todoNameFg.color
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.addTarget(self, action: #selector(dismissKeyboard), for: .editingDidEndOnExit)
        return textField
    }()
    
    private lazy var todoCreatedOnLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = TodoDetailAssets.Colors.todoCreatedOnFg.color
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var todoDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textColor = TodoDetailAssets.Colors.todoDescriptionFg.color
        textView.textAlignment = .natural
        textView.returnKeyType = .next
        
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = true    
        textView.showsHorizontalScrollIndicator = false
        
        textView.inputAccessoryView = keyboardDoneToolbar
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var keyboardDoneToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: SharedButtonsAssets.Strings.done.string,
            style: .done,
            target: self,
            action: #selector(dismissKeyboard)
        )
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexSpace, doneButton]
        
        return toolbar
    }()
}

// MARK: Configurator
extension TodoDetailViewController: TodoDetailViewConfiguratorProtocol {
    func configure(todoId: Int64?, presenter: TodoDetailPresenterViewProtocol) {
        self.presenter = presenter
        
        if let todoId {
            todo = .getEmpty(for: todoId)
        } else {
            todo = .getNewEmpty()
        }
    }
}


// MARK: Presenter
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
        
        let createdOnText = todoCreatedOnAttributedText(todo.createdOn.todoShortDate)
        todoCreatedOnLabel.attributedText = createdOnText
        
        let descriptionText = todoDescriptionAttributedText(todo.description)
        todoDescriptionTextView.attributedText = descriptionText
    }
    
    private func updateTodo() {
        todo.name = todoNameTextField.text ?? ""
        todo.description = todoDescriptionTextView.text
    }
    
    private var todoIsChanged: Bool {
        todoNameIsChanged || todoDescriptionIsChanged
    }
    
    private var todoNameIsChanged: Bool {
        !(todo.name.isEmpty || todo.name == TodoDetailAssets.Strings.todoName.string)
    }
    
    private var todoDescriptionIsChanged: Bool {
        !(todo.description.isEmpty || todo.description == TodoDetailAssets.Strings.todoDescription.string)
    }
    
    private func todoCreatedOnAttributedText(_ text: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.12

        return NSMutableAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )
    }
    
    private func todoDescriptionAttributedText(_ text: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        
        return NSMutableAttributedString(
            string: !text.isEmpty ? text : TodoDetailAssets.Strings.todoDescription.string,
            attributes: [
                NSAttributedString.Key.kern: -0.43,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular),
                NSAttributedString.Key.foregroundColor: TodoDetailAssets.Colors.todoDescriptionFg.color,
            ]
        )
    }
}


// MARK: UI - Layout
extension TodoDetailViewController {
    private func setupUI() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(todoNameTextField)
        stackView.addArrangedSubview(todoCreatedOnLabel)
        stackView.addArrangedSubview(todoDescriptionTextView)
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
        setupTodoNameTextFieldConstraints()
        setupTodoCreatedOnLabelConstraints()
        setupTodoDescriptionTextViewConstraints()
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
    
    func setupTodoNameTextFieldConstraints() {
        NSLayoutConstraint.activate([
            todoNameTextField.topAnchor.constraint(equalTo: stackView.topAnchor),
            todoNameTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            todoNameTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            todoNameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }
    
    func setupTodoCreatedOnLabelConstraints() {
        NSLayoutConstraint.activate([
            todoCreatedOnLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            todoCreatedOnLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            todoCreatedOnLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }
    
    func setupTodoDescriptionTextViewConstraints() {
        NSLayoutConstraint.activate([
            todoDescriptionTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            todoDescriptionTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            todoDescriptionTextView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }
}


// MARK: - Actions
extension TodoDetailViewController {
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        if !isKeyboardVisible {
            UIView.animate(withDuration: 0.7) { [weak self] in
                guard let self else { return }
                
                view.layoutIfNeeded()
                view.frame.size.height = view.frame.height - keyboardFrame.height
            }
            
            isKeyboardVisible = true
        }
    }
        
    @objc private func keyboardWillHide(notification: NSNotification) {
        if isKeyboardVisible {
            isKeyboardVisible = false
            UIView.animate(withDuration: 0.7) { [weak self] in
                guard let self else { return }
                
                view.layoutIfNeeded()
                view.frame.size.height = UIScreen.main.bounds.height
            }
        }
    }
}
