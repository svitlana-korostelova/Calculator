//
//  CalcButton.swift
//  calculatorITA
//
//  Created by Svitlana Korostelova on 17.09.2020.
//  Copyright © 2020 Svitlana Korostelova. All rights reserved.
//

import UIKit

enum CalcButtonValue: Int {
    case plus = 10, minus, multiply
    case divizion = 13
    case equal = 14
    case clear = 15
    case reverseSignForNum = 16
    case dot = 17
    case percentage = 18
    case squareRoot = 19
    case modulo = 20
    case xSquared = 21
    case xCubed = 22
    case sinus = 23
    case cosine = 24
    case tangent = 25
    
    fileprivate static var latestId = 25
    
    var getOperationSign: String {
        switch self {
        case .plus: return "+"
        case .minus: return "-"
        case .multiply: return "×"
        case .divizion: return "÷"
        case .modulo: return "mod"
        default:
            return ""
        }
    }
}

@IBDesignable class CalcButton: UIButton {
    @IBInspectable var id: Int = 0
    
    func setNewId() {
        CalcButtonValue.latestId += 1
        id = CalcButtonValue.latestId
    }
}
