//
//  Example_02_ChangeAppearanceTests.swift
//  SwiftSimctlExampleUITests
//
//  Created by Christian Treffs on 25.03.20.
//  Copyright © 2020 Christian Treffs. All rights reserved.
//

import Simctl
import SnapshotTesting
import XCTest

class Example_02_ChangeAppearanceTests: XCTestCase {
    lazy var simctl = SimctlClient(SimulatorEnvironment(bundleIdentifier: exampleAppBundleId,
                                                        host: .localhost(port: 8080))!)
    // run on iPhone 11 Pro
    func testDifferentAppearances() throws {
        let app = XCUIApplication.exampleApp
        app.launch()
        _ = app.waitForExistence(timeout: 2.0)

        let expDark = expectation(description: "set_appearance_dark")
        simctl.setDeviceAppearance(.dark) {
            switch $0 {
            case .success:
                expDark.fulfill()

            case let .failure(error):
                XCTFail("\(error)")
            }
        }

        wait(for: [expDark], timeout: 5.0)
        let label = app.staticTexts.element(boundBy: 0)
        _ = label.waitForExistence(timeout: 1.0)
        assertSnapshot(matching: label.screenshot().image,
                       as: .image)

        let expLight = expectation(description: "set_appearance_light")
        simctl.setDeviceAppearance(.light) {
            switch $0 {
            case .success:
                expLight.fulfill()

            case let .failure(error):
                XCTFail("\(error)")
            }
        }

        wait(for: [expLight], timeout: 5.0)
        _ = label.waitForExistence(timeout: 1.0)
        assertSnapshot(matching: label.screenshot().image,
                       as: .image)

        XCUIApplication.exampleApp.terminate()
    }

    func testDifferentAppearancesFullscreen() {
        let app = XCUIApplication.exampleApp
        app.launch()
        _ = app.waitForExistence(timeout: 2.0)

        let setOverridesExp = expectation(description: "set-overrides")
        simctl.setStatusBarOverrides([
            .batteryLevel(33),
            .time("11:11"),
            .cellularBars(.three),
            .dataNetwork(.lte),
            .operatorName("SwiftSimctl"),
            .cellularMode(.active)
        ]) {
            switch $0 {
            case .success:
                setOverridesExp.fulfill()

            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        wait(for: [setOverridesExp], timeout: 5.0)

        let expDark = expectation(description: "set_appearance_dark")
        simctl.setDeviceAppearance(.dark) {
            switch $0 {
            case .success:
                expDark.fulfill()

            case let .failure(error):
                XCTFail("\(error)")
            }
        }

        wait(for: [expDark], timeout: 5.0)
        let label = app.staticTexts.element(boundBy: 0)
        _ = label.waitForExistence(timeout: 1.0)
        // we do have a comparsion problem here since the virtual home bar indicator is not under our control and changes appearance
        assertSnapshot(matching: app.screenshot().image,
                       as: .image(precision: 0.6))

        let expLight = expectation(description: "set_appearance_light")
        simctl.setDeviceAppearance(.light) {
            switch $0 {
            case .success:
                expLight.fulfill()

            case let .failure(error):
                XCTFail("\(error)")
            }
        }

        wait(for: [expLight], timeout: 5.0)
        _ = label.waitForExistence(timeout: 1.0)
        assertSnapshot(matching: app.screenshot().image,
                       as: .image)

        let clearOverridesExp = expectation(description: "clear-overrides")
        simctl.clearStatusBarOverrides {
            switch $0 {
            case .success:
                clearOverridesExp.fulfill()

            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        wait(for: [clearOverridesExp], timeout: 3.0)

        XCUIApplication.exampleApp.terminate()
    }
}
