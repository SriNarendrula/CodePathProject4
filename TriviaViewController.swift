//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class TriviaViewController: UIViewController {
  
  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  
  private var questions = [TriviaQuestion]()
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addGradient()
    questionContainerView.layer.cornerRadius = 8.0
    // TODO: FETCH TRIVIA QUESTIONS HERE
      fetchTriviaQuestions()

  }
  
    private func fetchTriviaQuestions() {
            TriviaQuestionService.fetchQuestions { [weak self] questions in
                DispatchQueue.main.async {
                    if let questions = questions {
                        self?.questions = questions
                        self?.updateQuestion(withQuestionIndex: 0)
                    } else {
                        self?.showErrorAlert()
                    }
                }
            }
        }
        
        private func showErrorAlert() {
            let alert = UIAlertController(
                title: "Error",
                message: "Failed to fetch questions. Please try again.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
                self?.fetchTriviaQuestions()
            })
            present(alert, animated: true)
        }
    
    private func updateQuestion(withQuestionIndex questionIndex: Int) {
        currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
        let question = questions[questionIndex]
        questionLabel.text = question.question
        categoryLabel.text = question.category
        
        // Determine if this is a True/False question
        let isTrueFalseQuestion = question.incorrectAnswers.count == 1 &&
                                (question.incorrectAnswers[0] == "True" ||
                                 question.incorrectAnswers[0] == "False")
        
        var answers: [String]
        
        if isTrueFalseQuestion {
            // For True/False questions, we'll always show True and False buttons
            answers = ["True", "False"]
            
            // If the correct answer is first in the array, swap them
            if question.correctAnswer == answers[0] {
                // No need to shuffle, just use True and False in order
            } else {
                answers = ["False", "True"] // Swap them
            }
        } else {
            // For multiple choice questions, shuffle all answers
            answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
        }
        
        // Always show buttons 0 and 1 (for True/False or first two multiple choice answers)
        answerButton0.setTitle(answers[0], for: .normal)
        answerButton0.isHidden = false
        
        answerButton1.setTitle(answers[1], for: .normal)
        answerButton1.isHidden = false
        
        // Only show buttons 2 and 3 if we have more answers (for multiple choice)
        answerButton2.setTitle(answers.count > 2 ? answers[2] : "", for: .normal)
        answerButton2.isHidden = answers.count <= 2
        
        answerButton3.setTitle(answers.count > 3 ? answers[3] : "", for: .normal)
        answerButton3.isHidden = answers.count <= 3
    }
  
  private func updateToNextQuestion(answer: String) {
    if isCorrectAnswer(answer) {
      numCorrectQuestions += 1
    }
    currQuestionIndex += 1
    guard currQuestionIndex < questions.count else {
      showFinalScore()
      return
    }
    updateQuestion(withQuestionIndex: currQuestionIndex)
  }
  
  private func isCorrectAnswer(_ answer: String) -> Bool {
    return answer == questions[currQuestionIndex].correctAnswer
  }
  
  private func showFinalScore() {
      
    let alertController = UIAlertController(
        title: "Game over!",
        message: "Final score: \(numCorrectQuestions)/\(questions.count)",
        preferredStyle: .alert)
      
    let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
      currQuestionIndex = 0
      numCorrectQuestions = 0
        fetchTriviaQuestions() // Fetch new questions instead of reusing old ones
    }
      
    alertController.addAction(resetAction)
    present(alertController, animated: true, completion: nil)
  }
  
  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
}

