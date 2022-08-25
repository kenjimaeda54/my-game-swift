//
//  ConsoleManager.swift
//  My game
//
//  Created by kenjimaeda on 22/08/22.
//

import Foundation
import CoreData

struct ConsoleManager {
	
	
	var consoles: [Console] = []
	
	mutating func loadConsole(_ context: NSManagedObjectContext)   {
		let fetchRequest = Console.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		
		do {
			consoles = try context.fetch(fetchRequest)
		}catch {
			print(error.localizedDescription)
		}
		
	}
	
	func deleteConsole(index: Int,context: NSManagedObjectContext ) {
		let delete = consoles[index]
		context.delete(delete)
		do {
			try context.save()
		}catch {
			print(error.localizedDescription)
		}
	}
	
}
