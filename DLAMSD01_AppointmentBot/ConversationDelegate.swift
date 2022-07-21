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
        return NLLanguageRecognizer.dominantLanguage(for: question) ?? NLLanguage.undetermined
        
    }
    
    /// Creates an answer message in response to a question.
    func responseTo(question: String) -> String {
        let lowerQuestion = question.lowercased()
        
        //review: argument label
        if checkLanguage(question: question) != NLLanguage.english{
            return "Please ask me in English. 🇬🇧"
        }
        //Path appointment
        else if lowerQuestion.contains("appointment") {
            return "Sure. I can help you with your appointment./nWould you like to have info on your next appointment, make a new appointment or reschedule an existing?"
            //insert cases: next, new and reschedule
        }
        //Path opening hours
        else if lowerQuestion.contains("open") {
            return "We are open:/nMo - Fr 0800 - 1700"
        }
        //Path Direction
        else if lowerQuestion.contains("where") || lowerQuestion.contains("find") {
            return "One Apple Park Way, Cupertino, CA 95014"
        }else {
            return "Would you like to contact our reception?"
        }
    }
}
