//
//  RegisterModel.swift
//  TexBrother_MVVM_Study
//
//  Created by 노한솔 on 2022/02/01.
//

import Foundation

// MARK: - RegisterModel

struct RegisterModel {
  let email: String
  let passWord: String
  let nickName: String
  let privacy: Bool
  let promotion: Bool
}

// TODO - Regex

enum ValidationRegex: String {
  case email = "TODO"
  case password = "TODO2"
  case nickname = "TODO3"
}

extension String {
  func validate(with regex: String) -> Bool {
    return NSPredicate(format: "SELF MATCHES %@" , regex.trimmingCharacters(in: .whitespaces)).evaluate(with: self)
  }

  func validate(with regex: ValidationRegex) -> Bool {
    return validate(with: regex.rawValue)
  }
}
