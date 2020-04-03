//
//  Example_01_HandlePushNotificationsTests.swift
//  SwiftSimctlExampleUITests
//
//  Created by Christian Treffs on 19.03.20.
//  Copyright © 2020 Christian Treffs. All rights reserved.
//

import Simctl
import XCTest

class Example_01_HandlePushNotificationsTests: XCTestCase {
    lazy var simctl = SimctlClient(SimulatorEnvironment(bundleIdentifier: exampleAppBundleId,
                                                        host: .localhost(port: 8080))!)

    func testAllowPushNotifications() {
        // MARK: Launch app and enable push notifications
        let app = XCUIApplication.exampleApp
        app.launch()

        if app.buttons["Re-enable push authorization manually in settings"].exists {
            XCTFail("Push notifcations are denied. Re-enable them manually.")
            return
        }

        let enablePushButton = app.buttons["Request push authorization"]
        guard enablePushButton.exists else {
            // assume we have already authorized
            return
        }

        let exp = expectation(description: "\(#function)")
        let token = addUIInterruptionMonitor(withDescription: "PushPermissionsDialog") { alert -> Bool in
            let alertButton = alert.buttons["Allow"]
            guard alertButton.waitForExistence(timeout: 1.0) else {
                XCUIApplication.exampleApp.tap()
                XCTFail("Allow button missing")
                return false
            }

            alertButton.tap()
            defer { exp.fulfill() }
            return true
        }
        defer { removeUIInterruptionMonitor(token) }

        enablePushButton.tap()

        /// interrupt monitor needs this
        if #available(iOS 13.4, *) {
            app.activate()
            app.tap()
        } else {
            // handle in lower simulator
            app.swipeUp()
        }

        waitForExpectations(timeout: 3.0)
        app.terminate()
    }

    func testOpenAppFromPushNotification() throws {
        XCUIApplication.exampleApp.terminate()

        let payload: String = """
        {
        "Simulator Target Bundle": "\(exampleAppBundleId)",
        "aps": {
        "alert": {
        "body": "\(#function)",
        "title": "Open app from a push notification!"
        }
        }
        }
        """

        guard let data = payload.data(using: .utf8) else {
            XCTFail("Failed to make data from string")
            return
        }

        let exp = expectation(description: "\(#function)")
        simctl.sendPushNotification(.jsonPayload(data)) { result in
            switch result {
            case .success:
                exp.fulfill()

            case let .failure(error):
                XCTFail("\(error)")
            }
        }

        wait(for: [exp], timeout: 5.0)

        // 2. tap received push notification
        let notification = XCUIApplication.springboard.otherElements["NotificationShortLookView"]

        guard notification.waitForExistence(timeout: 5.0) else {
            XCTFail("Did not receive push notification - did you allow push notifications?")
            return
        }

        notification.tap()

        // 3. app opens
        let app = XCUIApplication.exampleApp
        guard app.waitForExistence(timeout: 20.0) else {
            XCTFail("App did not appear")
            return
        }

        // 4. evaluate result
        let titleLabel = app.staticTexts["Push authorization status:"]
        guard titleLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("We did not find title label")
            return
        }

        XCTAssertEqual(titleLabel.label, "Push authorization status:")
    }
}
