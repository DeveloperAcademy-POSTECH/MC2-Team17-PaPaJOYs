//
//  CameraViewModel.swift
//  ForJOY
//
//  Created by Nayeon Kim on 2023/05/04.
//

//import SwiftUI
//import AVFoundation
//import Combine
//import PhotosUI
//
//class CameraViewModel: ObservableObject {
//    private let model: Camera
//    private let session: AVCaptureSession
//    private var subscriptions = Set<AnyCancellable>()
//    private var isCamreaBusy = false
//    
//    let cameraPreview: AnyView
//    let hapticImpact = UIImpactFeedbackGenerator()
//    
//    var images: [UIImage] = []
//    var currentZoomFactor: CGFloat = 1.0
//    var lastScale: CGFloat = 1.0
//    
//    @Published var shutterEffect = false
//    @Published var recentImage: UIImage?
//    @Published var isFlashOn = false
//    @Published var isSilentModeOn = false
//    
//    func configure() {
//        model.requestAndCheckCameraPermissions()
//        self.requestAndGetLibraryPreview()
//    }
//    
//    func requestAndGetLibraryPreview() {
//        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
//            if status == .authorized {
//                let fetchOptions = PHFetchOptions()
//                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//                fetchOptions.fetchLimit = 1
//                
//                let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
//                
//                if let asset = fetchResult.firstObject {
//                    let requestOptions = PHImageRequestOptions()
//                    requestOptions.deliveryMode = .fastFormat
//                    requestOptions.isSynchronous = true
//                    
//                    PHImageManager.default().requestImage(for: asset, targetSize: UIScreen.main.bounds.size, contentMode: .aspectFit, options: requestOptions) { image, _ in
//                        self.recentImage = image
//                    }
//                }
//            }
//        }
//    }
//    
//    func switchFlash() {
//        isFlashOn.toggle()
//        model.flashMode = isFlashOn == true ? .on : .off
//    }
//    
//    func switchSilent() {
//        isSilentModeOn.toggle()
//        model.isSilentModeOn = isSilentModeOn
//    }
//    
//    func capturePhoto() {
//        if isCamreaBusy == false {
//            hapticImpact.impactOccurred()
//            withAnimation(.easeInOut(duration: 0.1)) {
//                shutterEffect = true
//            }
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                withAnimation(.easeInOut(duration: 0.1)) {
//                    self.shutterEffect = false
//                }
//            }
//            
//            model.capturePhoto()
//            
//            print("[CameraViewModel]: Photo captured!")
//        } else {
//            print("[CameraViewModel]: Camera's busy.")
//        }
//    }
//    
//    func zoom(factor: CGFloat) {
//        let delta = factor / lastScale
//        lastScale = factor
//        
//        let newScale = min(max(currentZoomFactor * delta, 1), 5)
//        model.zoom(newScale)
//        currentZoomFactor = newScale
//    }
//    
//    func zoomInitialize() {
//        lastScale = 1.0
//    }
//    
//    func changeCamera() {
//        model.changeCamera()
//        print("[CameraViewModel]: Camera changed!")
//    }
//    
//    func stopSession() {
//        model.session.stopRunning()
//        print("[CameraViewModel]: Camera stop!")
//    }
//    
//    init() {
//        model = Camera()
//        session = model.session
//        cameraPreview = AnyView(CameraPreviewView(session: session))
//        
//        model.$recentImage.sink { [weak self] (photo) in
//            guard let pic = photo else { return }
//            self?.recentImage = pic
//        }
//        .store(in: &self.subscriptions)
//
//        model.$isCameraBusy.sink { [weak self] (result) in
//            self?.isCamreaBusy = result
//        }
//        .store(in: &self.subscriptions)
//    }
//}
