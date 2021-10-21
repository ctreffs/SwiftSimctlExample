//
//  Shared.swift
//  SwiftSimctlExampleUITests
//
//  Created by Christian Treffs on 25.03.20.
//  Copyright © 2020 Christian Treffs. All rights reserved.
//

import Simctl
import XCTest

let exampleAppBundleId = "com.example.SwiftSimctlExample"

let simctl = SimctlClient(
    SimulatorEnvironment(
        bundleIdentifier: exampleAppBundleId,
        host: .localhost(port: 8080)
    )!
)

extension XCUIApplication {
    static let exampleApp = XCUIApplication(bundleIdentifier: exampleAppBundleId)
    static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
}
