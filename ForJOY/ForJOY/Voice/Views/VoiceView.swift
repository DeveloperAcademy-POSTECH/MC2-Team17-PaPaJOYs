//
//  VoiceView.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/03.
//

import SwiftUI


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
                    }, label: {
                        NavigationLink(
                            destination: CameraView(recording: $recording)
                        ) {
                            if !voiceViewModel.isRecording && voiceViewModel.isEndRecording {
                                Text("사진 고르러 가기")
                                    .foregroundColor(Color("JoyDarkG"))
                                    .background(RoundedRectangle(cornerRadius: 12)
                                        .fill(Color("JoyWhite"))
                                        .frame(width: 150, height: 50))
                            }
                        }
                        .isDetailLink(false)
                    })
                    .onChange(of: voiceViewModel.recording) { newValue in
                        recording = newValue
                    }
                }
                .frame(width: 400, height: 400)
            }
        }
    }
}
