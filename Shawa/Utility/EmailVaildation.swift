//
//  EmailVaildation.swift
//  Shawa
//
//  Created by Alex on 20.05.24.
//

import Foundation

func validateIsEmail(stringToValidate: String) -> Bool {
    let emailDetector = try? NSDataDetector(
      types: NSTextCheckingResult.CheckingType.link.rawValue
    )

    let rangeOfStringToValidate = NSRange(
        stringToValidate.startIndex..<stringToValidate.endIndex,
      in: stringToValidate
    )

    let matches = emailDetector?.matches(
      in: stringToValidate,
      options: [],
      range: rangeOfStringToValidate
    )
    
    guard matches?.count == 1 else { return false }
    let singleMatch = matches?.first

    guard singleMatch?.range == rangeOfStringToValidate else { return false }

    guard singleMatch?.url?.scheme == "mailto" else { return false }

    return true
}

func validateIsPhone(stringToValidate: String) -> Bool {
    let phoneDetector = try? NSDataDetector(
        types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue
    )

    let rangeOfStringToValidate = NSRange(
        stringToValidate.startIndex..<stringToValidate.endIndex,
      in: stringToValidate
    )

    let matches = phoneDetector?.matches(
      in: stringToValidate,
      options: [],
      range: rangeOfStringToValidate
    )
    
    guard matches?.count == 1 else { return false }
    let singleMatch = matches?.first

    guard singleMatch?.range == rangeOfStringToValidate else { return false }

//    guard singleMatch?.url?.scheme == "mailto" else { return false }

    return true
}
