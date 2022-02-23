//
//  ViewController.swift
//  RxSwift-Example
//
//  Created by SHIN YOON AH on 2022/02/23.
//

import UIKit

import RxSwift

final class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        distinctNumberArr()
    }
    
    private func distinctNumberArr() {
        Observable.of(1, 1, 2, 3, 4, 4, 2, 2, 3, 5)
            .distinctUntilChanged()
            .subscribe(onNext: { event in
                print(event)
            })
            .disposed(by: disposeBag)
    }
}
