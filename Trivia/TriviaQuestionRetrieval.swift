//
//  TriviaQuestionRetrieval.swift
//  Trivia
//
//  Created by Nathaniel Baez on 3/12/24.
//

import Foundation
import UIKit

struct TriviaQuestionService{
    public static func FetchQuestions(completion: (([TriviaQuestion]) -> Void)? = nil) {
        // I'll have the completion closure be called when it finishes calling the api call
        let apiString = "https://opentdb.com/api.php?amount=5"
        guard let apiURL = URL(string:apiString) else{return}
        
        // URLSession.shared.dataTask returns a suspended task, it must be resumed programtically
        let task = URLSession.shared.dataTask(with: apiURL){ data, response, error in
            
            // checks if error is defined, if it is an error occured
            guard error == nil else {
                assertionFailure("Error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            // validates if response is a HTTPURLResponse. If not, invalid response
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid Response")
                return
            }
            
            // validates if data is safe
            guard let data = data, httpResponse.statusCode == 200 else{
                assertionFailure("Invalid status code: \(httpResponse.statusCode)")
                return
            }
            
            // decoder allows transforms JSON to a foundation object
            let decoder = JSONDecoder()
            
            // decodes JSON data to a foundation object
            let response = try! decoder.decode(TriviaApiResponse.self, from: data)
            
            
            // completion closure assigns data response to a variable in TriviaViewController
            DispatchQueue.main.async {
                completion?(response.results)
            }
            
        } //task
        
        // reusme task programatically
        task.resume()
        
        
    } // FetchQuestions()
}

struct TriviaApiResponse: Decodable{
    let results: [TriviaQuestion]
    
    private enum CodingKeys: String, CodingKey{
        case results
    }
}
