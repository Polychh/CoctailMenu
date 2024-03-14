//
//  DataManager.swift
//  CoctailMenu
//
//  Created by Polina on 14.03.2024.
//

import UIKit
import CoreData

protocol StoreManagerProtocol{
    func createFavoriteCoctail(coctailName: String, ingridients: String, instruction: String)
    func fetchCoctails() -> [FavorCotail]
    func deleteAllCoctails()
    func deleteOneCoctails(withName nameCoctail: String)
}

final class StoreManager: StoreManagerProtocol {
  
    private let entityName: String = "FavorCotail"
    
    private var appDelagate: AppDelegate{
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext{
        appDelagate.persistentContainer.viewContext
    }
    
    func createFavoriteCoctail(coctailName: String, ingridients: String, instruction: String) {
        guard let coctailEntityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return }
        let coctail = FavorCotail(entity: coctailEntityDescription, insertInto: context)
        coctail.nameCoctail = coctailName
        coctail.instruction = instruction
        coctail.ingridients = ingridients
        //print("save coctail \(coctail)")
        appDelagate.saveContext()
    }
    
    func deleteAllCoctails() {
        let fetchRequest = NSFetchRequest<FavorCotail>(entityName: entityName)
        do{
            let coctails = try? context.fetch(fetchRequest)
            coctails?.forEach{ context.delete($0) }
        }
        appDelagate.saveContext()
    }
    
    func deleteOneCoctails(withName nameCoctail: String) {
        let fetchRequest = NSFetchRequest<FavorCotail>(entityName: entityName)
        do{
            guard let coctails = try? context.fetch(fetchRequest),
                  let coctail = coctails.first(where: { $0.nameCoctail == nameCoctail}) else { return }
            context.delete(coctail)
        }
        appDelagate.saveContext()
    }
    
    
    func fetchCoctails() -> [FavorCotail]{
        let fetchRequest = NSFetchRequest<FavorCotail>(entityName: entityName)
        do{
            let coctails = (try? context.fetch(fetchRequest)) ?? []
            return coctails
        }
    }
}
