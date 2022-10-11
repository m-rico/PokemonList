//
//  PokeListCell.swift
//  PokemonList
//
//  Created by user on 04/10/22.
//

import UIKit

class PokeListCell: UITableViewCell {

    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var listName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(_ imageName: String, name: String) {
        listImage.load(urlString: imageName)
        listName.text = name
        
    }
    
}
