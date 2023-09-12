//
//  Types.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 9/11/23.
//

import Foundation

public struct DecodableSymptom: Decodable {
    var id: Int
    var name: String
}

public struct DecodableIntensity: Decodable {
    var label: String
    var value: Int
}
