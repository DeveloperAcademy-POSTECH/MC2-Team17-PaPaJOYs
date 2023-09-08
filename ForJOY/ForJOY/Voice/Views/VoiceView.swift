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
    @Environment(\.dismiss) private var dismiss
    // 목소리 녹음과 관련된 뷰 모델
    @StateObject var voiceViewModel = VoiceViewModel()
    
    // 효과 상태 (현재 사용되지 않음)
    //@State private var effect1 = false
    //@State private var effect2 = false
    
    // 선택된 이미지 (부모 뷰에서 전달 받을 값)
    @Binding var selectedImage: UIImage?
    // 녹음 파일의 URL
    @Binding var recording: URL?
    @Binding var pageNumber: Int
    
    let padding = UIScreen.height/844
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.joyDarkG
                    .ignoresSafeArea()
               
                VStack {
                    // 중앙에 이미지 표시
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(CGSize(width: 3, height: 4), contentMode: .fill)
                            .frame(width: 350*padding, height: 466*padding)
                            .clipped()
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                    }
                    
                    SoundVisualizer()
                        .frame(width: 217*padding, height: 35*padding)
                        .opacity(voiceViewModel.isRecording && !voiceViewModel.isEndRecording ? 1 : 0)
                        .offset(y: voiceViewModel.isRecording && !voiceViewModel.isEndRecording ? 0 : -50)
                        .animation(.easeInOut(duration: 0.5))
                        .padding(.bottom, 20*padding)
                    
                    // 녹음 타이머 표시 뷰
                    TimerView(vm: voiceViewModel, recording: $recording, pageNumber: $pageNumber)
                        .frame(width: 57*padding, height: 94*padding)
                    // 녹음 파일의 URL 값이 변경될 때, recording 변수에 저장
                        .onChange(of: voiceViewModel.recording) { newValue in
                            recording = newValue
                        }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton)
        }
    }
    
    private var BackButton: some View {
        Button {
            dismiss()
        } label: {
            Text("작성 취소")
                .foregroundColor(.joyBlueL)
        }
    }
}
