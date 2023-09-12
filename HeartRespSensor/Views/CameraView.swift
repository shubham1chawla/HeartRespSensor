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
    @EnvironmentObject var photoLibraryService: PhotoLibraryService
    
    private let defaults = UserDefaults.standard
    
    @State private var isRecording = false
    @State private var isProcessing = false
    @State private var secondsElapsed = 0
    @State private var showHeartRateTip = false
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
                        ? "Please be patient while we are calculating your heart rate."
                        : "Please wait for \(MeasurementConstants.MAX_TIME_DURATION - secondsElapsed) seconds while we record your video."
                    ProgressView {
                        Text(dialogText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .controlSize(.large)
                    .frame(width: geometry.size.width / 1.5, height: geometry.size.height / 4)
                    .foregroundColor(UIConstants.FOREGROUND_COLOR)
                    .background {
                        RoundedRectangle(cornerRadius: UIConstants.CORNER_RADIUS, style: .continuous)
                            .fill(UIConstants.BACKGROUND_COLOR)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: UIConstants.CORNER_RADIUS)
                            .stroke(UIConstants.STROKE_COLOR, lineWidth: UIConstants.STROKE_LINE_WIDTH)
                    }
                }
            }
            .alert("Heart Rate Measurement Instructions", isPresented: $showHeartRateTip) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                Button("Start Measuring", role: .none) {
                    handlePreVideoRecording()
                }
            } message: {
                Text("Please ensure that you are in a well-lit area. Cover the back camera lens gently with your index finger. Point the camera lens towards a light source.")
            }
        }
        .navigationTitle("Heart Rate")
        .onAppear {
            showHeartRateTip.toggle()
        }
    }
    
    private func handlePreVideoRecording() -> Void {
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
    }
    
    private func handlePostVideoRecording(for videoUrl: URL) -> Void {
        isProcessing.toggle()
        measurementService.calculateHeartRate(for: videoUrl) { result in
            isProcessing.toggle()
            switch result {
            case .success(let heartRate):
                self.heartRate = heartRate
                
                // Saving the video to gallery if developer mode is enabled
                if defaults.bool(forKey: Keys.IS_DEVELOPER_MODE_ENABLED) {
                    photoLibraryService.saveVideo(for: videoUrl)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            // Closing the camera view after processing the video
            DispatchQueue.main.async {
                dismiss()
            }
        }
    }
    
}
