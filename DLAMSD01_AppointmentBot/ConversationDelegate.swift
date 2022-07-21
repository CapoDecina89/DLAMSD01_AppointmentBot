//
//  ConversationDelegate.swift
//  DLAMSD01_AppointmentBot
//
//  Created by Benjamin Grunow on 20.07.22.
//

import Foundation
import NaturalLanguage
class ConversationDelegate {
    
    ///Checks the questions language
    func checkLanguage(question: String) -> NLLanguage {
        let lowerQuestion = question.lowercased()
        let recognizer = NLLanguageRecognizer()
        
        recognizer.processString(lowerQuestion)
        return recognizer.dominantLanguage!
        
    }
    
    /// Creates an answer in response to a question.
    func responseTo(question: String) -> String {
        let lowerQuestion = question.lowercased()
        
        
            
        if lowerQuestion.hasPrefix("hello") {
            return "Why, hello there!"
        } else if lowerQuestion == "where are the cookies?" {
            return "In the cookie jar!"
        } else if lowerQuestion.hasPrefix("where") {
            return "To the North!"
        } else {
            let defaultNumber = question.count % 3

            if defaultNumber == 0 {
                return "That really depends"
            } else if defaultNumber == 1 {
                return "I think so, yes"
            } else {
                return "Ask me again tomorrow"
            }
        }
    }
}
