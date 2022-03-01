//
//  ViewController.swift
//  RxSwift-Example
//
//  Created by SHIN YOON AH on 2022/02/23.
//

import UIKit

import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameBackgroundView: UIView!
    
    private let viewModel = ViewModel()
    private let didTapSaveButton = PublishSubject<(String, String)>()
    private let ageTextFieldSubject = BehaviorSubject<Bool>(value: false)
    private let nameTextFieldSubject = BehaviorSubject<Bool>(value: false)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let input = ViewModel.Input(
            buttonClicked: didTapSaveButton
        )
        let output = viewModel.transform(input: input)
        
        output.personResult
            .bind { [weak self] person in
                self?.nameLabel.text = person.name
                self?.nameBackgroundView.backgroundColor = self?.getRandomColor()
            }
            .disposed(by: disposeBag)
        
        saveButton.rx.tap.asDriver()
            .throttle(.seconds(5), latest: false)
            .drive(onNext: { [weak self] in
                guard
                    let ageText = self?.ageTextField.text,
                    let nameText = self?.nameTextField.text
                else { return }
                self?.didTapSaveButton.onNext((ageText, nameText))
            })
            .disposed(by: disposeBag)
        
        ageTextField.rx.text.orEmpty
            .bind(onNext: { [weak self] in
                self?.ageTextFieldSubject.onNext(($0 == "") ? false : true)
            })
            .disposed(by: disposeBag)
        
        nameTextField.rx.text.orEmpty
            .bind(onNext: { [weak self] in
                self?.nameTextFieldSubject.onNext(($0 == "") ? false : true)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(ageTextFieldSubject, nameTextFieldSubject) { $0 && $1 }
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func distinctNumberArr() {
        Observable.of(1, 1, 2, 3, 4, 4, 2, 2, 3, 5)
            .distinctUntilChanged()
            .subscribe(onNext: { event in
                print(event)
            })
            .disposed(by: disposeBag)
    }
    
    private func getRandomColor() -> UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
