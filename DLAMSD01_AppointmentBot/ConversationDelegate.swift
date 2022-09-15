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
        
        //review: argument label
        if checkLanguage(question: question) != NLLanguage.english{
            return "Please ask me in English. 🇬🇧"
        //refacturate: interpretation of text as separate function, that is called by responseTo()
        }else {
            return interpret(question: question)
        }
    }
    
    
    func interpret(question:String) -> String {
        let lowerQuestion = question.lowercased()
        
        //Path appointment
        if lowerQuestion.contains("appointment") {
            return "Sure. I can help you with your appointment.\nWould you like to have info on your next appointment, make a new appointment or reschedule an existing?"
            //insert cases: next, new and reschedule
        }
        //Path next appointment
        else if lowerQuestion.contains("next") {
            //DataSource for appointments should be added later. For prototyp-use today + 3 days
            return "Your next appointment is due \(dateFormatter.string(from: Date(timeIntervalSinceNow: 259200)))."
        }
        //Path opening hours
        else if lowerQuestion.contains("open") {
            return "We are open:\nMo - Fr 08:00 - 17:00"
        }
        //Path Direction
        else if lowerQuestion.hasPrefix("where") || lowerQuestion.contains("find") {
            return "One Apple Park Way, Cupertino, CA 95014"
        }
        //Path misc
        else {
            return "Surely our reception can answer this question. Please contact us.\ntel:+4901234567889"
        }
    }
}

