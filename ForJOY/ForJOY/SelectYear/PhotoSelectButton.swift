//
//  Ex+PhotoSelectButton.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/08/13.
//

import SwiftUI

struct PhotoSelectButton: View {
    @Binding var memories: [Int: [Memory]]
    @Binding var tags: [String]
    
    @State private var isShowActionSheet = false
    @State private var selectedImage: UIImage?
    @State private var croppedImage: UIImage?
    @State private var isShowingActionSheet = false
    @State private var isShowingCameraPicker = false
    @State private var isShowingPhotoLibraryPicker = false
    @State private var showCropView = false
    @State private var isChoosen = false
    @State private var showRecordingAndInfoView = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                LinearGradient(colors: [Color.joyDarkG.opacity(0), Color.joyDarkG], startPoint: .top, endPoint: .bottom)
                
                Button {
                    isShowActionSheet = true
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("새로운 추억 기록하기")
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.joyDarkG)
                    .font(Font.body1Kor)
                    .padding(.vertical, 18)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.joyYellow)
                    }
                    .padding(.horizontal, 16)
                }
                .confirmationDialog("photo", isPresented: $isShowActionSheet) {
                    Button(action: {
                        isShowingCameraPicker = true
                    }, label: {
                        Text("사진 촬영")
                            .foregroundColor(Color.joyBlue)
                    })
                    .background(Color.joyWhite)

                    Button(action: {
                        isShowingPhotoLibraryPicker = true
                    }, label: {
                        Text("사진 선택")
                            .foregroundColor(Color.joyBlue)
                    })
                    .background(Color.joyWhite)
                    
                    Button(role: .cancel, action: {
                    }, label: {
                        Text("Cancel")
                    })
                }
                .fullScreenCover(isPresented: $isShowingCameraPicker, onDismiss: { isChoosen.toggle() }) {
                    ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
                        .ignoresSafeArea()
                }
                .sheet(isPresented: $isShowingPhotoLibraryPicker, onDismiss: { isChoosen.toggle() }) {
                    ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
                        .ignoresSafeArea()
                        .tint(Color.joyBlue)
                        .preferredColorScheme(.dark)
                }
                .sheet(isPresented: $showCropView) {
                    showCropView = false
                    isShowingPhotoLibraryPicker = false
                    isShowingCameraPicker = false
                    showRecordingAndInfoView.toggle()
                } content: {
                    CropView(image:selectedImage, showCropView: $showCropView) { croppedImage, status in
                        if let croppedImage {
                            self.croppedImage = croppedImage
                        }
                    }
                }
            }
            
            Rectangle()
                .foregroundColor(Color.joyDarkG)
                .frame(height: UIScreen.height * 0.04)
        }
        .frame(height: UIScreen.height * 0.15)
        .onChange(of: selectedImage) { _ in
            showCropView.toggle()
        }
        .fullScreenCover(isPresented: $showRecordingAndInfoView, onDismiss: { updateData() }) {
            RecordingAndInfoView(selectedImage: $croppedImage)
        }
    }
    
    func updateData() {
        tags = CoreDataManager.coreDM.getUniqueTags()
        memories = CoreDataManager.coreDM.getYearlyMemories()
    }
}
