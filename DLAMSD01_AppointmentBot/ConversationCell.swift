import UIKit

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.doesRelativeDateFormatting = true
    formatter.timeStyle = .short
    formatter.dateStyle = .short
    return formatter
}()

/// Used to display a message in the conversation. There are two layouts of this cell, specified in the storyboard,
/// but the components are the same.
class ConversationCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageView: UITextView!

    
    
    ///fills labels with message attributes
    func configureWithMessage(_ message: Message) {
        dateLabel.text = dateFormatter.string(from: message.date as Date)
        messageView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        messageView.layer.cornerRadius = 13
        messageView.text = message.text
    }

}
