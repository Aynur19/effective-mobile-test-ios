//
//  TaskDetailView.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import UIKit

protocol TaskDetailViewProtocol: AnyObject {
    func showTask(_ task: TaskDetailEntity)
}

class TaskDetailViewController: UIViewController {
    var presenter: TaskDetailPresenterProtocol!
    let configurator: TaskDetailConfiguratorProtocol = TaskDetailConfigurator()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var headerHeightConstraint: NSLayoutConstraint?
    private let maxHeaderHeight: CGFloat = 150
    private let minHeaderHeight: CGFloat = 60

    private var isKeyboardVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setipSubscriptions()
        presenter.viewDidLoad()
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
    private lazy var taskNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = TaskDetailAssets.Strings.taskName.string
        textField.font = UIFont.boldSystemFont(ofSize: 34)
        textField.textColor = TaskDetailAssets.Colors.taskNameFg.color
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
        label.textColor = TaskDetailAssets.Colors.taskCreatedOnFg.color
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
        textView.textColor = TaskDetailAssets.Colors.taskDescriptionFg.color
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
                NSAttributedString.Key.foregroundColor: TaskDetailAssets.Colors.taskDescriptionFg.color,
            ]
        )
    }
}

extension TaskDetailViewController: TaskDetailViewProtocol {
    func showTask(_ task: TaskDetailEntity) {
        taskNameTextField.text = task.name
        
        let createdOnText = taskCreatedOnAttributedText(task.createdOn.taskShortDate)
        taskCreatedOnLabel.attributedText = createdOnText
        
        let descriptionText = taskDescriptionAttributedText(task.taskDescription)
        taskDescriptionTextView.attributedText = descriptionText
    }
}

extension TaskDetailViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = TaskDetailAssets.Strings.task.string
        navigationItem.titleView?.tintColor = TaskDetailAssets.Colors.taskNameFg.color
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(taskNameTextField)
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
            taskNameTextField.topAnchor.constraint(equalTo: stackView.topAnchor),
            taskNameTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            taskNameTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            taskNameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
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
