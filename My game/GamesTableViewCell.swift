//
//  GamesTableViewCell.swift
//  My game
//
//  Created by kenjimaeda on 20/08/22.
//

import UIKit

class GamesTableViewCell: UITableViewCell {
	
	@IBOutlet weak var labConsole: UILabel!
	@IBOutlet weak var labName: UILabel!
	@IBOutlet weak var imgGame: UIImageView!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	

	
	
	func prepareCell(_ game: Game) {

		labName.text =  game.name
		labConsole.text = game.console?.name
		
		if let img = game.img as? UIImage {

			imgGame.image = img
			
		}else {
			imgGame.image = UIImage(named: "noCover")
		}
		
	}
	
}
