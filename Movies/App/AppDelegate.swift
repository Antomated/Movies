//
//  AppDelegate.swift
//  Movies
//
//  Created by Anton Petrov on 18.10.2023.
//
// TODO: remove Lint
// TODO: Renew API key
// TODO: Consider Ipad layout
// TODO: Add Launchscreen
// TODO: Localize
// TODO: Offline search
// TODO: safe array access?
// TODO: loader on details poster

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainCoordinator: MainCoordinator?
    let networkManager = NetworkManager()

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
