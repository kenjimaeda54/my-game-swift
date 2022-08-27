//
//  ShowGamesViewController.swift
//  My game
//
//  Created by kenjimaeda on 20/08/22.
//

import UIKit

class ShowGamesViewController: UIViewController {
	
	
	@IBOutlet weak var imgGame: UIImageView!
	@IBOutlet weak var labReleaseDate: UILabel!
	@IBOutlet weak var labGameName: UILabel!
	@IBOutlet weak var labConsole: UILabel!
	
	var game: Game!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "editSegue" {
			let vc = segue.destination as! AddEditViewController
			vc.game = game
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		if game != nil {
			title = "Game details"
			labGameName.text = game.name
			if let img = game.img as? UIImage {
				imgGame.image = img
			}else {
				imgGame.image = UIImage(named: "noCoverFull")
			}
			
			if let  date = game.dateRelease {
				let formatter = DateFormatter()
				//mostrar ano,mes ..
				formatter.dateStyle = .long
				//				//formatar em BR
				//				formatter.locale = Locale(identifier: "pt-BR")
				let dateFormated = formatter.string(from: date)
				labReleaseDate.text = "Year release: \(dateFormated)"
			}
			labConsole.text = game.console?.name
		}
		
	}
	
}
