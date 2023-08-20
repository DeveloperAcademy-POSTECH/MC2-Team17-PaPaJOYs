//
//  Ex+PhotoSelectButton.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/08/13.
//

import SwiftUI
import PhotosUI


struct PhotoSelectButton: View {
    @State private var isShowActionSheet = false
    @State private var selectedImage: UIImage?
    @State private var isShowingActionSheet = false
    @State private var isShowingCameraPicker = false
    @State private var isShowingPhotoLibraryPicker = false
    @State private var isChoosen = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                LinearGradient(colors: [Color("JoyDarkG").opacity(0), Color("JoyDarkG")], startPoint: .top, endPoint: .bottom)
                
                Button(action: {
                    isShowActionSheet = true
                }, label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("JoyYellow"))
                        .frame(height: screenHeight * 0.065)
                        .overlay {
                            HStack {
                                Image(systemName: "plus")
                                Text("새로운 추억 기록하기")
                            }
                            .foregroundColor(Color("JoyDarkG"))
                            .fontWeight(.bold)
                            .font(.headline)
                        }
                        .padding(.horizontal, 20)
                })
                .confirmationDialog("photo", isPresented: $isShowActionSheet) {
                    Button(action: {
                        isShowingCameraPicker = true
                    }, label: {
                        Text("사진 찍으러 가기")
                            .foregroundColor(Color("JoyBlue"))
                    })
                    .background(Color("JoyWhite"))

                    Button(action: {
                        isShowingPhotoLibraryPicker = true
                    }, label: {
                        Text("사진 고르러 가기")
                            .foregroundColor(Color("JoyBlue"))
                    })
                    .background(Color("JoyWhite"))
                    
                    Button(role: .cancel, action: {
                    }, label: {
                        Text("Cancel")
                    })
                }
                .sheet(isPresented: $isShowingCameraPicker, onDismiss: loadImage) {
                    ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
                        .ignoresSafeArea()
                }
                .sheet(isPresented: $isShowingPhotoLibraryPicker, onDismiss: loadImage) {
                    ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
                        .ignoresSafeArea()
                        .tint(Color("JoyBlue"))
                }
            }
            
            Rectangle()
                .foregroundColor(Color("JoyDarkG"))
                .frame(height: screenHeight * 0.04)
        }
        .frame(height: screenHeight * 0.15)
        
        .fullScreenCover(isPresented: $isChoosen) {
            RecordingAndInfoView(selectedImage: $selectedImage)
        }
    }
    
    func loadImage() {
        if let image = selectedImage {
            saveImage(image)    // -> 재녹음 할 때 마다 이미지 쌓일지도..?!
            isChoosen.toggle()
        }
    }
    func saveImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        let folderName = "ForJoy"
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", folderName)
        let folders = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)
        
        if let folder = folders.firstObject {
            // Folder found, save the image to the folder
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: imageData, options: nil)
                let placeholder = creationRequest.placeholderForCreatedAsset
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: folder)
                albumChangeRequest?.addAssets([placeholder] as NSFastEnumeration)
            } completionHandler: { _, _ in
                // Image saved successfully to the folder
            }
        } else {
            PHPhotoLibrary.shared().performChanges {
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: folderName)
            } completionHandler: { success, error in
                if success {
                    let fetchOptions = PHFetchOptions()
                    fetchOptions.predicate = NSPredicate(format: "title = %@", folderName)
                    let createdFolders = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)
                    if let createdFolder = createdFolders.firstObject {
                        let creationRequest = PHAssetCreationRequest.forAsset()
                        creationRequest.addResource(with: .photo, data: imageData, options: nil)
                        let placeholder = creationRequest.placeholderForCreatedAsset
                        let albumChangeRequest = PHAssetCollectionChangeRequest(for: createdFolder)
                        albumChangeRequest?.addAssets([placeholder] as NSFastEnumeration)
                    }
                } else {
                }
            }
        }
    }
}

