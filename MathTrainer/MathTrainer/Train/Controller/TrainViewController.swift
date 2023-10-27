//
//  TrainViewController.swift
//  MathTrainer
//
//  Created by Sviatoslav Samoilov on 11.07.2023.
//

import UIKit

final class TrainViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var answerButtonsCollection: [UIButton]!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoresLabel: UILabel!
    
    // MARK: - Properties
    private var firstNumber = 0
    private var secondNumber = 0
    private var sign = ""
    
    private var scoresAdd = 0
    private var scoresSubtract = 0
    private var scoresMultiply = 0
    private var scoresDivide = 0
    
    var type: MathTypes = .add {
        didSet {
            configureSign()
        }
    }
    
    private var answer: Int {
        configureAnswer()
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Methods
    private func configureUI() {
        getScores()
        configureTask()
        configureButtons()
    }
    
    private func getScores() {
        MathTypes.allCases.forEach { type in
            let key = type.key
            guard let scores = UserDefaults.container?.object(forKey: key) as? Int else { return }
            switch type {
            case .add:
                scoresAdd = scores
            case .subtract:
                scoresSubtract = scores
            case .multiply:
                scoresMultiply = scores
            case .divide:
                scoresDivide = scores
            }
        }
        setScoreLabel()
    }
    
    private func setScoreLabel() {
        switch type {
        case .add:
            scoresLabel.text = String(scoresAdd)
        case .subtract:
            scoresLabel.text = String(scoresSubtract)
        case .multiply:
            scoresLabel.text = String(scoresMultiply)
        case .divide:
            scoresLabel.text = String(scoresDivide)
        }
    }
    
    private func configureSign() {
        switch type {
        case .add:
            sign = "+"
        case .subtract:
            sign = "-"
        case .multiply:
            sign = "*"
        case .divide:
            sign = "/"
        }
    }
    
    private func configureTask() {
        if type == .divide {
            repeat {
                firstNumber = Int.random(in: 1...99)
                secondNumber = Int.random(in: 1...99)
            } while firstNumber % secondNumber != 0
        } else {
            firstNumber = Int.random(in: 1...99)
            secondNumber = Int.random(in: 1...99)
        }
        questionLabel.text = "\(firstNumber) \(sign) \(secondNumber) ="
    }
    
    private func configureAnswer() -> Int {
        switch type {
        case .add:
            return firstNumber + secondNumber
        case .subtract:
            return firstNumber - secondNumber
        case .multiply:
            return firstNumber * secondNumber
        case .divide:
            return firstNumber / secondNumber
        }
    }
    
    private func configureButtons() {
        answerButtonsCollection.forEach { button in
            button.backgroundColor = .white
            button.layer.shadowColor = UIColor.darkGray.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 0.5
            button.layer.shadowRadius = 3
        }
        
        let isRightButton = Bool.random()
        var randomAnswer: Int
        repeat {
            randomAnswer = Int.random(in: (answer - 5)...(answer + 5))
        } while randomAnswer == answer
        
        answerButtonsCollection[0].setTitle(isRightButton ? String(randomAnswer) : String(answer), for: .normal)
        answerButtonsCollection[1].setTitle(isRightButton ? String(answer) : String(randomAnswer), for: .normal)
    }
    
    @IBAction func firstAnswerButtonAction(_ sender: UIButton) {
        checkAnswer(answer: sender.titleLabel?.text ?? "", for: sender)
    }
    
    @IBAction func secondAnswerButtonAction(_ sender: UIButton) {
        checkAnswer(answer: sender.titleLabel?.text ?? "", for: sender)
    }
    
    private func checkAnswer(answer: String, for button: UIButton) {
        let isRightAnswer = Int(answer) == self.answer
        button.backgroundColor = isRightAnswer ? .systemGreen : .systemRed
        if isRightAnswer {
            switch type {
            case .add:
                scoresAdd += 1
            case .subtract:
                scoresSubtract += 1
            case .multiply:
                scoresMultiply += 1
            case .divide:
                scoresDivide += 1
            }
            saveScores()
            taskUpdate()
        } else {
            taskUpdate()
        }
    }
    
    private func saveScores() {
        switch type {
        case .add:
            UserDefaults.container?.set(scoresAdd, forKey: type.key)
        case .subtract: 
            UserDefaults.container?.set(scoresSubtract, forKey: type.key)
        case .multiply:
            UserDefaults.container?.set(scoresMultiply, forKey: type.key)
        case .divide:
            UserDefaults.container?.set(scoresDivide, forKey: type.key)
        }
    }
    
    private func taskUpdate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.configureTask()
            self?.configureButtons()
            self?.setScoreLabel()
        }
    }
}

// MARK: UserDefaults
extension UserDefaults {
    static let container = UserDefaults(suiteName: "container")
}
