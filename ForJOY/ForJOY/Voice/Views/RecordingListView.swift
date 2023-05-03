//
//  RecordingListView.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/03.
//

import SwiftUI

struct recordingListView: View {
    
    // 녹음 목록을 보유하고 재생 및 삭제를 관리하는 ObservedObject
    @ObservedObject var vm = VoiceViewModel()

    var body: some View {
        
        // 네비게이션 기능을 제공하기 위한 NavigationView
        NavigationView {
            
            // 녹음 목록을 보유하기 위한 수직 스택
            VStack {
                
                // 녹음 목록을 담을 수 있는 스크롤 가능한 뷰
                ScrollView(showsIndicators: false){
                    
                    // 녹음 목록을 순회하기 위한 ForEach 루프
                    ForEach(vm.recordingsList, id: \.createdAt) { recording in
                        
                        // 녹음 정보를 담을 수 있는 수직 스택
                        VStack{
                            
                            // 이미지와 녹음 파일 이름을 담을 수 있는 수평 스택
                            HStack{
                                Image(systemName:"headphones.circle.fill")
                                    .font(.system(size:50))
                                
                                VStack(alignment:.leading) {
                                    Text("\(recording.fileURL.lastPathComponent)")
                                }
                                
                                // 삭제 및 재생/정지 버튼을 담을 수 있는 수직 스택
                                VStack {
                                    
                                    // 녹음 파일 삭제 버튼
                                    Button(action: {
                                        vm.deleteRecording(url:recording.fileURL)
                                    }) {
                                        Image(systemName:"xmark.circle.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size:15))
                                    }
                                    
                                    // Spacer를 사용하여 재생/정지 버튼을 아래로 밀어냄
                                    Spacer()
                                    
                                    // 녹음 파일 재생/정지 버튼
                                    Button(action: {
                                        if recording.isPlaying == true {
                                            vm.stopPlaying(url: recording.fileURL)
                                        }else{
                                            vm.startPlaying(url: recording.fileURL)
                                        }
                                    }) {
                                        Image(systemName: recording.isPlaying ? "stop.fill" : "play.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size:30))
                                    }
                                }
                                
                            }.padding()
                        }.padding(.horizontal,10)
                        .frame(width: 370, height: 85)
                        .background(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                        .cornerRadius(30)
                        .shadow(color: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).opacity(0.3), radius: 10, x: 0, y: 10)
                    }
                }
                
            }.padding(.top,30)
            .navigationBarTitle("녹음 목록") // 네비게이션 바 제목을 "녹음 목록"으로 설정
        }
    }
}

struct recordingListView_Previews: PreviewProvider {
    static var previews: some View {
        recordingListView()
    }
}
