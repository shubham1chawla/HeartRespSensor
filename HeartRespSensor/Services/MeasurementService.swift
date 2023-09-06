//
//  MeasurementService.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 9/5/23.
//

import Foundation
import AVFoundation
import AssetsLibrary

class MeasurementService: ObservableObject {
    
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
                for i in stride(from: 10, to: Int(frames), by: 5) {
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
                    if (averages[i] - prev) > 3500 {
                        count += 1
                    }
                    prev = averages[i]
                }
                let heartRate = (Double(count) / 45) * 30
                completion(.success(heartRate))
                
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }

}
