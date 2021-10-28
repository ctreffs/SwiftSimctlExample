//
//  Example_03_OpenUrlTests.swift
//  SwiftSimctlExampleUITests
//
//  Created by Robert Clark on 21.10.21.
//  Copyright © 2021 Christian Treffs. All rights reserved.
//

import Simctl
import XCTest

class Example_03_OpenUrlTests: XCTestCase {
    func testOpenUrlWithRegisteredScheme() throws {
        let app = XCUIApplication.exampleApp
        app.launch()

        let exp = expectation(description: "\(#function)")
        
        let deepLinkUrl = URL(string: "swiftsimctlexample://myDeepLink/display")!
        
        simctl.openUrl(deepLinkUrl) { result in
            switch result {
            case .success:
                exp.fulfill()

            case let .failure(error):
                XCTFail("\(error)")
            }
        }

        wait(for: [exp], timeout: 5.0)
        
        // First installs on fresh simulators will prompt to open registered urls.
        // UIInterruptionMonitor doesn't intercept this dialog (as of iOS 15
        // & Xcode 13) so we use Springboard to tap on the potential positive dialog
        // button instead.
        let openButton = XCUIApplication.springboard.buttons.element(boundBy: 1)
        if openButton.waitForExistence(timeout: 2) {
            openButton.tap()
        }

        let deepLinkPathLabel = app.staticTexts["myDeepLink/display"]
        guard deepLinkPathLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("We did not find deep link path label")
            return
        }

        XCTAssertEqual(deepLinkPathLabel.label, "myDeepLink/display")
    }
}
