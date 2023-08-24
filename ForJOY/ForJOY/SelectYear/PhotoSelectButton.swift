//
//  Ex+PhotoSelectButton.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/08/13.
//

import SwiftUI

struct PhotoSelectButton: View {
    @Binding var memories: [Int: [Memory]]
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
                .sheet(isPresented: $isShowingCameraPicker, onDismiss: { isChoosen.toggle() }) {
                    ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
                        .ignoresSafeArea()
                }
                .sheet(isPresented: $isShowingPhotoLibraryPicker, onDismiss: { isChoosen.toggle() }) {
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
        
        .fullScreenCover(isPresented: $isChoosen, onDismiss: {
            memories = CoreDataManager.coreDM.getYearlyMemories() }) {
            RecordingAndInfoView(selectedImage: $selectedImage)
        }
    }
    
    func loadImage() {
        if let image = selectedImage {
            isChoosen.toggle()
        }
    }
}
