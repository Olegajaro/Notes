//
//  AppDelegate.swift
//  Notes
//
//  Created by Олег Федоров on 25.02.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        let navVC = UINavigationController(rootViewController: NoteListViewController())
        
        window?.rootViewController = navVC
        
        return true
    }
}

