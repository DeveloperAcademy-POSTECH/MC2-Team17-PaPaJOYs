//
//  oliveView.swift
//  ForJOY
//
//  Created by Sehui Oh on 2023/05/02.
//

import SwiftUI
import Combine
import AVFoundation

struct TimerView: View {
    @ObservedObject var vm: VoiceViewModel
    //    @Environment(\.dismiss) private var dismiss
    
    // 목소리 녹음과 관련된 뷰 모델
    @StateObject var voiceViewModel = VoiceViewModel()
    // 녹음 시간과 관련된 상태
    @State var remainingTime: TimeInterval = 180.0 // 남은 시간
    @State var settingTime =  180.0  // 설정된 시간
    
    // 녹음과 관련된 상태
    @State var recProgress : Double = 0.0  // 녹음의 진행도 (0 ~ 1)
    @State var decibels: CGFloat = 0  // 데시벨 값
    
    // 1초 간격으로 업데이트하는 타이머
    @State var timer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var animationTriggered = false
    
    // 녹음 파일의 URL
    @Binding var recording: URL?
    @Binding var pageNumber: Int
    
    // 오디오 녹음기 설정
    let audioRecorder = try! AVAudioRecorder(
        url: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("audio.m4a"),
        settings: [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    )
    
    // TimeInterval 값을 분:초 형식의 문자열로 변환
    func timeString(from time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // 녹음 준비 및 시작
    func setUpRecord() {
        // 오디오 세션을 녹음 모드로 설정하고 녹음 시작
        try! AVAudioSession.sharedInstance().setCategory(.record)
        try! AVAudioSession.sharedInstance().setActive(true)
        audioRecorder.prepareToRecord()
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in // 0.1초 간격으로 실행되는 타이머 생성
            record()
        }
    }
    
    // 녹음 종료 및 리소스 해제
    func setEndRecord() {
        // 오디오 세션 비활성화 및 리소스 해제
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("Error deactivating audio session:", error)
        }
        
        audioRecorder.isMeteringEnabled = false
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            // Timer logic here
        }
    }
    
    
    // 녹음 중 데시벨을 업데이트하고 원 크기 조절
    func record() {
        // 데시벨 값 업데이트 및 원 크기 조절 애니메이션
        audioRecorder.updateMeters()
        decibels = 100+CGFloat(audioRecorder.averagePower(forChannel: 0))
    }
    
    // 뷰 본문 정의
    var body: some View {
        // 전체 뷰를 구성하는 UI 요소와 로직
        // 배경색 설정, 녹음 진행도 표시, 버튼 동작, 애니메이션 등의 로직 포함
        // 배경 색상과 중앙에 배치된 녹음 UI를 포함하는 ZStack
        ZStack{
            // 전체 배경색을 설정
            Color("JoyDarkG")
                .ignoresSafeArea()
            
            VStack{
                // 녹음 진행도와 관련된 UI를 그룹화하는 ZStack
                ZStack{
                    
                    // 녹음이 아직 시작되지 않았을 때의 녹음 버튼
                    // 1번
                    if !vm.isRecording && !vm.isEndRecording {
                        Button(action: {
                            vm.startRecording()
                        }){
                            ZStack{
                                Circle()
                                    .fill(Color("JoyYellow"))
                                    .frame(width: 57)
                                
                                Image(systemName: "mic.fill")
                                    .resizable()
                                    .frame(width: 20, height: 30)
                                    .foregroundColor(Color("JoyDarkG"))
                            }
                        }
                    } else {
                        // 녹음 중과 녹음 종료 시의 UI
                        // 녹음 중일 때의 녹음 종료 버튼
                        // 2번
                        if vm.isRecording && !vm.isEndRecording {
                            Button(action: {
                                remainingTime = 0.0
                                recProgress = 1.0
                                vm.isRecording = false
                                vm.isEndRecording = true
                                vm.stopRecording()
                                //                                pageNumber = 1
                            }, label: {
                                ZStack{
                                    Circle()
                                        .fill(Color("JoyWhite"))
                                        .frame(width: 57)
                                    
                                    Image(systemName: "stop.fill")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                        .foregroundColor(Color("JoyDarkG"))
                                }
                            })
                        }
                    }
                    // 3번
                    if !vm.isRecording && vm.isEndRecording {
                        ZStack {
                            Circle()
                                .fill(Color("JoyBlue"))
                                .frame(width: 57)
                            
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 22, height: 22)
                                .foregroundColor(Color("JoyDarkG"))
                                .scaleEffect(animationTriggered ? 1.0 : 0.1)
                                .opacity(animationTriggered ? 1.0 : 0.0)
                                .animation(Animation.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5).delay(0.1))
                        }
                        .onAppear() {
                            animationTriggered = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                pageNumber += 1  // Navigate to the next page
                            }
                        }
                    }
                }
                // 녹음이 시작될 때의 설정
                .onAppear(){
                    if vm.isRecording && !vm.isEndRecording{
                        setUpRecord()  // 녹음 설정 및 시작
                    }
                }
                // 녹음이 종료될 때의 설정
                .onDisappear(){
                    if !vm.isRecording && vm.isEndRecording{
                        setEndRecord()  // 녹음 종료 및 리소스 해제
                    }
                }
                
                // 타이머를 표시하는 Text 뷰 추가
                if !(vm.isEndRecording) {
                    Text(timeString(from: remainingTime))
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.top, 8)
                } else {
                    Text("")
                        .font(.system(size: 16))
                        .padding(.top, 8)
                }
            }
        }
        // 1초마다 업데이트하는 로직
        .onReceive(timer2) { _ in
            if !vm.isEndRecording {
                // 녹음 중일 때의 로직
                
                if vm.isRecording && remainingTime > 0 {
                    remainingTime -= 1
                    recProgress += (1/settingTime)
                    
                } else if remainingTime <= 0 {
                    
                    vm.isRecording = false
                    vm.isEndRecording = true
                    vm.stopRecording()
                }
            }
        }
    }
}
