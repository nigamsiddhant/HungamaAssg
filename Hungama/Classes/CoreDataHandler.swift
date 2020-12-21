//
//  CoreDataHandler.swift
//  Hungama
//
//  Created by admin_vserv on 19/12/20.
//

import Foundation
import CoreData
import UIKit

struct CoreDataHandler {
    static let shared = CoreDataHandler()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let entityName = "SearchHistory"
    
    // to add the searchtext in coredata
    func addData(searchText: String?) {
        if searchText == "" {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        newUser.setValue(searchText, forKey: "searchText")
        do {
            try context.save()
        } catch {
            print("failed to add data in coredata")
        }
    }
    
    // fetch the search text from core data
    func fetchData() -> [String]{
        
        var searchHistorys: [String] = []
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let results = try context.fetch(fetchRequest)
            let  dateCreated = results
            
            for data in dateCreated as! [NSManagedObject] {
                print(data.value(forKey: "searchText") as! String)
                let searchHistory = data.value(forKey: "searchText") as? String
                searchHistorys.append(searchHistory ?? "")
            }
        }catch let err as NSError {
            print(err.debugDescription)
        }
        return searchHistorys
        
    }
}
