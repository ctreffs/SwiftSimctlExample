//
//  Shared.swift
//  SwiftSimctlExampleUITests
//
//  Created by Christian Treffs on 25.03.20.
//  Copyright © 2020 Christian Treffs. All rights reserved.
//

import XCTest

let exampleAppBundleId = "com.example.SwiftSimctlExample"

extension XCUIApplication {
    static let exampleApp = XCUIApplication(bundleIdentifier: exampleAppBundleId)
    static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
}
