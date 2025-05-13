//
//  AppDelegate.swift
//  FriendsApp
//
//  Created by Chirag Dodia on 4/17/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let friendsModel = FriendsModel()
    func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        _ = friendsModel.loadFromDisk()
        return true
    }
}
