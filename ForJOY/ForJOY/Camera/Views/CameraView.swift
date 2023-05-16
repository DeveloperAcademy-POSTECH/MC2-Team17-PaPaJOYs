//
//  CameraView.swift
//  ForJOY
//
//  Created by Nayeon Kim on 2023/05/04.
//

import SwiftUI
import AVFoundation
import Combine
import PhotosUI

struct CameraView: View {
    @ObservedObject var viewModel = CameraViewModel()
    @StateObject var realmManger = RealmManger()
    @StateObject var voiceViewModel = VoiceViewModel()
    @State var selectedItem: [PhotosPickerItem] = []
    @State var data: Data?
    @State var selectedImage: UIImage?
    @State var isChoosen = false
    @State var isTaken = false
    
    @Binding var recording: URL?
    
    var body: some View {
        NavigationStack {
            ZStack {
                viewModel.cameraPreview
                    .ignoresSafeArea()
                    .onAppear {
                        viewModel.configure()
                    }
                    .gesture(MagnificationGesture()
                        .onChanged { val in
                            viewModel.zoom(factor: val)
                        }
                        .onEnded { _ in
                            viewModel.zoomInitialize()
                        }
                    )
                VStack {
                    ZStack {
                        Rectangle()
                            .fill(Color("JoyDarkG"))
                            .ignoresSafeArea()
                            .frame(height: 100)
                            .opacity(0.5)
                        HStack {
                            Button(action: {viewModel.switchFlash()}) {
                                Image(systemName: viewModel.isFlashOn ? "bolt.fill" : "bolt")
                                    .foregroundColor(viewModel.isFlashOn ? Color("JoyYellow") : .white)
                            }
                            .padding(.horizontal, 20)
                            
                            Button(action: {viewModel.switchSilent()}) {
                                Image(systemName: viewModel.isSilentModeOn ? "bell.slash" : "bell")
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 20)
                        }
                        .font(.system(size: 25))
                        .padding()
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .fill(Color("JoyDarkG"))
                            .ignoresSafeArea()
                            .frame(height: 130)
                            .opacity(0.5)
                        HStack {
                            // 미리보기 -> 갤러리
                            PhotosPicker(selection: $selectedItem, maxSelectionCount: 1, matching: .images) {
                                if let previewImage = viewModel.recentImage {
                                    Image(uiImage: previewImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 65, height: 65)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .aspectRatio(1, contentMode: .fit)
                                        .padding()
                                } else {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(lineWidth:  3)
                                        .foregroundColor(.white)
                                        .frame(width: 65, height: 65)
                                }
                            }
                            .preferredColorScheme(.dark)
                            .tint(Color("JoyBlue"))
                            
                            .onChange(of: selectedItem) { newValue in
                                guard let item = selectedItem.first else { return }
                                item.loadTransferable(type: Data.self) { result in
                                    switch result {
                                    case .success(let data):
                                        if let data = data {
                                            self.data = data
                                            selectedImage = UIImage(data: data)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                isChoosen = true
                                            }
                                        } else {
                                            print("Data is nill!")
                                        }
                                    case .failure(let failure):
                                        fatalError("\(failure)")
                                    }
                                }
                            }
                            .frame(width: 100, height: 100)
                            
                            Spacer()
                            Button(action: {
                                viewModel.capturePhoto()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    isTaken = true
                                }
                            }) {
                                Image(systemName: "button.programmable")
                                    .resizable()
                                    .font(.system(size: 16, weight: .thin))
                                    .frame(width: 85, height: 85)
                            }.frame(width: 100, height: 100)
                            
                            Spacer()
                            
                            Button(action: {viewModel.changeCamera()}) {
                                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                                    .resizable()
                                    .font(.system(size: 16, weight: .light))
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .padding()
                            }
                            .frame(width: 100, height: 100)
                            
                            NavigationLink(
                                destination: InfoView(selectedImage: $selectedImage, recording: $recording)
                                    .navigationBarBackButtonHidden()
                                    .environmentObject(realmManger)
                                    .environmentObject(voiceViewModel)
                                    .environmentObject(viewModel)
                                ,
                                isActive: $isTaken
                            ){}
                                .isDetailLink(false)
                                .onChange(of: viewModel.recentImage) { newValue in
                                    selectedImage = newValue
                                }
                            
                            NavigationLink(
                                destination: InfoView(selectedImage: $selectedImage, recording: $recording)
                                    .navigationBarBackButtonHidden()
                                    .environmentObject(realmManger)
                                    .environmentObject(voiceViewModel)
                                    .environmentObject(viewModel)
                                ,
                                isActive: $isChoosen
                            ){}
                                .isDetailLink(false)
                        }
                    }
                    
                }
                
                .foregroundColor(.white)
            }
            .background(Color("JoyDarkG"))
            .opacity(viewModel.shutterEffect ? 0 : 1)
            .navigationBarBackButtonHidden()
//            .onDisappear() {
//                viewModel.stopSession()
//            }
        }
    }
}

struct CameraPreviewView: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
    
        view.backgroundColor = .black
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.connection?.videoOrientation = .portrait
        
        return view
    }
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        //지우면 안됨
    }
}
