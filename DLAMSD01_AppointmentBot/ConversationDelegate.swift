//
//  ConversationDelegate.swift
//  DLAMSD01_AppointmentBot
//
//  Created by Benjamin Grunow on 20.07.22.
//

import Foundation
import NaturalLanguage

class ConversationDelegate {
    
    /// The themes the Bot can answer to
    enum AnswerPath {
        case location
        case opening
        case appointment
        case greeting
        case misc
    }
    
    /// Creates an answer message in response to a question.
    func responseTo(question: String) -> String {
        
        //review: argument label
        if checkLanguage(question: question) != NLLanguage.english {
            return "Please ask me in English. 🇬🇧"
        }else {
            let answerkey = generateAnswerkey(for: question)
            let answerpath = findAnswerpath(for: answerkey)
            switch answerpath {
            case .greeting:
                return "Hey there. Which question can I answer for you?"
                
            case .misc:
                return "Sure. I can help you with your appointment.\nWould you like to have info on your next appointment, make a new appointment or reschedule an existing?"
            
            case .location:
                return "One Apple Park Way, Cupertino, CA 95014"
            
            case .appointment:
                return "Your next appointment is due \(dateFormatter.string(from: Date(timeIntervalSinceNow: 259200)))."
            
            case .opening:
                return "We are open:\nMo - Fr 08:00 - 17:00"
            }
        }
    }
    
    ///Checks the questions language
    func checkLanguage(question: String) -> NLLanguage {
        return NLLanguageRecognizer.dominantLanguage(for: question) ?? NLLanguage.undetermined
        
    }
    
    ///interprets the user query and returns the answerkey of the nearest neighbour
    func generateAnswerkey(for string: String) -> String {
        guard let embedding = NLEmbedding.sentenceEmbedding(for: .english) else { return "misc" }
        let exampleQueries = ["location_1" : "Where is your office located?",
                              "location_2" : "Where can I find you?",
                              "location_3" : "What is your adress?",
                              "opening_1" : "When are you open?",
                              "opening_2" : "What are your opening hours",
                              "opening_3" : "When is your office open?",
                              "appointment_1" : "When is my next appointment?",
                              "appointment_2" : "I would like to reschedule my appointment.",
                              "appointment_3" : "I have to cancel my appointment.",
                              "greeting_1" : "Hi.",
                              "greeting_2" : "How are you?"
        ]
        var answerKey: String = ""
        var answerDistance = 2.0
        
        for (key, exampleQuery) in exampleQueries {
            let distance = embedding.distance(between: exampleQuery, and: string)
            if distance < answerDistance {
                answerKey = key
                answerDistance = distance
            }
        }
        if answerDistance > 1.0 {
            answerKey = "misc"
        }
        return answerKey
    }
    
    ///Interprets the answerkey and returns the corresponding answerpath
    func findAnswerpath(for answerkey: String) -> AnswerPath {
        //substitute with cases and push Strings over to responseTo(question: String)
        //Path appointment
        if answerkey.contains("appointment") {
            return .appointment
            //insert cases: next, new and reschedule
        }
        //Path opening hours
        else if answerkey.contains("opening") {
            return .opening
        }
        //Path Location
        else if answerkey.contains("location") {
            return .location
        }
        //Path Greeting
        else if answerkey.contains("greeting") {
            return .greeting
        }
        //Path misc
        else if answerkey.contains("misc")  {
            return .misc
        }
        else {
            return .misc
        }
    }
    
}
