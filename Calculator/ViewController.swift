//
//  ViewController.swift
//  calculatorITA
//
//  Created by Svitlana Korostelova on 09.09.2020.
//  Copyright © 2020 Svitlana Korostelova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let programmerButton = CalcButton()
    var isAddSectionHidden = true // признак скрывать кнопки, которым он задан или нет
    var stillTyping = false
    var firstOperand: Double = 0
    var secondOperand: Double = 0
    var operationSign = ""
    var dotIsPlaced = false
    var currentInput: Double {
        get{
            return Double(displayResultLabel.text!) ?? 0.0
            // unwrap if couldn't cast to double not numerical text like "error"
        }
        set{
            let value = "\(newValue)"
            let valueArray = value.components(separatedBy: ".")
            if valueArray[1] == "0" {
                displayResultLabel.text = "\(valueArray[0])"
            }else{
                displayResultLabel.text = "\(newValue)"
            }
            stillTyping = false
        }
    }
    @IBOutlet weak var displayResultLabel: UILabel!
    @IBOutlet weak var mod: UIButton!
    @IBOutlet weak var squareRoot: UIButton!
    @IBOutlet weak var equal: UIButton!
    @IBOutlet weak var programmerStackView: UIStackView!
    @IBOutlet weak var textActionsLabel: UILabel!
    @IBOutlet weak var equalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        programmerButton.setNewId()
        programmerButton.addTarget(self, action: #selector(hideFewButtons(_:)), for: .touchUpInside)
        programmerButton.isOpaque = false
        programmerButton.backgroundColor = UIColor(named: "dark")
        programmerStackView.addArrangedSubview(programmerButton)
        setupUI()
        programmerButton.setTitleColor(UIColor(named: "tint"), for: .normal)
        programmerButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onOrientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func hideFewButtons(_ sender: UIButton) {
        isAddSectionHidden = !isAddSectionHidden
        setupUI()
    }
    
    fileprivate func setupUI() {
        if isAddSectionHidden {
            programmerButton.setTitle("︽", for: .normal)
        } else {
            programmerButton.setTitle("︾", for: .normal)
            //            programmerButton.contentVerticalAlignment = .bottom
        }
        mod.isHidden = isAddSectionHidden
        squareRoot.isHidden = isAddSectionHidden
    }
    
    @objc private func onOrientationChanged() {
        // констрейнту выставляем только при повороте экрана
        let buttonHeight: CGFloat = 0.4 * (mainStackView.frame.height - 3 * 3) + 2
        equalHeightConstraint.constant = buttonHeight
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let number = sender.currentTitle!
        
        if stillTyping, displayResultLabel.text != "0" {
            if displayResultLabel.text!.count < 20 {
                displayResultLabel.text = displayResultLabel.text! + number
            }
        }else{
            displayResultLabel.text = number
            stillTyping = true
        }
    }
    
    
    @IBAction func twoOperandsSignPressed(_ sender: CalcButton) {
        firstOperand = currentInput
        stillTyping = false
        dotIsPlaced = false
        guard let getButtonValue = CalcButtonValue(rawValue: sender.id) else {return}
        operationSign = getButtonValue.getOperationSign
//         operationSign = getButtonValue //CalcButtonValue
        textActionsLabel.text! += operationSign
    }
    
    @IBAction func equalitySignPressed(_ sender: UIButton) {
        if stillTyping {
            secondOperand = currentInput
            // the same as func dropUnusedZero below, but concat as +=
            let ifResultBecameDouble = displayResultLabel.text!.contains(".")
            if dotIsPlaced || ifResultBecameDouble {
                textActionsLabel.text! += String(currentInput)
            }else {
                textActionsLabel.text! += String(Int(currentInput))
            }
        }
        switch operationSign {
        case "+":
//        case .plus:
            operateWithTwoOperands(operation: { first, second in
                return first + second
            })
        case "-": operateWithTwoOperands{$0-$1}
        case "×": operateWithTwoOperands{$0*$1}
        case "÷":
            if secondOperand == 0{
                displayResultLabel.text = "ERROR"
            }else{
                operateWithTwoOperands{$0/$1}
            }
        case "mod":
            currentInput = firstOperand.truncatingRemainder(dividingBy: secondOperand)
            stillTyping = false
        default: break
            
        }
        dotIsPlaced = false
        
        // second label requires additional improvements
        if !operationSign.isEmpty
            && !textActionsLabel.text!.isEmpty
            && sender.titleLabel!.text != "=" {
            dropUnusedZeroForInfoLabel()
        }
    }
    
    func operateWithTwoOperands (operation: (Double, Double) -> Double) {
        currentInput = operation(firstOperand, secondOperand)
        stillTyping = false
    }
    
    fileprivate func dropUnusedZeroForInfoLabel() {
        let ifResultBecameDouble = displayResultLabel.text!.contains(".")
        if dotIsPlaced || ifResultBecameDouble {
            textActionsLabel.text! = String(currentInput)
        }else {
            textActionsLabel.text! = String(Int(currentInput))
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        firstOperand = 0
        secondOperand = 0
        currentInput = 0
        dotIsPlaced = false
        displayResultLabel.text = "0"
        operationSign = ""
        textActionsLabel.text = ""
        //        stillTyping = false test once more
    }
    
    @IBAction func plusMinusButtonPressed(_ sender: UIButton) {
        currentInput = -currentInput
        stillTyping = true
    }
    
    @IBAction func persentageButtonPressed(_ sender: UIButton) {
        // the same as func dropUnusedZeroForInfoLabel below, but concat as +=
        let ifResultBecameDouble = displayResultLabel.text!.contains(".")
        if dotIsPlaced || ifResultBecameDouble {
            textActionsLabel.text! += String(currentInput)
        }else {
            textActionsLabel.text! += String(Int(currentInput))
            
        }
        if firstOperand == 0 {
            currentInput = currentInput / 100
        }else{
            currentInput = firstOperand * currentInput / 100
        }
        stillTyping = false
        textActionsLabel.text! += "%"
    }
    
    @IBAction func dotButtonPressed(_ sender: UIButton) {
        if stillTyping, !dotIsPlaced{
            displayResultLabel.text = displayResultLabel.text! + "."
            dotIsPlaced = true
        }else if !stillTyping, !dotIsPlaced{
            displayResultLabel.text = "0."
            stillTyping = true
            dotIsPlaced=true
        }
    }
    
    @IBAction func squareRootButtonPressed(_ sender: UIButton) {
        if currentInput >= 0{
            currentInput = sqrt(currentInput)
        }else{
            displayResultLabel.text = "ERROR"
        }
        dropUnusedZeroForInfoLabel()
    }
    
    @IBAction func xСubed(_ sender: UIButton) {
        currentInput = pow(currentInput, 3)
        dropUnusedZeroForInfoLabel()
    }
    
    @IBAction func xPowerOfTwo(_ sender: UIButton) {
        currentInput *= currentInput
        dropUnusedZeroForInfoLabel()
    }
    
    @IBAction func sinus(_ sender: UIButton) {
        currentInput = sin(currentInput * .pi / 180)
        dropUnusedZeroForInfoLabel()
    }
    
    @IBAction func cosine(_ sender: UIButton) {
        currentInput = cos(currentInput * .pi / 180)
        dropUnusedZeroForInfoLabel()
    }
    
    @IBAction func tangent(_ sender: UIButton) {
        currentInput = tan(currentInput * .pi / 180)
        dropUnusedZeroForInfoLabel()
    }
}

