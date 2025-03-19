//
//  SendMoneyTableViewCell.swift
//  SendMoneyApp
//
//  Created by Asad on 18/03/25.
//

import UIKit
import iOSDropDown
class SendMoneyTableViewCell: UITableViewCell {

    @IBOutlet weak var valueTextField: DropDown!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    static let identifier = "SendMoneyTableViewCell"

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(placeholder:String?, value:String?){
        valueTextField.text = value
        placeholderLabel.text = placeholder
    }
    
}

