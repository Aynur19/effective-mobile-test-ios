//
//  TodoTableCellView.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 29.11.2024.
//

import Foundation
import UIKit

class TodoTableCellView: UITableViewCell {
    weak var delegate: TodoTableCellViewDelegate?
    private var todoId: Int64?
    
    private lazy var isCompletedView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleIsCompletedTap))
        imageView.addGestureRecognizer(tapGesture)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createdOnLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = TodoTableCellAssets.Colors.todoCreatedOnFg.color
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        contentView.addSubview(hStackView)
        
        hStackView.addArrangedSubview(isCompletedView)
        hStackView.addArrangedSubview(vStackView)
        
        vStackView.addArrangedSubview(nameLabel)
        vStackView.addArrangedSubview(descriptionLabel)
        vStackView.addArrangedSubview(createdOnLabel)
    }
    
    private func setupConstraints() {
        setupHStackViewConstraints()
        setupIsCompletedImageViewConstraints()
        
        setupVStackViewConstraints()
        setupNameLabelConstraints()
        setupDescriptionLabelConstraints()
        setupCreatedOnLabelConstraints()
    }
    
    private func setupHStackViewConstraints() {
        NSLayoutConstraint.activate([
            hStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            hStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            hStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            hStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
    
    private func setupIsCompletedImageViewConstraints() {
        NSLayoutConstraint.activate([
            isCompletedView.widthAnchor.constraint(equalToConstant: 24),
            isCompletedView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    private func setupVStackViewConstraints() {
        NSLayoutConstraint.activate([
            vStackView.trailingAnchor.constraint(equalTo: hStackView.trailingAnchor),
            vStackView.topAnchor.constraint(equalTo: hStackView.topAnchor),
            vStackView.bottomAnchor.constraint(equalTo: hStackView.bottomAnchor),
        ])
    }
    
    private func setupNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor),
        ])
    }
    
    private func setupDescriptionLabelConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor),
        ])
    }
    
    private func setupCreatedOnLabelConstraints() {
        NSLayoutConstraint.activate([
            createdOnLabel.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor),
        ])
    }

    @objc private func handleIsCompletedTap() {
        guard let todoId = todoId else { return }
        
        delegate?.didTapIsCompleted(for: todoId)
    }
}


extension TodoTableCellView: TodoTableCellViewProtocol {
    func show(todo: TodoTableCellEntity) {
        todoId = todo.id
        configureIsCompletedImageView(todo.isCompleted)
        configureNameLabel(todo.name, isCompleted: todo.isCompleted)
        configureDescriptionLabel(todo.description, isCompleted: todo.isCompleted)
        createdOnLabel.text = todo.createdOn
    }
    
    private func configureIsCompletedImageView(_ isCompleted: Bool) {
        if isCompleted {
            isCompletedView.image = TodoTableCellAssets.Images.todoIsCompleted.image
            isCompletedView.tintColor = TodoTableCellAssets.Colors.todoIsCompletedFg.color
        } else {
            isCompletedView.image = TodoTableCellAssets.Images.todoIsNotCompleted.image
            isCompletedView.tintColor = TodoTableCellAssets.Colors.todoIsNotCompletedFg.color
        }
    }
    
    private func configureNameLabel(_ name: String, isCompleted: Bool) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        
        let strikethroughStyle = isCompleted ? NSUnderlineStyle.single.rawValue : 0
        let foregroundColor = isCompleted
        ? TodoTableCellAssets.Colors.todoIsCompletedLabelsFg.color
        : TodoTableCellAssets.Colors.todoIsNotCompletedLabelsFg.color
        
        nameLabel.attributedText = NSMutableAttributedString(
            string: name,
            attributes: [
                NSAttributedString.Key.strikethroughStyle: strikethroughStyle,
                NSAttributedString.Key.kern: -0.43,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: foregroundColor,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
            ]
        )
    }
    
    private func configureDescriptionLabel(_ description: String, isCompleted: Bool) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.12
        
        let foregroundColor = isCompleted
        ? TodoTableCellAssets.Colors.todoIsCompletedLabelsFg.color
        : TodoTableCellAssets.Colors.todoIsNotCompletedLabelsFg.color
        
        descriptionLabel.attributedText = NSMutableAttributedString(
            string: description,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: foregroundColor,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)
            ]
        )
    }
}
