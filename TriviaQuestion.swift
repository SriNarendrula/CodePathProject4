//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaQuestion {
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    init?(json: [String: Any]) {
        guard let category = json["category"] as? String,
              let question = json["question"] as? String,
              let correctAnswer = json["correct_answer"] as? String,
              let incorrectAnswers = json["incorrect_answers"] as? [String] else {
            return nil
        }
        
        // Decode HTML entities in the strings
        self.category = category.removingHTMLEncoding()
        self.question = question.removingHTMLEncoding()
        self.correctAnswer = correctAnswer.removingHTMLEncoding()
        self.incorrectAnswers = incorrectAnswers.map { $0.removingHTMLEncoding() }
    }
}

extension String {
    func removingHTMLEncoding() -> String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
}
