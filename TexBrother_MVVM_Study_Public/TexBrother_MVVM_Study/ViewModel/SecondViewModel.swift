//
//  SecondViewModel.swift
//  TexBrother_MVVM_Study
//
//  Created by 노한솔 on 2022/02/01.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - SecondViewModel

final class SecondViewModel {
    struct Input {
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let nickNameText: Observable<String>
        let registerBtnClicked: Observable<Void>
        let privacyAgree: Observable<Bool>
        let promotionAgree: Observable<Bool>
    }
    struct Output {
        let registerResult: Observable<RegisterModel>
        let registerEnabled: Observable<Bool>
    }
}
extension SecondViewModel {
    
    func transform (input: Input) -> Output {
        let registerModel = Observable.combineLatest(input.emailText,
                                                     input.passwordText,
                                                     input.nickNameText,
                                                     input.privacyAgree,
                                                     input.promotionAgree)
            .map {email, password, nickname, privacy, promotion -> RegisterModel in
                let temp = RegisterModel(email: email,
                                         passWord: password,
                                         nickName: nickname,
                                         privacy: privacy,
                                         promotion: promotion)
                return temp
            }

        let enabled = Observable.combineLatest(input.emailText,
                                               input.passwordText,
                                               input.nickNameText,
                                               input.privacyAgree,
                                               input.promotionAgree)
            .map { email, password, nickname, privacy, promotion -> Bool in
                let emailPattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}$"
                let passwordPattern = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}"
                let emailRegex = try? NSRegularExpression(pattern: emailPattern)
                let passwordRegex = try? NSRegularExpression(pattern: passwordPattern)
                
                if let _ = emailRegex?.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)),
                   let _ = passwordRegex?.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.count)) {
                    if nickname.count > 1, privacy {
                        return true
                    }
                }
                
                return false
            }
        
        let register = Observable.combineLatest(registerModel, enabled)
            .map { model, enable -> RegisterModel in
                
                if enable {
                    return model
                }
                
                return RegisterModel(email: "", passWord: "", nickName: "", privacy: false, promotion: false)
            }
        
        return .init(registerResult: register, registerEnabled: enabled)
        
    }
}
