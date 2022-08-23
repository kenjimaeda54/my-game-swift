//
//  AddEditViewController.swift
//  My game
//
//  Created by kenjimaeda on 20/08/22.
//

import UIKit

class AddEditViewController: UIViewController {
	
	@IBOutlet weak var txfConsole: UITextField!
	@IBOutlet weak var txfGame: UITextField!
	@IBOutlet weak var btAddImg: UIButton!
	@IBOutlet weak var imgCover: UIImageView!
	@IBOutlet weak var datePicker: UIDatePicker!
	
	var game: Game!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	
	@IBAction func handleAddImg(_ sender: UIButton) {
	}
	
	
	@IBAction func handleAddGame(_ sender: UIButton) {
		if game == nil {
			game = Game(context: context)
		}
		game.name = txfGame.text
		game.dateRelease = datePicker.date
		
		do {
			try context.save()
			
		}catch {
			print(error.localizedDescription)
		}
		navigationController?.popViewController(animated: true)
	}
	
	
}
