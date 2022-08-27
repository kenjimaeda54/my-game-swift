//
//  ConsoleTableViewController.swift
//  My game
//
//  Created by kenjimaeda on 20/08/22.
//

import UIKit

class ConsoleTableViewController: UITableViewController {
	
	var consoleManager = ConsoleManager()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let app = UINavigationBarAppearance()
		app.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		app.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		app.backgroundColor = UIColor(named: "second")
		self.navigationController?.navigationBar.scrollEdgeAppearance = app
		loadConsoles()
	}
	
	func loadConsoles() {
		consoleManager.loadConsole(context)
		tableView.reloadData()
	}
	
	@IBAction func addConsole(_ sender: UIBarButtonItem) {
		showAllert(nil)
	}
	
	func showAllert(_ console: Console?) {
		let title = console == nil ? "Add" : "Edit"
		let message = console == nil ? "Add new console" : "Edit console"
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addTextField {(textField) in
			textField.placeholder = "Name console"
			if let nameConsole = console?.name {
				textField.text = nameConsole
			}
		}
		let action = UIAlertAction(title: "Confirm", style: .default) { [self] (addAction) in
			let console = console ?? Console(context: context)
			console.name = alert.textFields?.first?.text
			do {
				try context.save()
				loadConsoles()
			}catch {
				print(error)
			}
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.view.tintColor = UIColor(named: "second")
		alert.addAction(action)
		alert.addAction(cancel)
		present(alert, animated: true, completion: nil)
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return consoleManager.consoles.count
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let console = consoleManager.consoles[indexPath.row]
		showAllert(console)
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			consoleManager.deleteConsole(index: indexPath.row, context: context)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		let console = consoleManager.consoles[indexPath.row]
		//estilo basico de uma table view
		cell.textLabel?.text = console.name
		return cell
	}
	
	
	
}
