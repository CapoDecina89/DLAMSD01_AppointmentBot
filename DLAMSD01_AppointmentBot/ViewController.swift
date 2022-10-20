//
//  ViewController.swift
//  DLAMSD01_AppointmentBot
//
//  Created by Benjamin Grunow on 20.07.22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    let questionAnswerer = ConversationDelegate()
    let conversationSource = ConversationDataSource()
    fileprivate var isThinking = false
    private let thinkingTime : TimeInterval = 2
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var body: UIStackView!
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var sendButton: UIBarButtonItem!
       
    ///activates when the content of the userInput is changed. if textfield is empty -> sendButton: disabled, if not emtpy -> sendButton: enabled
    @IBAction func userInputChanged(_ sender: Any) {
        if userInput.text!.isEmpty == true  {
            sendButton.isEnabled = false
        }else {
            sendButton.isEnabled = true
        }
    }
    ///activates when sendButton is pressed -> saves text and resets userInput
    @IBAction func sendButtonPressed(_ sender: Any) {
        let text = userInput.text ?? ""
        userInput.text = nil
        respondeTo(question: text)
        sendButton.isEnabled = false
        userInput.resignFirstResponder()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // pin userInput to top of the keyboard
        body.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        tableView.dataSource = self
        tableView.delegate = self
    }
    ///called when the user enters a question
    func respondeTo(question text: String) {
        //blocks new questions while the app is thinking
        isThinking = true
        sendButton.isEnabled = false
        //checks whether the count of messages changes before adding a new row
        let countBeforeAdding = conversationSource.messageCount
        conversationSource.add(question: text)
        let count = conversationSource.messageCount
        //holds the index of the new question, if conversationSource has responded
        var questionPath: IndexPath?
        if countBeforeAdding != count {
            questionPath = IndexPath(row: count - 1, section: ConversationSection.history.rawValue)
        }
        //Inserts a row for the thinking cell, and for the newly added question (if that exists)
        tableView.insertRows(at: [questionPath, ConversationSection.thinkingPath].compactMap { $0 }, with: .bottom)
        tableView.scrollToRow(at: ConversationSection.thinkingPath, at: .bottom, animated: true)
        // Waits for the thinking time to elapse before adding the answer
        DispatchQueue.main.asyncAfter(deadline: .now() + thinkingTime) {
            //It's now OK to ask another question
            self.isThinking = false
            //Get an answer from the questionAnswerer
            let answer = self.questionAnswerer.responseTo(question:  text)
            //As before, check that adding an answer actually increases the message count
            let countBefore = self.conversationSource.messageCount
            self.conversationSource.add(answer: answer)
            let count = self.conversationSource.messageCount
            //Several updates are happening to the table so they are grouped inside begin / end updates calls
            self.tableView.beginUpdates()
            //Add the answer cell, if applicable
            if count != countBefore {
                self.tableView.insertRows(at: [IndexPath(row:count - 1, section: ConversationSection.history.rawValue)], with: .fade)
            }
            //Delete the thinking cell
            self.tableView.deleteRows(at: [ConversationSection.thinkingPath], with: .fade)
            self.tableView.endUpdates()
        }
        
    
        
    }
}

extension ViewController: UITextFieldDelegate {
    ///runs after the user hits the return key on the keyboard
    func textFieldShouldReturn(_ userInput: UITextField) -> Bool {
        //if textfield is empty do nothing
        guard let text = userInput.text else {
            return false
        }
        //if App is thinking return do nothing
        if isThinking {
            return false
        }
        // Clear out the text
        userInput.text = nil
        // Deal with the question
        respondeTo(question: text)
        sendButton.isEnabled = false
        return false
    }
    ///runs if userInput is edited
    func textFieldDidBeginEditing(_ userinput: UITextField) {
        // Clear out the text
        userInput.text = nil
        
    }
}

//MARK: Table view datasource
extension ViewController: UITableViewDataSource {
    
    // Used to define each section of the table
    fileprivate enum ConversationSection: Int {
        // Where the conversation goes
        case history = 0
        // Where the thinking indicator goes
        case thinking = 1
        
        
        static var sectionCount: Int {
            return self.thinking.rawValue + 1
        }
        
        static var allSections: IndexSet {
            return IndexSet(integersIn: 0..<sectionCount)
        }
        
        static var thinkingPath: IndexPath {
            return IndexPath(row: 0, section: self.thinking.rawValue)
        }
    }
    
    // How many sections are there in the table?
    func numberOfSections(in tableView: UITableView) -> Int {
        return ConversationSection.sectionCount
    }
    
    // How many rows are there in a particular section of the table?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ConversationSection(rawValue: section)! {
        case .history:
            // This is one of the questions the conversation data source is asked.
            return conversationSource.messageCount
        case .thinking:
            // No cells if the app is not thinking, one cell if it is
            return isThinking ? 1 : 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch ConversationSection(rawValue: indexPath.section)! {
        case .history:
            //ask CoversationDataSource for a message at index
            let message = conversationSource.messageAt(index: indexPath.row)
            //identifies the message type
            let identifier : String
            switch message.type {
            case .question: identifier = "Question"
            case .answer: identifier = "Answer"
            }
            let cell: ConversationCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ConversationCell
            cell.configureWithMessage(message)
            return cell
        case .thinking:
            // The thinking cell is always the same
            let cell = tableView.dequeueReusableCell(withIdentifier: "Thinking", for: indexPath) as! ThinkingCell
            cell.thinkingImage.startAnimating()
            return cell
        }
    }
}
    
//MARK: Table view delegate
extension ViewController {
    // This is a guess for the height of each row
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    // This tells the table to make the row the correct height based on the contents
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
