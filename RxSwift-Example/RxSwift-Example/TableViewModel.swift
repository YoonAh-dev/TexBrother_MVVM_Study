//
//  TableViewModel.swift
//  RxSwift-Example
//
//  Created by SHIN YOON AH on 2022/03/11.
//

import RxSwift
import RxCocoa
import UIKit

final class TableViewModel {
    
    struct Input {
        let newContent: Observable<String>
    }
    
    struct Output {
        let tableViewItems: Observable<[Person]>
    }
    
    struct State {
        var currentItems = BehaviorSubject<[Person]>(value: [])
    }
    
    var state = State()
    var stateArray: [Person] = []
}

extension TableViewModel {
    func transform (input : Input) -> Output {
        let personResult = input.newContent
            .distinctUntilChanged()
            .map { name -> [Person] in
                let newPerson = Person(name: name, age: 25)
                self.stateArray.append(newPerson)
                self.state.currentItems.onNext(self.stateArray)
                return try self.state.currentItems.value()
            }
        
        return Output(tableViewItems: personResult)
    }
}


