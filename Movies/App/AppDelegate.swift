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
    private var mainCoordinator: MainCoordinator?
    private let networkManager = NetworkManager()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        window?.tintColor = .label
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        mainCoordinator = MainCoordinator(navigationController: navigationController,
                                          networkManager: networkManager)
        mainCoordinator?.start()
        return true
    }
}
