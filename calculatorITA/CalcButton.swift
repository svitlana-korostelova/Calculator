//
//  CalcButton.swift
//  calculatorITA
//
//  Created by Svitlana Korostelova on 17.09.2020.
//  Copyright © 2020 Svitlana Korostelova. All rights reserved.
//

import UIKit

enum CalcButtonValue: Int {
    case plus = 10, minus, multiply, divizion, equal, clear, reverseSignForNum, dot, percentage, squareRoot, modulo, xSquared, xCubed, sinus, cosine, tangent
    
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
