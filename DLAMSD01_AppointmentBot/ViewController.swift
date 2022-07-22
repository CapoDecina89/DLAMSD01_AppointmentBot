//
//  ViewController.swift
//  DLAMSD01_AppointmentBot
//
//  Created by Benjamin Grunow on 20.07.22.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let questionAnswerer = ConversationDelegate()
    let conversationSource = ConversationDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func userInputChanged(_ sender: Any) {
        if userInput.text!.isEmpty == true  {
            sendButton.isEnabled = false
        }else {
            sendButton.isEnabled = true
        }
    }
        
    @IBAction func sendButtonPressed(_ sender: Any) {
        let text = userInput.text
        userInput.text = nil
        
    }
    
    ///called when the user enters a question
    func respondeTo(_ text: String) {
        //add body
    }
}

extension ViewController: UITextFieldDelegate {
    ///runs after the user hits the return key on the keyboard
    func textFieldShouldReturn(_ userInput: UITextField) -> Bool {
        //if textfield is empty do nothing
        guard let text = userInput.text else {
            return false
        }
        // Clear out the text
        userInput.text = nil
        // Deal with the question
       respondeTo(text)
        return false
    }
    ///clears testfield after editings starts
    func textFieldDidBeginEditing(_ userinput: UITextField) {
        // Clear out the text
        userInput.text = nil
    }

//MARK: Table view datasource
    
    
//MARK: Table view delegate
}
