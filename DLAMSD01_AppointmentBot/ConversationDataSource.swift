//
//  ConversationDataSource.swift
//  DLAMSD01_AppointmentBot
//
//  Created by Benjamin Grunow on 20.07.22.
//

import Foundation
class ConversationDataSource {
    
    /// The number of Messages in the conversation
    var messageCount: Int {
        return messages.count
    }
    var messages = [openingLine]
    
    /// Add a new question to the conversation
    func add(question: String) {
        let message = Message(date: Date(), text: question, type: .question)
        messages.append(message)
    }
    
    /// Add a new answer to the conversation
    func add(answer: String) {
        let message = Message(date: Date(), text: answer, type: .answer)
        messages.append(message)
    }
    
    /// The Message at a specific point in the conversation
    func messageAt(index: Int) -> Message {
        return messages[index]
    }
}
