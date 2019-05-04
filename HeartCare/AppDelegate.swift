//
//  AppDelegate.swift
//  HeartCare
//
//  Created by 222 on 2019/4/13.
//  Copyright © 2019 222. All rights reserved.
//

import UIKit
import CoreData
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var rotation = false
	
	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		if rotation { return .allButUpsideDown }
		return .portrait
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow()
		let root = BaseTabBarController()
		window?.rootViewController = root
		window?.makeKeyAndVisible()
		return true
	}

	func applicationWillTerminate(_ application: UIApplication) {
		 saveContext()
	}

	// MARK: - Core Data stack
	lazy var persistentContainer: NSPersistentContainer = {
	  
	    let container = NSPersistentContainer(name: "HeartCare")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error as NSError? {
	            fatalError("Unresolved error \(error), \(error.userInfo)")
	        }
	    })
	    return container
	}()

	// MARK: - Core Data Saving support
	func saveContext () {
	    let context = persistentContainer.viewContext
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}

}

