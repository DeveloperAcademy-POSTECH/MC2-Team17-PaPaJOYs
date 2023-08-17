//
//  VoiceView.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/03.
//

import SwiftUI
import PhotosUI

// 사용자의 목소리 녹음 기능을 제공하는 뷰
struct VoiceView: View {
    // 목소리 녹음과 관련된 뷰 모델
    @StateObject var voiceViewModel = VoiceViewModel()
    
    // 효과 상태 (현재 사용되지 않음)
    @State private var effect1 = false
    @State private var effect2 = false
    // 녹음 파일의 URL
    @State var recording: URL?
    // 다음 화면으로 이동하기 위한 상태 변수
    @State var isChoosen = false
    
    // 선택된 이미지 (부모 뷰에서 전달 받을 값)
    @Binding var selectedImage: UIImage?
    
    @State private var isBackButtonPressed = false // 이 상태 변수를 추가합니다.
    
    
    
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("JoyDarkG")
                    .ignoresSafeArea()
                ZStack{
                    VStack {
                        
                        // 중앙에 이미지 표시
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 350, height: 466)
                                .clipped()
                                .cornerRadius(10)
                        }
                        
                        Image("Waves")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 218, height: 35)
                            .clipped()
                            .padding(.top, 30)
                        
                        ZStack{
                            
                            // 녹음 타이머 표시 뷰
                            TimerView(vm: voiceViewModel)
                            
                            
                            
                            
                            if !voiceViewModel.isRecording && voiceViewModel.isEndRecording {
                                Button(action: {
                                    isChoosen = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        
                                        // 여기에 InfoView로의 네비게이션 코드를 추가
                                    }
                                }, label: {
                                    ZStack {
                                        Circle()
                                            .fill(Color("JoyBlue"))
                                            .frame(width: 57)
                                        
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .frame(width: 22, height: 22)
                                            .foregroundColor(Color("JoyDarkG"))
                                    }
                                })
                                .frame(width: 50, height: 50)
                                // 녹음 파일의 URL 값이 변경될 때, recording 변수에 저장
                                .onChange(of: voiceViewModel.recording) { newValue in
                                    recording = newValue
                                }
                            }
                        }
                    }
                    
                    NavigationLink(
                        destination: InfoView(selectedImage: $selectedImage, recording: $recording)
                            .navigationBarBackButtonHidden(),
                        //                        .environmentObject(realmManger),
                        isActive: $isChoosen
                    ){}
                        .isDetailLink(false)
                    
                    // 뒤로가기 버튼을 위한 네비게이션 링크
                    NavigationLink(
                        destination: SelectYearView(),
                        isActive: $isBackButtonPressed
                    ) {
                        EmptyView()
                    }
                }
                .padding(.top, 95)
                
                
                .navigationBarBackButtonHidden(true)
                .navigationTitle("")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            isBackButtonPressed = true  // 버튼 클릭 시 상태 변수를 true로 설정
                        }) {
                            HStack {
                                Image(systemName: "chevron.backward")
                                    .foregroundColor(Color("JoyBlue"))
                                    .padding(.top, 65)
                                Text("사진 선택")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("JoyBlue"))
                                    .padding(.top, 65)
                                
                            }
                        }
                    }
                }
            }
        }
    }
}
