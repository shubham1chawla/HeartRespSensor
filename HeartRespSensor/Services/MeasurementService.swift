//
//  MeasurementService.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 9/5/23.
//

import Foundation
import AVFoundation
import AssetsLibrary
import CoreMotion

class MeasurementService: ObservableObject {
    
    private var motionManager = CMMotionManager()
    
    func calculateHeartRate(for videoUrl: URL, completion: @escaping (Result<Double, Error>) -> ()) -> Void {
        let videoAsset = AVAsset(url: videoUrl)
        Task {
            do {
                // Loading video's metadata
                let tracks = try await AVURLAsset(url: videoUrl).load(.tracks)
                let fps = try await tracks[0].load(.nominalFrameRate).rounded()
                let duration = try await videoAsset.load(.duration)
                let frames = Double(fps) * duration.seconds

                // Generating image frames for the request times
                let generator = AVAssetImageGenerator(asset: videoAsset)
                var images: [CGImage] = []
                for i in stride(from: MeasurementConstants.STARTING_FRAME_COUNT, to: Int(frames), by: MeasurementConstants.FRAME_INTERVAL) {
                    let result = try await generator.image(at: CMTime(value: Int64(i), timescale: Int32(fps)))
                    images.append(result.image)
                }
                
                // Calculating pixel data from the images
                var pixelCount: Int64 = 0, redBucket: Int64 = 0, redBuckets: [Int64] = []
                for image in images {
                    let data = image.dataProvider?.data
                    let ptr: UnsafePointer<UInt8> = CFDataGetBytePtr(data)
                    let length: CFIndex = CFDataGetLength(data)
                    for i in stride(from: 0, to: length-1, by: 4) {
                        pixelCount += 1
                        redBucket += Int64(ptr[i]) + Int64(ptr[i+1]) + Int64(ptr[i+2])
                    }
                    redBuckets.append(redBucket)
                }
                
                // Averaging the red buckets
                var averages: [Int64] = []
                for i in 0...redBuckets.count-5 {
                    var average: Int64 = 0
                    for j in 0...4 {
                        average += redBuckets[i + j]
                    }
                    average /= 4
                    averages.append(average)
                }
                
                // Calculating heart rate from the averaged red buckets
                var count: Int64 = 0, prev = averages[0]
                for i in 1...averages.count-1 {
                    if (averages[i] - prev) > MeasurementConstants.AVERAGE_DIFFERENCE_THRESHOLD {
                        count += 1
                    }
                    prev = averages[i]
                }
                let heartRate = (Double(count) / duration.seconds) * 30
                completion(.success(heartRate))
                
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func calculateRespRate(completion: @escaping (Result<Double, Error>) -> ()) -> Void {
        
        // Setting up accelerometer for capturing motion
        motionManager.startAccelerometerUpdates()
        motionManager.accelerometerUpdateInterval = MeasurementConstants.ACCELEROMETER_INTERVAL
        
        // Setting up variable to measure respiratory rate
        var previousValue: Double = 0
        var intervalCount: Int = 0
        var rawRespCount: Int = 0
        
        // Setting up timer to measure respiratory rate
        Timer.scheduledTimer(withTimeInterval: MeasurementConstants.ACCELEROMETER_INTERVAL, repeats: true) { timer in
            // Checking if duration is within the acceptable time interval
            let duration = MeasurementConstants.ACCELEROMETER_INTERVAL * Double(intervalCount)
            guard duration < Double(MeasurementConstants.MAX_TIME_DURATION) else {
                
                // Calcuating final measurement after timer is finshed
                let respRate = (Double(rawRespCount) / duration) * 30
                completion(.success(respRate))
                
                // Stopping the timer
                timer.invalidate()
                return
            }
            
            // Fetching accelerometer data
            if let data = self.motionManager.accelerometerData {
                let value = sqrt(pow(data.acceleration.x, 2) + pow(data.acceleration.y, 2) + pow(data.acceleration.z, 2))
                if abs(value - previousValue) > MeasurementConstants.ACCELEROMETER_DIFFERENCE_THRESHOLD {
                    rawRespCount += 1
                }
                previousValue = value
            }
            intervalCount += 1
        }
        
    }

}
