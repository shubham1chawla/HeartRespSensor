//
//  Constants.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 9/1/23.
//

import Foundation
import SwiftUI

public struct Keys {
    static let APPLICATION_NAME = "HeartRespSensor"
    static let LAST_USER_SESSION = "lastUserSession"
    static let IS_DEVELOPER_MODE_ENABLED = "isDeveloperModeEnabled"
}

public struct MeasurementConstants {
    
    // Common constants
    static let MAX_TIME_DURATION = 45
    
    // Heart rate measurement related constants
    static let STARTING_FRAME_COUNT = 10
    static let FRAME_INTERVAL = 5
    static let AVERAGE_DIFFERENCE_THRESHOLD = 210000
    
    // Resp rate measurement related constants
    static let ACCELEROMETER_INTERVAL = 0.1
    static let ACCELEROMETER_DIFFERENCE_THRESHOLD = 0.15
    
}

public struct UIConstants {
    static let CORNER_RADIUS: CGFloat = 20
    static let STROKE_LINE_WIDTH: CGFloat = 1
    static let STROKE_COLOR = Color.secondary
    static let BACKGROUND_COLOR = Color(UIColor.secondarySystemBackground)
    static let FOREGROUND_COLOR = Color(UIColor.label)
}
