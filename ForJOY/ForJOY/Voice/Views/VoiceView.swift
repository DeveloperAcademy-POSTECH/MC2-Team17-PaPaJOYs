//
//  VoiceView.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/03.
//

import SwiftUI


struct VoiceView: View {
    
//    @EnvironmentObject var GlobalStore: globalStore
    // VoiceViewModel의 인스턴스를 생성하여 관찰합니다.
    @StateObject var vm = VoiceViewModel()
    // 녹음 파일 리스트를 보여줄지 여부를 나타내는 상태 변수입니다.
//    @State private var shoWarningList = false
    // 삭제 경고 메시지를 보여줄지 여부를 나타내는 상태 변수입니다.
    @State private var showingAlert = false
    // 효과음1을 재생할지 여부를 나타내는 상태 변수입니다.
    @State private var effect1 = false
    // 효과음2을 재생할지 여부를 나타내는 상태 변수입니다.
    @State private var effect2 = false
    
//    @State var decibels: CGFloat = 0
    
    var body: some View {
        
        // ZStack을 사용하여 뷰를 겹칩니다.
        ZStack{
            
            VStack{
                
                // DecibelView를 추가합니다.
//                DecibelView(decibels: $decibels)
                

                
//
                ZStack {
                    
                    
                    TimerView(vm: vm)

                    
                    
//                    Image(systemName: vm.isRecording ? "stop.circle.fill" : "mic.circle.fill")
//                        .foregroundColor(.black)
//                        .font(.system(size: 45))
//                        .onTapGesture {
//                            if vm.isRecording == true {
//                                vm.stopRecording()
//                            } else {
//                                vm.startRecording()
//                            }
//                        }
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
