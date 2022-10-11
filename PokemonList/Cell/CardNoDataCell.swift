//
//  CardNoDataCell.swift
//  PokemonList
//
//  Created by user on 07/10/22.
//

import UIKit

class CardNoDataCell: UITableViewCell {


//    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var txtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.txtLabel.textAlignment = .center
        self.txtLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
