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
    
    /// If the app is opened with a url using the registered scheme `swiftsimctlexample`
    /// then ths code will post a deep link notification whose object is url host + path.
    ///
    /// Example:
    /// - Opening `swiftsimctlexample://foo/bar` posts a Notification
    ///   named `"deepLink"` with object `"foo/bar"`
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if
            let url = URLContexts.first?.url,
            url.scheme?.lowercased() == "swiftsimctlexample"
        {
            let path = "\(url.host ?? "")\(url.path)"
            NotificationCenter.default.post(name: .deepLink, object: path)
        }
    }
}

extension Notification.Name {
    static let deepLink: Notification.Name = .init(rawValue: "deepLink")
}
