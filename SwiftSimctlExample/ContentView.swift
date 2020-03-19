//
//  ContentView.swift
//  SwiftSimctlExample
//
//  Created by Christian Treffs on 19.03.20.
//  Copyright © 2020 Christian Treffs. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var authorizationStatus: UNAuthorizationStatus = .notDetermined

    var body: some View {
        VStack {
            Text("Push authorization status:")
                .fontWeight(.bold)
                .padding(4)
            Text(authorizationStatus.description)
                .foregroundColor(authorizationStatus.color)
                .padding(20)

            if authorizationStatus == .notDetermined {
                Button(action: { self.requestAuthorization() }) { Text("Request push authorization") }
            } else if authorizationStatus == .denied {
                Button(action: { UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!) }) { Text("Re-enable push authorization manually in settings") }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in self.updateAuthorizationStatus() }
        .onAppear(perform: { self.updateAuthorizationStatus() })
    }

    private func updateAuthorizationStatus() {
        UNUserNotificationCenter.current()
            .getNotificationSettings {
                self.authorizationStatus = $0.authorizationStatus
            }
    }

    private func requestAuthorization() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
                self.updateAuthorizationStatus()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UNAuthorizationStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notDetermined:
            return "notDetermined"
        case .denied:
            return "denied"
        case .authorized:
            return "authorized"
        case .provisional:
            return "provisional"
        @unknown default:
            return "unknown"
        }
    }

    public var color: Color {
        switch self {
        case .authorized:
            return .green

        case .notDetermined:
            return .gray

        case .denied:
            return .red

        case .provisional:
            return .yellow
        @unknown default:
            return .purple
        }
    }
}
