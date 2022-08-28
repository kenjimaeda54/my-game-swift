# Coleção de jogos
Galaria com jogos prediletos e seu detalhes(data de lancamento,plataforma,nome do jogo). 

## Motivacao
Praticar o uso do CoreData e aprender a manipular CRUD com o banco

## Feature
- Para realizar filtros no banco utilizamos o [predicate](https://developer.apple.com/documentation/foundation/nspredicate), método que utilizei precisa de dois argumentos
- Primeiro argumento e condição do filtro e  segundo nome que desejamos filtrar
- Para realizar requisição no banco usamos um método que precisa de um genérico neste caso tem que ser a classe que e auto definida pelo core data ao criar suas identidades
- As duas identidades que criei foi Console e Game
- Para monitorar as mudanças no banco utilizei o delegate do fetchRequest

```swift
var resultFetchController: NSFetchedResultsController<Game>!

func loadGame(_ filter: String = "")  {
		let fetchRequest = Game.fetchRequest()
		let sortDescritor = NSSortDescriptor(key: "name", ascending: true)
		fetchRequest.sortDescriptors = [sortDescritor]
		
		if !filter.isEmpty {
			//format [c] -> case insensitve aceita maisculo minusculo
			//format %@ tudo que estiver em arguments vai para format
			let predicate = NSPredicate(format: "name contains [c] %@",  filter)
			fetchRequest.predicate = predicate
			
		}
		
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



//MARK: - NSFetchedResultsControllerDelegate
extension GamesTableViewController: NSFetchedResultsControllerDelegate {
	//esse metodo e sempre acionado quando ha uma mudanca no banco de dados
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

```

##
- Escrita,deleta ou atualiza  banco precisamos salvar, pois estes recursos ficam no contexto, então  não e  executado diretamente
- Para disponibilizar o contexto para aplicação,  criei uma extensão da UIViewController
- Abaixo o exemplo  de como deletar, salva, consulta e adicionar
- Classe Game e criada automaticamente pelo CoreData, porque e uma identidade do meu banco
- Para editar usei mesma classe de adicionar


```swift
import Foundation
import UIKit
import CoreData

extension UIViewController {
	
	var context: NSManagedObjectContext {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.persistentContainer.viewContext
	}
	
	
}


//deletar 
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
if editingStyle == .delete {
			if let game = resultFetchController.fetchedObjects?[indexPath.row] {
				context.delete(game)
			}
			do {
				try context.save()
			}catch  {
				print(error.localizedDescription)
			}
		}
}
  
//adicionar
@IBAction func handleAddGame(_ sender: UIButton) {
		if game == nil {
			game = Game(context: context)
		}
		game.name = txfGame.text
		game.dateRelease = datePicker.date
		
		if !txfConsole.text!.isEmpty {
			game.console = consoleManager.consoles[pickerView.selectedRow(inComponent: 0)]
		}
		game.img = imgCover.image
		do {
			try context.save()
			
		}catch {
			print(error.localizedDescription)
		}
		navigationController?.popViewController(animated: true)
	}
	
}
  
//ler um dado no banco
func loadGame(_ filter: String = "")  {
		let fetchRequest = Game.fetchRequest()
		let sortDescritor = NSSortDescriptor(key: "name", ascending: true)
		fetchRequest.sortDescriptors = [sortDescritor]
		
		//predicate e para fazer um filtro no core data
		if !filter.isEmpty {
			//format [c] -> case insensitve aceita maisculo minusculo
			//format %@ tudo que estiver em arguments vai para format
			let predicate = NSPredicate(format: "name contains [c] %@",  filter)
			fetchRequest.predicate = predicate
			
		}
		
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


```


##
- Trabalhei com imagens do próprio celular e câmera
- Para isto utilizei um novo tipo de alerta  .actionSheet ele abre uma bandeja de baixo para cima
- Simulador não possui câmera então e ideal verificar se este recurso esta disponível, antes de usar
- Existe um delegate para ser acionado toda vez que uma imagem e selecionado, ideal para usar sua imagem



```swift
@IBAction func handleAddImg(_ sender: UIButton) {
		let alert = UIAlertController(title: "Selected poster", message: "You would like chosse poster", preferredStyle: .actionSheet)
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			let cameraAction = UIAlertAction(title: "Camera", style: .default,handler: { [self](camera) in
				selectPicture(.camera)
			})
			alert.addAction(cameraAction)
		}
		
		let librayAction = UIAlertAction(title: "Photo library", style: .default) { [self](action) in
			selectPicture(.photoLibrary)
		}
		alert.addAction(librayAction)
		
		let photosAction = UIAlertAction(title: "Photo album", style: .default) { [self](action) in
			selectPicture(.savedPhotosAlbum)
		}
		alert.addAction(photosAction)
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(cancel)
		present(alert, animated: true, completion: nil)
	}
	
	
	func selectPicture(_ sourceType: UIImagePickerController.SourceType) {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = sourceType
		imagePicker.navigationBar.tintColor = UIColor(named: "main")
		present(imagePicker, animated: true, completion: nil)
		
	}




//MARK: - UIImagePickerControllerDelegate,UINavigationControllerDelegate
extension AddEditViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
	
	//metodo quando clicado em uma imagem
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
		imgCover.image = image
		btAddImg.setTitle(nil, for: .normal)
		dismiss(animated: true,completion: nil)
		
	}
	
}


```










