//
//  CameraService.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 9/3/23.
//

import Foundation
import AVFoundation

class CameraService: ObservableObject {
    
    private var session: AVCaptureSession?
    private var delegate: AVCaptureFileOutputRecordingDelegate?
    
    private let output = AVCaptureMovieFileOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    func startSession(delegate: AVCaptureFileOutputRecordingDelegate, completion: @escaping (Error?) -> ()) -> Void {
        self.delegate = delegate
        setupCamera(completion: completion)
    }
    
    func stopSession() -> Void {
        if let running = session?.isRunning {
            if running {
                DispatchQueue.global(qos: .background).async {
                    self.session?.removeOutput(self.output)
                    self.session?.stopRunning()
                }
            }
        }
    }
    
    func startRecording(sessionId: String) -> Void {
        if output.isRecording {
            return
        }
        let filePath = NSTemporaryDirectory() + "\(sessionId).mov"
        output.startRecording(to: URL(filePath: filePath), recordingDelegate: delegate!)
    }
    
    func stopRecording() -> Void {
        if !output.isRecording {
            return
        }
        output.stopRecording()
    }
    
    private func setupCamera(completion: @escaping (Error?) -> ()) -> Void {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCaptureSession(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCaptureSession(completion: completion)
        @unknown default:
            break
        }
    }
    
    private func setupCaptureSession(completion: @escaping (Error?) -> ()) -> Void {
        let session = AVCaptureSession()
        
        // Hardcoding reduced video quality preset
        session.sessionPreset = AVCaptureSession.Preset.vga640x480
        
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) && session.canAddOutput(output) {
                    session.addInput(input)
                    session.addOutput(output)
                }

                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                // Running session on a background thread as recommended
                DispatchQueue.global(qos: .background).async {
                    session.startRunning()
                }
                self.session = session
                
            } catch {
                completion(error)
            }
        }
    }
    
}
