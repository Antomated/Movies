//
//  AppDelegate.swift
//  Movies
//
//  Created by Anton Petrov on 18.10.2023.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var mainCoordinator =  MainCoordinator(navigationController: navigationController)
    private lazy var navigationController = UINavigationController()


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        window?.tintColor = .label
        window?.rootViewController = navigationController
        mainCoordinator.start()
        return true
    }
}
