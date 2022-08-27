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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == ConstRouteSegue.gameSegue  {
			let vc = segue.destination as! ShowGamesViewController
			//indexPathForSelectedRow.row pego o index do row selecionado
			if let games = resultFetchController.fetchedObjects,let index =  tableView.indexPathForSelectedRow?.row {
				vc.game = games[index]
			}
			
		}
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
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			if let game = resultFetchController.fetchedObjects?[indexPath.row] {
				context.delete(game)
			}
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
			if let index = indexPath {
				tableView.deleteRows(at: [index], with: .fade)
			}
			break
		default:
			tableView.reloadData()
		}
		
	}
	
}
