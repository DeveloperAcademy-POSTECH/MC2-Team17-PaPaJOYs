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
    
    // 애니메이션을 위한 원의 위치, 크기 및 블러 설정
    @State var blueCircleOffset: CGSize = .init(width: -40, height: 0)
    @State var yellowCircleOffset: CGSize = .init(width: 80, height: 40)
    @State var blurSize : Double = 20
    @State var circle1: Double = 1.0
    @State var circle2: Double = 1.0
    @State var progressOpacity = 1.0
    @State var showLottieView = true
    @State var maskFrameSize : CGFloat = 50  // 마스크의 프레임 크기
    
    // 녹음 파일 저장 URL
    @State var recording: URL?
    // 다음 화면으로 이동하기 위한 상태 변수
    @State var isChoosen = false
    @State var navigateToInfoView: Bool = false
    
    
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
    
    // 무작위 위치 값을 반환
    func getRandomOffset() -> CGSize {
        let x = CGFloat.random(in: -50...80)
        let y = CGFloat.random(in: -60...60)
        return CGSize(width: x, height: y)
    }
    // 데시벨 값에 따라 원의 크기를 조절
    func circleSize(){
        if vm.isRecording == true {
            if decibels > 70 {
                circle1 = 0.8
                circle2 = 1.2
            }else{
                circle1 = 1.0
                circle2 = 1.0
            }
        }else if vm.isEndRecording == true {
            circle1 = 1.0
            circle2 = 1.0
        }
    }
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
        try! AVAudioSession.sharedInstance().setActive(false)
        audioRecorder.isMeteringEnabled = false
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in // 0.1초 간격으로 실행되는 타이머 생성
        }
    }
    
    // 녹음 중 데시벨을 업데이트하고 원 크기 조절
    func record() {
        // 데시벨 값 업데이트 및 원 크기 조절 애니메이션
        audioRecorder.updateMeters()
        decibels = 100+CGFloat(audioRecorder.averagePower(forChannel: 0))
        withAnimation(Animation.easeInOut(duration: 2)) {
            circleSize()
        }
    }
    // 녹음 종료 버튼 애니메이션 설정
    func endButton() {
        // 버튼 관련 애니메이션 설정
        withAnimation(Animation.easeInOut(duration: 2.1)) {
            blueCircleOffset = .init(width: -40, height: -30)
            yellowCircleOffset = .init(width: 73, height: 37.5)
            blurSize = 0
        }
        
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
            
            // 중앙 정렬을 위한 VStack
            VStack{
                // 녹음 진행도와 관련된 UI를 그룹화하는 ZStack
                ZStack{
                    
                    // 녹음이 아직 시작되지 않았을 때의 녹음 버튼
                    if !vm.isRecording && !vm.isEndRecording {
                        Button(action: {
                            vm.startRecording()  // 녹음 시작
                        }){
                            ZStack{
                                // 녹음 버튼의 배경 원
                                Circle()
                                    .fill(Color("JoyYellow"))
                                    .frame(width: 57)
                                
                                // 마이크 아이콘
                                Image(systemName: "mic.fill")
                                    .resizable()
                                    .frame(width: 20, height: 30)
                                    .foregroundColor(Color("JoyDarkG"))
                            }
                        }
                        
                    } else {
                        // 녹음 중과 녹음 종료 시의 UI
                        ZStack{
                            //                             데시벨에 따라 변하는 원들
                            
                            // 녹음 중일 때의 녹음 종료 버튼
                            if vm.isRecording && !vm.isEndRecording {
                                Button(action: {
                                    // 녹음 종료 관련 애니메이션 및 로직
                                    endButton()
                                    maskFrameSize = 50
                                    remainingTime = 0.0
                                    recProgress = 1.0
                                    vm.isRecording = false
                                    vm.isEndRecording = true
                                    vm.stopRecording()
                                    progressOpacity = 0
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
                    }
                }
                // 타이머를 표시하는 Text 뷰 추가
                Text(timeString(from: remainingTime))
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.top, 8) // 원과의 간격을 조정

                
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
            }
        }
        // 1초마다 업데이트하는 로직
        .onReceive(timer2) { _ in
            if !vm.isEndRecording {
                // 녹음 중일 때의 로직
                
                if vm.isRecording && remainingTime > 0 {
                    remainingTime -= 1
                    recProgress += (1/settingTime)
                    
                    withAnimation(Animation.easeInOut(duration: 9)) {
                        blueCircleOffset = getRandomOffset()
                        yellowCircleOffset = getRandomOffset()
                        
                        if Int(remainingTime) % 7 == 0 {
                            blurSize = (remainingTime/7) + 0
                        }
                    }
                    
                } else if remainingTime <= 0 {
                    
                    endButton()
                    vm.isRecording = false
                    vm.isEndRecording = true
                    vm.stopRecording()
                    progressOpacity = 0
                    maskFrameSize = 50
                }
            }
        }
    }
}
