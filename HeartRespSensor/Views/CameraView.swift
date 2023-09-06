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
    @State private var hasProcessingCompleted = false
    @State private var isProcessing = false
    @Binding var heartRate: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CameraPreviewView(cameraService: cameraService) { result in
                    switch result {
                    case .success(let videoUrl):
                        handlePostVideoRecording(for: videoUrl)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                VStack {
                    Spacer()
                    Button {
                        if isRecording {
                            cameraService.stopRecording()
                            isRecording.toggle()
                        }
                        else {
                            cameraService.startRecording(sessionId: defaults.string(forKey: Keys.LAST_USER_SESSION)!)
                            isRecording.toggle()
                        }
                    } label: {
                        if isRecording {
                            Image(systemName: "record.circle.fill")
                                .foregroundColor(.red)
                                .padding()
                                .font(.system(size: 72))
                        }
                        else {
                            Image(systemName: "record.circle")
                                .foregroundColor(.white)
                                .padding()
                                .font(.system(size: 72))
                        }
                    }
                    .padding(.bottom)
                    .alert("Your heart rate measurement has been calculated.", isPresented: $hasProcessingCompleted) {
                        Button("Dismiss", role: .cancel) {
                            dismiss()
                        }
                    }
                }
                if isProcessing {
                    ProgressView {
                        Text("Calculating your heart rate. Please be patient.")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(width: geometry.size.width / 1.5, height: geometry.size.height / 4)
                    .background(Color(UIColor.systemBackground))
                    .foregroundColor(Color(UIColor.label))
                    .cornerRadius(20)
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
            hasProcessingCompleted.toggle()
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
        }
    }
    
}
