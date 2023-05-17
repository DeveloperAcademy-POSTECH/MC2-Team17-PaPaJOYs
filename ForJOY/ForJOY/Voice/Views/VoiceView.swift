//
//  VoiceView.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/03.
//

import SwiftUI
import PhotosUI

struct VoiceView: View {
    // VoiceViewModel의 인스턴스를 생성하여 관찰합니다.
    @StateObject var voiceViewModel = VoiceViewModel()
    // 삭제 경고 메시지를 보여줄지 여부를 나타내는 상태 변수입니다.
    @State private var showingAlert = false
    // 효과음1을 재생할지 여부를 나타내는 상태 변수입니다.
    @State private var effect1 = false
    // 효과음2을 재생할지 여부를 나타내는 상태 변수입니다.
    @State private var effect2 = false
    @State var recording: URL?
    @State var isButtonOn = false
    
    @State var isShowActionSheet = false
    @State var isShowPhotoPicker = false
    @State private var selectedItem = [PhotosPickerItem]()
    @State private var selectedImage: UIImage?
    @State var isChoosen = false
    @StateObject var realmManger = RealmManger()
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    ZStack {
                        TimerView(vm: voiceViewModel)
                    }
                }
                VStack {
                    Spacer()
                    Button(action: {
                        isShowActionSheet = true
                    }, label: {
                        if !voiceViewModel.isRecording && voiceViewModel.isEndRecording {
                            Text("사진 담기")
                                .foregroundColor(Color("JoyDarkG"))
                                .background(RoundedRectangle(cornerRadius: 12)
                                    .fill(Color("JoyWhite"))
                                    .frame(width: 150, height: 50))
                        }
                    })
                    .frame(width: 400, height: 400)
                    .onChange(of: voiceViewModel.recording) { newValue in
                        recording = newValue
                    }
                    .confirmationDialog("test", isPresented: $isShowActionSheet) {
                        NavigationLink(destination: CameraView(recording: $recording), label: {
                            Button(action: {
                                
                            }, label: {
                                Text("사진 찍으러 가기")
                                    .foregroundColor(Color("JoyBlue"))
                            })
                            .background(Color("JoyWhite"))
                        })
                        
                        
                        Button(action: {
                            isShowPhotoPicker.toggle()
                        }, label: {
                            Text("사진 고르러 가기")
                                .foregroundColor(Color("JoyBlue"))
                        })
                        .background(Color("JoyWhite"))
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
