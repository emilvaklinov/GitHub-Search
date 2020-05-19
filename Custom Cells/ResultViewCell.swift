//
//  ResultViewCell.swift
//  GitHub Search
//
//  Created by Emil Vaklinov on 19/05/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import UIKit

class ResultViewCell: UITableViewCell {

    
    @IBOutlet var avatar: UIImageView!
    
    @IBOutlet var statement: UILabel!
    
    @IBOutlet var fullName: UILabel!
    
    @IBOutlet var openIssues: UILabel!
    
    @IBOutlet var scoreIssues: UILabel!
    
    @IBOutlet var forks: UILabel!
    
    @IBOutlet var scoreForks: UILabel!
    
    @IBOutlet var watchers: UILabel!
    
    @IBOutlet var scoreWatchers: UILabel!
    
    @IBOutlet var url: UILabel!
    
    @IBOutlet var urlLink: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
