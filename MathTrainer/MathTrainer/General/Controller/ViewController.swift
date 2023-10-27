//
//  ViewController.swift
//  MathTrainer
//
//  Created by Sviatoslav Samoilov on 11.07.2023.
//

import UIKit

enum MathTypes: Int, CaseIterable {
    case add, subtract, multiply, divide
    
    var key: String {
        return "Count \(self)"
    }
}

class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var mathOperationButtons: [UIButton]!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var subtractLabel: UILabel!
    @IBOutlet weak var multiplyLabel: UILabel!
    @IBOutlet weak var divideLabel: UILabel!
    
    // MARK: - Properties
    private var selectedType: MathTypes = .add
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        setScoreLabels()
    }
    
    // MARK: - Methods
    @IBAction func mathOperationButtonsAction(_ sender: UIButton) {
        selectedType = MathTypes(rawValue: sender.tag) ?? .add
        performSegue(withIdentifier: "goToTrainScreen", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? TrainViewController {
            viewController.type = selectedType
        }
    }
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue) {
        setScoreLabels()
    }
    
    @IBAction func ClearButtonAction(_ sender: UIButton) {
        MathTypes.allCases.forEach { type in
            let key = type.key
            UserDefaults.container?.removeObject(forKey: key)
        }
        setScoreLabels()
    }
    
    private func setScoreLabels() {
        MathTypes.allCases.forEach { type in
            let key = type.key
            var stringValue = ""
            
            if let scores = UserDefaults.container?.object(forKey: key) as? Int {
                stringValue = String(scores)
            } else {
                stringValue = "-"
            }
            
            switch type {
            case .add:
                addLabel.text = stringValue
            case .subtract:
                subtractLabel.text = stringValue
            case .multiply:
                multiplyLabel.text = stringValue
            case .divide:
                divideLabel.text = stringValue
            }
        }
    }
    
    private func configureButtons() {
        mathOperationButtons.forEach { button in
            button.layer.shadowColor = UIColor.darkGray.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 0.5
            button.layer.shadowRadius = 3
        }
    }
}
