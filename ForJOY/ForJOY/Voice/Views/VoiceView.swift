//
//  VoiceView.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/03.
//

import SwiftUI

struct VoiceView: View {
    
    // VoiceViewModel의 인스턴스를 생성하여 관찰합니다.
    @ObservedObject var vm = VoiceViewModel()
    // 녹음 파일 리스트를 보여줄지 여부를 나타내는 상태 변수입니다.
    @State private var showingList = false
    // 삭제 경고 메시지를 보여줄지 여부를 나타내는 상태 변수입니다.
    @State private var showingAlert = false
    // 효과음1을 재생할지 여부를 나타내는 상태 변수입니다.
    @State private var effect1 = false
    // 효과음2을 재생할지 여부를 나타내는 상태 변수입니다.
    @State private var effect2 = false
    
    
    var body: some View {
        
        ZStack{
            VStack{
                HStack{
                    Button(action: {
                        if vm.isRecording == true {
                            vm.stopRecording()
                        }
                        vm.fetchAllRecording()
                        showingList.toggle()
                    }) {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.black)
                            .font(.system(size: 20, weight: .bold))
                    }.sheet(isPresented: $showingList, content: {
                        recordingListView()
                    })
                }
                if vm.isRecording {
                    
                    VStack(alignment : .leading , spacing : -5){
                        HStack (spacing : 3) {
                            Image(systemName: vm.isRecording && vm.toggleColor ? "circle.fill" : "circle")
                                .font(.system(size:10))
                                .foregroundColor(.red)
                            Text("Rec")
                        }
                        Text(vm.timer)
                            .font(.system(size:60))
                            .foregroundColor(.black)
                    }
                }
                ZStack {
                    Image(systemName: vm.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .foregroundColor(.black)
                        .font(.system(size: 45))
                        .onTapGesture {
                            if vm.isRecording == true {
                                vm.stopRecording()
                            } else {
                                vm.startRecording()
                            }
                        }
                }
            }
        }
    }
}
struct VoiceView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceView()
    }
}
