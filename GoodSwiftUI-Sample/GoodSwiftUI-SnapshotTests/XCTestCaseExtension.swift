//
//  XCTestCaseExtension.swift
//  GoodSwiftUI-Sample
//
//  Created by Lukas Kubaliak on 22/08/2025.
//

import XCTest

extension XCTestCase {
    
    static let requiredSnapshotDeviceIdentifier = "iPhone17,1"
    static let requiredSnapshotDevice = "iPhone 16 Pro"
    static let requiredSnapshotOS = "18.6"
    
    var currentDeviceIdentifier: String { ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "Unknown" }
    var currentDevice: String { ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] ?? "Unknown" }
    var currentOS: String { ProcessInfo.processInfo.environment["SIMULATOR_RUNTIME_VERSION"] ?? "Unknown" }
    
    open override func setUp() async throws {
        try await super.setUp()
        
        guard   currentDeviceIdentifier != XCTestCase.requiredSnapshotDeviceIdentifier
                || !currentOS.hasPrefix(XCTestCase.requiredSnapshotOS)
                || UITraitCollection.current.userInterfaceStyle != .light
        else {
            return
        }
        
        XCTFail(
                """
                ❌ Snapshot tests must be run on \(XCTestCase.requiredSnapshotDevice) ios: \(XCTestCase.requiredSnapshotOS), light mode.
                Your current configuration: \(currentDevice) / \(currentOS), \(UITraitCollection.current.userInterfaceStyle == .dark ? "dark" : "light") mode
                """
        )
    }
    
}
