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
    @Environment(\.presentationMode) var presentationMode
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
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text("Cancel")
                            })
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
    }
}
