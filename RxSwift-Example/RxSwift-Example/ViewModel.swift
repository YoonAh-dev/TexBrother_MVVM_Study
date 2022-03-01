//
//  ViewModel.swift
//  RxSwift-Example
//
//  Created by SHIN YOON AH on 2022/03/02.
//

import RxSwift
import RxCocoa
import UIKit

final class ViewModel {
    
    struct Input {
        let buttonClicked: PublishSubject<(String, String)>
    }
    
    struct Output {
        let personResult: Observable<Person>
    }
}

extension ViewModel {
    func transform (input : Input) -> Output {
        let personResult = input.buttonClicked
            .distinctUntilChanged(at: \.1)
            .map { age, name -> Person in
                return Person(name: name, age: Int(age) ?? 0)
            }
        
        return Output(personResult: personResult)
    }
}

