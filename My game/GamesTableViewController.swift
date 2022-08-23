//
//  GameTableViewController.swift
//  My game
//
//  Created by kenjimaeda on 20/08/22.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {
	
	var resultFetchController: NSFetchedResultsController<Game>!
	let cellSpacingHeight: CGFloat = 5
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let app = UINavigationBarAppearance()
		app.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		app.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		app.backgroundColor = UIColor(named: "main")
		self.navigationController?.navigationBar.scrollEdgeAppearance = app
		loadGame()
		
	}
	
	func loadGame()  {
		let fetchRequest = Game.fetchRequest()
		let sortDescritor = NSSortDescriptor(key: "name", ascending: true)
		fetchRequest.sortDescriptors = [sortDescritor]
		resultFetchController =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		
		//com delegate garanto que qualquer mudanca no banco de dados
		//vai ser exectuado os metodos que implementei neste delegate
		resultFetchController.delegate = self
		
		do {
			try resultFetchController.performFetch()
		}catch {
			print(error.localizedDescription)
		}
		
	}
	
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let count = resultFetchController.fetchedObjects?.count ?? 0
		
		return count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GamesTableViewCell
		if let game = resultFetchController.fetchedObjects?[indexPath.row] {
			cell.prepareCell(game)
			return	cell
		}else {
			return cell
		}
		
	}
	
}

extension GamesTableViewController: NSFetchedResultsControllerDelegate {
	//esse metodo e sempre ac/Users/kenjimaeda/Documents/projects_IOS/My games/My game/AddEditViewController.swiftionado quando ha uma mudanca no banco de dados
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		
		switch type {
		case .delete:
			break
		default:
			tableView.reloadData()
		}
		
	}
	
}
