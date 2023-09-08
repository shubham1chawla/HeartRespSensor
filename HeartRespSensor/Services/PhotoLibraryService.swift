//
//  PhotoLibraryService.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 9/8/23.
//

import Foundation
import Photos
import SwiftUI

class PhotoLibraryService: ObservableObject {
    
    func saveVideo(for videoUrl: URL, deleteAfterSave: Bool = true) -> Void {
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
            if deleteAfterSave {
                try? FileManager.default.removeItem(at: videoUrl)
            }
        }
    }
    
}
