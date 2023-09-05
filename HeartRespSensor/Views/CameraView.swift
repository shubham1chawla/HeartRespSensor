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
    
    private let cameraService = CameraService()
    private let defaults = UserDefaults.standard
    
    @State private var isRecording = false
    @State private var showSavedAlert = false
    
    var body: some View {
        ZStack {
            CameraPreviewView(cameraService: cameraService) { result in
                switch result {
                case .success(let videoUrl):
                    saveVideoToPhotos(videoUrl: videoUrl)
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
                .alert("Your recording has been saved.", isPresented: $showSavedAlert) {
                    Button("Dismiss", role: .cancel) {
                        dismiss()
                    }
                }
                .navigationTitle("Heart Rate")
            }
        }
    }
    
    private func saveVideoToPhotos(videoUrl: URL) -> Void {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)
        }) { saved, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if !saved {
                print("Error: Unable to save the video!")
                return
            }
            showSavedAlert.toggle()
        }
    }
    
}
