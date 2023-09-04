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
    let didFinishRecordingTo: (Result<URL, Error>) -> ()
    
    func makeUIViewController(context: Context) -> UIViewController {
        // Starting the camera service
        cameraService.startSession(delegate: context.coordinator) { error in
            if let error = error {
                didFinishRecordingTo(.failure(error))
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
        coordinator.parent.cameraService.stopSession()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, didFinishRecordingTo: didFinishRecordingTo)
    }
    
    class Coordinator: NSObject, AVCaptureFileOutputRecordingDelegate {
        let parent: CameraPreviewView
        private let didFinishRecordingTo: (Result<URL, Error>) -> ()
        
        init(_ parent: CameraPreviewView, didFinishRecordingTo: @escaping (Result<URL, Error>) -> ()) {
            self.parent = parent
            self.didFinishRecordingTo = didFinishRecordingTo
        }
        
        func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
            if let error = error {
                didFinishRecordingTo(.failure(error))
                return
            }
            didFinishRecordingTo(.success(outputFileURL))
        }
        
    }
    
}
