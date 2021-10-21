//
//  SceneDelegate.swift
//  SwiftSimctlExample
//
//  Created by Christian Treffs on 19.03.20.
//  Copyright © 2020 Christian Treffs. All rights reserved.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = ContentView()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    /// If the app is opened with a register url scheme, then this function will
    /// filter urls whose scheme matches `com.example.SwiftSimctlExample`
    /// and post the `.deepLink` notification with the object being the url host + path.
    ///
    /// Example:
    /// - Opening `com.example.SwiftSimctlExample://foo/bar` broadcasts a
    ///  Notification named `deepLink` with object "foo/bar"
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if
            let url = URLContexts.first?.url,
            url.scheme?.lowercased() == "com.example.swiftsimctlexample"
        {
            let path = "\(url.host ?? "")\(url.path)"
            NotificationCenter.default.post(name: .deepLink, object: path)
        }
    }
}

extension Notification.Name {
    static let deepLink: Notification.Name = .init(rawValue: "deepLink")
}
