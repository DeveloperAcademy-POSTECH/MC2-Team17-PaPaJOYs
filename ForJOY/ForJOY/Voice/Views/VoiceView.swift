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
    // 데이터 관리를 위한 Realm 매니저
    @StateObject var realmManger = RealmManger()
    
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
                        // 녹음 타이머 표시 뷰
                        TimerView(vm: voiceViewModel)
                        
                        Button(action: {
                            // 버튼 클릭 시 다음 화면으로 이동
                            isChoosen = true
                        }, label: {
                            // 녹음이 종료되었고, 현재 녹음 중이 아닐 때 "완료" 버튼 표시
                            if !voiceViewModel.isRecording && voiceViewModel.isEndRecording {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color("JoyWhite"))
                                    .frame(width: screenWidth * 0.9, height: 60)
                                    .overlay(
                                        Text("완료")
                                            .font(.system(size: 16))
                                            .fontWeight(.bold)
                                            .foregroundColor(Color("JoyDarkG"))
                                    )
                            }
                        })
                        .frame(width: 50, height: 50)
                        // 녹음 파일의 URL 값이 변경될 때, recording 변수에 저장
                        .onChange(of: voiceViewModel.recording) { newValue in
                            recording = newValue
                        }
                    }
                    
                    // InfoView로 이동하는 네비게이션 링크
                    NavigationLink(
                        destination: InfoView(selectedImage: $selectedImage, recording: $recording)
                        //                        .navigationBarBackButtonHidden()
                            .environmentObject(realmManger),
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



