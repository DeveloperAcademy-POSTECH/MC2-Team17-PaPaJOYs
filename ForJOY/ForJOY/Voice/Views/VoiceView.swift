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

    var body: some View {
        // ZStack을 사용하여 뷰를 겹칩니다.
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
                        Text("임시버튼")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("JoyWhite"))
                    }
                    .isDetailLink(false)
                })
                .onChange(of: voiceViewModel.recording) { newValue in
                    recording = newValue
                }
            }
        }
    }

}
