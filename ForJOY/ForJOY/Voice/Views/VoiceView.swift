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
        
        // ZStack을 사용하여 뷰를 겹칩니다.
        ZStack{
            VStack{
                
                // DecibelView를 추가합니다.
                DecibelView()
                
                // 녹음 파일 목록을 표시하는 버튼을 추가합니다.
                HStack{
//                    Button(action: {
//                        if vm.isRecording == true {
//                            // 녹음 중일 경우 중지합니다.
//                            vm.stopRecording()
//                        }
//                        // 녹음 파일 리스트를 가져옵니다.
//                        vm.fetchAllRecording()
//                        // 녹음 파일 목록을 표시하는 상태를 토글합니다.
//                        showingList.toggle()
//                    }) {
//                        Image(systemName: "list.bullet")
//                            .foregroundColor(.black)
//                            .font(.system(size: 20, weight: .bold))
//                    }
//                    // 녹음 파일 목록을 표시하는 sheet을 추가합니다.
//                    .sheet(isPresented: $showingList, content: {
//                        recordingListView()
//                    })
                }
                
                // 녹음 중인 경우 녹음 시간을 표시합니다.
                if vm.isRecording {
                    VStack(alignment : .leading , spacing : -5){
                        HStack (spacing : 3) {
                            // 녹음 중인 경우 빨간색으로 채워진 동그라미를 표시합니다.
                            Image(systemName: vm.isRecording && vm.toggleColor ? "circle.fill" : "circle")
                                .font(.system(size:10))
                                .foregroundColor(.red)
                            Text("Rec")
                        }
                        // 녹음 시간을 표시합니다.
                        Text(vm.timer)
                            .font(.system(size:60))
                            .foregroundColor(.black)
                    }
                }
                // 녹음 중인지 여부에 따라 다른 이미지를 표시하는 버튼을 추가합니다.
                // 버튼을 탭하면 녹음을 시작하거나 중지합니다.
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
