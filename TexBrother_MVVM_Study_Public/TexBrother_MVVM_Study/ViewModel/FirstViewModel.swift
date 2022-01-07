//
//  FirstViewModel.swift
//  TexBrother_MVVM_Study
//
//  Created by hansol on 2021/12/24.
//

import RxSwift
import RxCocoa

// MARK: - FirstViewModel

final class FirstViewModel {
    
    struct Input {
        let buttonClicked: Observable<Int>
        let textFieldString: Observable<String>
    }
    
    struct Output {
        let selectedButton : Driver<ButtonModel?>
        let textCount: Driver<Int?>
    }
}

// MARK: - Extensions

extension FirstViewModel {
//    TODO
    func transform (input : Input) -> Output {
        let temp : [ButtonModel] =
        [
            .init(buttonNumber: 1, buttonInfo: "첫 번째 버튼입니다."),
            .init(buttonNumber: 2, buttonInfo: "두 번째 버튼입니다."),
            .init(buttonNumber: 3, buttonInfo: "세 번째 버튼입니다.")
        ]
        
        let selectedItem = input.buttonClicked
            .map { idx -> ButtonModel in
                let selected = temp.first(where: {$0.buttonNumber == idx})!
                return selected
            }
            .share()
            .asDriver(onErrorJustReturn: nil)
        
        let count = input.textFieldString.map {
            $0.count
        }
        .asDriver(onErrorJustReturn: nil)
        
        return Output(selectedButton: selectedItem, textCount: count)
    }
}
