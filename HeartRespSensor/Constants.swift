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
}

public let defaultSymptoms = [
    1: "Fever",
    2: "Nausea",
    3: "Headache",
    4: "Diarrhea",
    5: "Soar Throat",
    6: "Muscle Ache",
    7: "Loss of Smell or Taste",
    8: "Cough",
    9: "Shortness of Breath",
    10: "Feeling Tired"
]

public let intensities = [
    1: "Minimal",
    2: "Mild",
    3: "Moderate",
    4: "Severe",
    5: "Extreme"
]

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
