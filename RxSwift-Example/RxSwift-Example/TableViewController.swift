//
//  TableViewController.swift
//  RxSwift-Example
//
//  Created by SHIN YOON AH on 2022/03/11.
//

import UIKit

import RxCocoa
import RxSwift

final class TableViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - properties
    
    private let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 30
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름을 입력해주세요"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    private let viewModel = TableViewModel()
    private var textfieldSubject = BehaviorSubject<String>(value: "")
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        bind()
        bindInput()
    }
    
    // MARK: - func
    
    private func render() {
        view.addSubview(tableView)
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -300),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func bind() {
        let input = TableViewModel.Input(
            newContent: textfieldSubject
        )
        
        let output = viewModel.transform(input: input)
        output.tableViewItems
            .bind(to: tableView.rx.items(
                cellIdentifier: TableViewCell.identifier,
                cellType: TableViewCell.self)
            ) { row, data, cell in
                cell.bind(model: data)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindInput() {
        textField.rx.controlEvent(.editingDidEndOnExit).asDriver()
            .drive(onNext: { [weak self] in
                if let text = self?.textField.text {
                    self?.textfieldSubject.onNext(text)
                }
            })
            .disposed(by: disposeBag)
    }
}
