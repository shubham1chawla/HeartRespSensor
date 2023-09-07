//
//  CameraView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 9/3/23.
//

import SwiftUI
import Photos

struct CameraView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var cameraService: CameraService
    @EnvironmentObject var measurementService: MeasurementService
    
    private let defaults = UserDefaults.standard
    
    @State private var isRecording = false
    @State private var isProcessing = false
    @State private var secondsElapsed = 0
    @Binding var heartRate: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CameraPreviewView() { result in
                    switch result {
                    case .success(let videoUrl):
                        handlePostVideoRecording(for: videoUrl)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                if isProcessing || isRecording {
                    let dialogText = isProcessing
                        ? "Calculating your heart rate. Please be patient."
                        : "Video recording in progress. \(MeasurementConstants.MAX_TIME_DURATION - secondsElapsed) seconds remaining."
                    ProgressView {
                        Text(dialogText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .controlSize(.large)
                    .frame(width: geometry.size.width / 1.5, height: geometry.size.height / 4)
                    .background(Color(UIColor.systemBackground))
                    .foregroundColor(Color(UIColor.label))
                    .cornerRadius(20)
                }
                else {
                    VStack {
                        Spacer()
                        Button {
                            cameraService.startRecording(filename: defaults.string(forKey: Keys.LAST_USER_SESSION)!)
                            isRecording.toggle()
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                                // Stopping video recording after max time duration
                                guard secondsElapsed + 1 < MeasurementConstants.MAX_TIME_DURATION else {
                                    cameraService.stopRecording()
                                    isRecording.toggle()
                                    secondsElapsed = 0
                                    timer.invalidate()
                                    return
                                }
                                secondsElapsed += 1
                            }
                        } label: {
                            Image(systemName: "record.circle")
                                .foregroundColor(.white)
                                .padding()
                                .font(.system(size: 72))
                        }
                        .padding(.bottom)
                    }
                }
            }
        }
        .navigationTitle("Heart Rate")
    }
    
    private func handlePostVideoRecording(for videoUrl: URL) {
        isProcessing.toggle()
        measurementService.calculateHeartRate(for: videoUrl) { result in
            isProcessing.toggle()
            switch result {
            case .success(let heartRate):
                self.heartRate = heartRate
                saveVideo(for: videoUrl)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            // Closing the camera view after processing the video
            DispatchQueue.main.async {
                dismiss()
            }
        }
    }
    
    private func saveVideo(for videoUrl: URL) -> Void {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)
        }) { saved, error in
            if let error = error {
                print(error.localizedDescription)
            }
            else if !saved {
                print("Error: Unable to save the video!")
            }
            
            // Deleting the temporary video file
            try? FileManager.default.removeItem(at: videoUrl)
        }
    }
    
}
