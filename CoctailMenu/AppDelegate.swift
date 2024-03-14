//
//  AppDelegate.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    // MARK: - Core Data PersistentContainer
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoctailsSave")
        container.loadPersistentStores(completionHandler: { (descriptionStore, errorStore) in
            if let error = errorStore as NSError? {
                fatalError("Store error \(error), \(error.userInfo)")
            } else {
               // print("Store URL: \(String(describing: descriptionStore.url))")
            }
        })
        return container
    }()
    // MARK: - Core Data SaveContext
    func saveContext () {
          let context = persistentContainer.viewContext
          if context.hasChanges {
              do {
                  try context.save()
              } catch {
                  let errorSave = error as NSError
                  fatalError("Save error \(errorSave.localizedDescription)")
              }
          }
      }
}

