//
//  TableViewCell.swift
//  RxSwift-Example
//
//  Created by SHIN YOON AH on 2022/03/11.
//

import UIKit

final class TableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"
    
    private let nameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func render() {
        contentView.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.addConstraints([
            nameLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func bind(model: String) {
        nameLabel.text = model
    }
}
