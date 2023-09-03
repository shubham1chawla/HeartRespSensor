//
//  CameraPreviewView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 9/3/23.
//

import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    let cameraService: CameraService
    let didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
    
    func makeUIViewController(context: Context) -> UIViewController {
        // Starting the camera service
        cameraService.start(delegate: context.coordinator) { error in
            if let error = error {
                didFinishProcessingPhoto(.failure(error))
                return
            }
        }
        
        let viewController = UIViewController()
        
        // Setting up camera view
        viewController.view.backgroundColor = .black
        viewController.view.layer.addSublayer(cameraService.previewLayer)
        cameraService.previewLayer.frame = viewController.view.bounds
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Left empty intentionally
    }
    
    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: Coordinator) {
        // Stopping the camera service
        coordinator.parent.cameraService.stop()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, didFinishProcessingPhoto: didFinishProcessingPhoto)
    }
    
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        let parent: CameraPreviewView
        private let didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
        
        init(_ parent: CameraPreviewView, didFinishProcessingPhoto: @escaping (Result<AVCapturePhoto, Error>) -> ()) {
            self.parent = parent
            self.didFinishProcessingPhoto = didFinishProcessingPhoto
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let error = error {
                didFinishProcessingPhoto(.failure(error))
                return
            }
            didFinishProcessingPhoto(.success(photo))
        }
        
    }
    
}
