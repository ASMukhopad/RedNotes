//
//  MainController.swift
//  RedNotes
//
//  Created by Alexander on 02.03.2023.
//

import UIKit

class MainController: UIViewController {

    // MARK: - Private Properties
    
    lazy private var contentView = MainView()
    private let repository: MainRepositoryProtocol = MainRepository()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repository.firstSettings()
        contentView.delegate = self
        setupNavigation()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigation() {
        title = "Red Notes"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "plus"),
                                                                      style: .plain,
                                                                      target: self,
                                                                      action: #selector(addNoteAction))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Удалить всё",
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(deleteAllNotes))
        
        self.navigationController?.navigationBar.tintColor = .red
    }
    
    @objc
    private func addNoteAction() {
        let noteController = NoteController(text: "", delegate: self)
        navigationController?.pushViewController(noteController, animated: true)
    }
    
    @objc
    private func deleteAllNotes() {
        
        let alertController = UIAlertController(title: "Удалить все заметки?",
                                                message: "",
                                                preferredStyle: .actionSheet)
        
        let removeAction = UIAlertAction(title: "Удалить все",
                                       style: .destructive,
                                       handler: { alert in
            
            self.repository.clearRedNotesItems()
            self.repository.resetAllRecords()
            self.contentView.collectionView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
}

// MARK: - MainViewProtocol

extension MainController: MainViewProtocol {
    
    var notesItemsCount: Int {
        repository.notesItemsCount
    }
    
    func selectItem(with index: Int) {
        let noteController = NoteController(text: repository.getText(with: index),
                                            delegate: self,
                                            index: index)
        navigationController?.pushViewController(noteController, animated: true)
    }
    
    func getText(with index: Int) -> String {
        repository.getText(with: index)
    }
    func getDate(with index: Int) -> String {
        repository.getDate(with: index)
    }
}

// MARK: - NoteProtocol

extension MainController: NoteProtocol {
    func changeNote(with text: String,
                    date: String,
                    index: Int) {
        repository.updateNotesItems(with: index,
                                    newText: text,
                                    date: date)
        
        contentView.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func addNote(with text: String,
                 date: String) {
        repository.appendNote(with: text,
                              date: date)
        contentView.collectionView.reloadData()
    }
    
    func deleteNote(with index: Int) {
        repository.updateNotesItems(with: index,
                                    newText: nil,
                                    date: nil)
        contentView.collectionView.reloadData()
    }
}
