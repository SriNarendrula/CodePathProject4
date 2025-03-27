//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Sri Narendrula on 3/26/25.
//

import Foundation

class TriviaQuestionService {
    static func fetchQuestions(completion: @escaping ([TriviaQuestion]?) -> Void) {
        let url = URL(string: "https://opentdb.com/api.php?amount=5")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("Error fetching questions: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]] {
                    var questions: [TriviaQuestion] = []
                    for result in results {
                        if let question = TriviaQuestion(json: result) {
                            questions.append(question)
                        }
                    }
                    completion(questions)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
}
