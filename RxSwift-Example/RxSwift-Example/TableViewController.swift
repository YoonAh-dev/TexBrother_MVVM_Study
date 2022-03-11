//
//  TableViewController.swift
//  RxSwift-Example
//
//  Created by SHIN YOON AH on 2022/03/11.
//

import UIKit

import RxCocoa
import RxSwift

final class TableViewController: UITableViewController {
    
    // MARK: - properties
    
    private let disposeBag = DisposeBag()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름을 입력해주세요"
        return textField
    }()
    private let viewModel = TableViewModel()
    private var sections: [Person] = []
    let cities = Observable.of(["Lisbon", "Copenhagen", "London", "Madrid", "Vienna"])
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        bind()
    }
    
    // MARK: - func
    
    private func configUI() {
        tableView.delegate = nil
        tableView.rowHeight = 30
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
    }
    
    private func bind() {
        let input = TableViewModel.Input(
            newContent: textField.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        cities
            .bind(to: tableView.rx.items(
                cellIdentifier: TableViewCell.identifier,
                cellType: TableViewCell.self)
            ) { row, data, cell in
                cell.bind(model: data)
            }
            .disposed(by: disposeBag)
    }

}
