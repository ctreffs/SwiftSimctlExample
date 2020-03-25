//
//  ChangeAppearanceTests.swift
//  SwiftSimctlExampleUITests
//
//  Created by Christian Treffs on 25.03.20.
//  Copyright © 2020 Christian Treffs. All rights reserved.
//

import Simctl
import SnapshotTesting
import XCTest

class ChangeAppearanceTests: XCTestCase {
    lazy var simctl = SimctlClient(SimulatorEnvironment(bundleIdentifier: exampleAppBundleId,
                                                        host: .localhost(port: 8080))!)
}
