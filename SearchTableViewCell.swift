//
//  SearchTableViewCell.swift
//  CalendError
//
//  Created by JMMac036 on 2022/07/19.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var missLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tagLabel.text = "Swift"
        missLabel.text = "これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容これが内容"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
