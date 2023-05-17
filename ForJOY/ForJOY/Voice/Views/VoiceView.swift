//
//  VoiceView.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/03.
//

import SwiftUI
import PhotosUI

struct VoiceView: View {
    @StateObject var voiceViewModel = VoiceViewModel()
    @StateObject var realmManger = RealmManger()
    
    @State private var showingAlert = false
    @State private var effect1 = false
    @State private var effect2 = false
    @State var recording: URL?
    @State var isButtonOn = false
    @State var isShowActionSheet = false
    @State var isShowPhotoPicker = false
    @State private var selectedItem = [PhotosPickerItem]()
    @State private var selectedImage: UIImage?
    @State var isChoosen = false
    @State var isHiddentButton = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                TimerView(vm: voiceViewModel)
                VStack {
                    Spacer()
                    Button(action: {
                        isShowActionSheet = true
                        isHiddentButton = true
                    }, label: {
                        if !voiceViewModel.isRecording && voiceViewModel.isEndRecording && !isHiddentButton{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color("JoyWhite"))
                                .frame(width: screenWidth * 0.9, height: 60)
                                .overlay(
                                    Text("사진 담기")
                                        .font(.system(size: 16))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("JoyDarkG"))
                                )
                        }
                    })
                    .frame(width: 400, height: 250)
                    .onChange(of: voiceViewModel.recording) { newValue in
                        recording = newValue
                    }
                    .confirmationDialog("test", isPresented: $isShowActionSheet) {
                        NavigationLink(destination: CameraView(recording: $recording), label: {
                            Button(action: {
                                isHiddentButton = false
                            }, label: {
                                Text("사진 찍으러 가기")
                                    .foregroundColor(Color("JoyBlue"))
                            })
                            .background(Color("JoyWhite"))
                        })
                        .onAppear(){
                            isHiddentButton = false
                        }
                        
                        Button(action: {
                            isShowPhotoPicker.toggle()
                            isHiddentButton = false
                        }, label: {
                            Text("사진 고르러 가기")
                                .foregroundColor(Color("JoyBlue"))
                        })
                        .background(Color("JoyWhite"))
                        
                        
                        Button(role: .cancel, action: {
                            isHiddentButton = false
                        }, label: {
                            Text("Cancel")
                        })
                    }
                    .photosPicker(
                        isPresented: $isShowPhotoPicker,
                        selection: $selectedItem,
                        maxSelectionCount: 1,
                        matching: .images
                    )
                    .preferredColorScheme(.dark)
                    .tint(Color("JoyBlue"))
                    .onChange(of: selectedItem) { newValue in
                        guard let item = selectedItem.first else { return }
                        item.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let data):
                                if let data = data {
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
                }

                NavigationLink(
                    destination: InfoView(selectedImage: $selectedImage, recording: $recording)
                        .navigationBarBackButtonHidden()
                        .environmentObject(realmManger)
                        .environmentObject(voiceViewModel)
                    ,
                    isActive: $isChoosen
                ){}
                .isDetailLink(false)
            }
        }
        
    }
}
