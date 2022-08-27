//
//  AddEditViewController.swift
//  My game
//
//  Created by kenjimaeda on 20/08/22.
//

import UIKit

class AddEditViewController: UIViewController {
	
	@IBOutlet weak var btnAddEdit: UIButton!
	@IBOutlet weak var txfConsole: UITextField!
	@IBOutlet weak var txfGame: UITextField!
	@IBOutlet weak var btAddImg: UIButton!
	@IBOutlet weak var imgCover: UIImageView!
	@IBOutlet weak var datePicker: UIDatePicker!
	//lazy e importante para garantir meu componente ser criado
	//apos a classe estiver pronta
	lazy var pickerView: UIPickerView = {
		let pickerView = UIPickerView()
		pickerView.delegate = self
		pickerView.dataSource = self
		pickerView.backgroundColor = .white
		return pickerView
	}()
	
	
	var game: Game!
	var consoleManager = ConsoleManager()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		consoleManager.loadConsole(context)
		formatedTollBar()
		if game != nil {
			title = "Edit"
			btnAddEdit.setTitle("Edit", for: .normal)
			txfGame.text = game.name
			
			if let image =  game.img as? UIImage {
				imgCover.image = image
				btAddImg.setTitle(nil, for: .normal)
			}
			
			//tentar pegar o index do console que esta nosso arrray
			if let console = game.console , let index = consoleManager.consoles.firstIndex(of: console) {
				 print(index)
				txfConsole.text = console.name
				pickerView.selectRow(index, inComponent: 0, animated: true)
			}
			
			if let date = game.dateRelease {
				datePicker.date = date
			}
			
		}
		
	}
	
	func formatedTollBar() {
		let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
		let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
		let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		
		toolbar.items = [cancel,flexible,done]
		//adicionando no topo do picker ui view que esta dentro do input console
		txfConsole.inputAccessoryView = toolbar
	}
	
	@objc func cancel() {
		txfConsole.resignFirstResponder()
	}
	
	
	@objc func done() {
		//so tenho uma linha por isso 0
		txfConsole.text = consoleManager.consoles[pickerView.selectedRow(inComponent: 0)].name
		cancel()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		txfConsole.inputView = pickerView
	}
	
	@IBAction func handleAddImg(_ sender: UIButton) {
		//action sheet parece com aqueles alert do android para compartilhar algo
		//do android
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

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension AddEditViewController:UIPickerViewDelegate,UIPickerViewDataSource {
	
	//cada coluna e um numero de ofComponentes
	//no caso do calendario seriam 3
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	//aqui e quantidade de linhas
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		return consoleManager.consoles.count
	}
	
	//conteudo
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let console = consoleManager.consoles[row]
		return console.name
	}
	
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
