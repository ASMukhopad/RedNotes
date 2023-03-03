//
//  MainRepository.swift
//  RedNotes
//
//  Created by Alexander on 02.03.2023.
//

import CoreData
import UIKit

// MARK: - MainRepositoryProtocol

protocol MainRepositoryProtocol {
    var notesItemsCount: Int { get }
    
    func appendNote(with text: String,
                    date: String)
    func firstSettings()
    func resetAllRecords()
    func updateNotesItems(with index: Int,
                          newText: String?,
                          date: String?)
    
    func clearRedNotesItems()
    func getText(with index: Int) -> String
    func getDate(with index: Int) -> String
}

final class MainRepository {
   
    // MARK: - Internal Properties
    
    var notesItems = [NSManagedObject]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    // MARK: - Private Methods
    
    private func fetch() -> [NSManagedObject] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            return try context.fetch(request).compactMap({ (element) -> NSManagedObject? in
                element as? NSManagedObject
            })
        } catch {
            return []
        }
    }
}

// MARK: - MainRepositoryProtocol

extension MainRepository: MainRepositoryProtocol {
    
    var notesItemsCount: Int {
        notesItems.count
    }
    
    func appendNote(with text: String,
                    date: String) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Note",
                                                      in: context) else { return }
        let newItem = NSManagedObject(entity: entity, insertInto: context)
        newItem.setValue(text, forKey: "text")
        newItem.setValue(date, forKey: "date")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        notesItems.insert(newItem, at: 0)
    }
    
    func firstSettings() {
        notesItems = fetch()
    }
    
    func resetAllRecords() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func updateNotesItems(with index: Int,
                          newText: String?,
                          date: String?) {
        if let newText = newText,
           let date = date {
            let item = self.notesItems[index]
            item.setValue(newText, forKey: "text")
            item.setValue(date, forKey: "date")
        } else {
            let item = self.notesItems[index]
            self.notesItems.remove(at: index)
            self.context.delete(item)
        }
        
        try? self.context.save()
    }
    
    func updateDateForNotesItems(with index: Int,
                                 newDate: String?) {
        if let newDate = newDate {
            let item = self.notesItems[index]
            item.setValue(newDate, forKey: "date")
        } else {
            let item = self.notesItems[index]
            self.notesItems.remove(at: index)
            self.context.delete(item)
        }
        
        try? self.context.save()
    }
    
    func clearRedNotesItems() {
        self.notesItems.removeAll()
    }
    
    func getText(with index: Int) -> String {
        notesItems[index].value(forKey: "text") as? String ?? ""
    }
    
    func getDate(with index: Int) -> String {
        notesItems[index].value(forKey: "date") as? String ?? ""
    }
}
