//
//  ThinkingCell.swift
//  DLAMSD01_AppointmentBot
//
//  Created by Benjamin Grunow on 22.07.22.
//

import UIKit

class ThinkingCell: UITableViewCell {

    @IBOutlet weak var thinkingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thinkingImage.animationImages = (1...3).map {
            index in
            return UIImage(named: "thinking\(index)")!
        }
        thinkingImage.animationDuration = 1
    }
}
