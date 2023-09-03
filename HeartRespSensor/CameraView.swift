//
//  CameraView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 9/3/23.
//

import SwiftUI

struct CameraView: View {
    
    let cameraService = CameraService()
    @State private var capturedImage: UIImage?
    
    var body: some View {
        ZStack {
            CameraPreviewView(cameraService: cameraService) { result in
                switch result {
                case .success(let photo):
                    if let data = photo.fileDataRepresentation() {
                        capturedImage = UIImage(data: data)
                        print("Captured Image: \(capturedImage.hashValue)")
                    } else {
                        print("Error: No image data found!")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            VStack {
                Spacer()
                Button {
                    cameraService.capturePhoto()
                } label: {
                    Image(systemName: "circle")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .padding(.bottom)
            }
        }
    }
}
