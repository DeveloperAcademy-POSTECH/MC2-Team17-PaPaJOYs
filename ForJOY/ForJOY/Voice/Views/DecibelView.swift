//
//  VoiceDecibel.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/03.
//
//
import SwiftUI // SwiftUI 라이브러리 import
import AVFoundation // AVFoundation 라이브러리 import
import Foundation

struct DecibelView: View { // DecibelView 구조체 정의
    
    
//
    @Binding var decibels: CGFloat// 데시벨 수치를 나타내는 속성 정의 및 초기값 설정
    @Binding var circleX_1: CGFloat
    @Binding var circleX_2: CGFloat
    @Binding var circleY_1: CGFloat
    @Binding var circleY_2: CGFloat 
    
    // AVAudioRecorder 인스턴스 생성 및 초기화
//    let audioRecorder = try! AVAudioRecorder(
//        url: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("audio.m4a"), // 녹음 파일의 저장 경로
//        settings: [
//            AVFormatIDKey: Int(kAudioFormatMPEG4AAC), // 오디오 인코딩 포맷 설정
//            AVSampleRateKey: 44100, // 샘플 레이트 설정
//            AVNumberOfChannelsKey: 1, // 채널 수 설정
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue // 오디오 인코딩 품질 설정
//        ])
//
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // 1초마다 실행되는 타이머 생성
    
    var body: some View {
        
        
        VStack {
            Text("decibels : \(decibels)") // 현재 데시벨 값을 텍스트로 표시
//            Button("record") { // 녹음 버튼을 생성하고 누르면 record() 메서드 호출
//                record()
//            }
        }
//        .onAppear { // 뷰가 생성될 때(setup 함수 대체) 실행할 블록
//            setUpRecord() // 녹음 세팅 설정
//        }
    }
    
    func circleSize(){
        if decibels < 20 {
            self.circleX_1 = 2.0
            self.circleY_1 = 2.0
            self.circleX_2 = 1.0
            self.circleY_2 = 1.0
        } else if decibels > 20 {
            self.circleX_1 = 1.0
            self.circleY_1 = 1.0
            self.circleX_2 = 2.0
            self.circleY_2 = 2.0  //데시벨 값에 따라서 크기수정 되게 GlobalStore.circle
        }
    }


//    func setUpRecord() { // 녹음 세팅을 설정하는 함수
//        try! AVAudioSession.sharedInstance().setCategory(.record) // 녹음 모드로 세팅
//        try! AVAudioSession.sharedInstance().setActive(true) // 오디오 세션 활성화
//        audioRecorder.prepareToRecord() // 녹음 준비
//        audioRecorder.isMeteringEnabled = true // 녹음 시 미터링 기능 사용
//        audioRecorder.record() // 녹음 시작
//
//        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in // 0.1초 간격으로 실행되는 타이머 생성
//            record() // record() 메서드 호출
//        }
//    }
//
//    func record() { // 녹음을 실행하고 데시벨 값을 업데이트하는 함수
//        audioRecorder.updateMeters() // 미터링 값을 업데이트
//        decibels = -CGFloat(audioRecorder.averagePower(forChannel: 0)) // 현재 데시벨 값을 decibels 속성에 저장
//    }
}


//DecibelView는 View 프로토콜을 채택하는 구조체입니다. 이 구조체는 @State 프로퍼티 decibels을 가지고 있습니다. 이 값은 AVAudioRecorder를 통해 측정된 데시벨 값을 저장합니다.
//
//audioRecorder는 녹음 기능을 수행하는 AVAudioRecorder 객체입니다. FileManager를 사용하여 파일 경로를 설정하고 AVFormatIDKey, AVSampleRateKey, AVNumberOfChannelsKey, AVEncoderAudioQualityKey를 사용하여 녹음 설정을 구성합니다.
//
//timer는 매 초마다 실행되는 타이머입니다.
//
//body 프로퍼티는 VStack과 Button 뷰를 포함하는데, Text 뷰는 decibels 값을 출력하고, Button 뷰는 record() 메서드를 호출합니다. onAppear 블록에서는 setUpRecord() 메서드를 호출하여 녹음을 설정합니다.
//
//setUpRecord() 메서드에서는 AVAudioSession을 사용하여 녹음 세션을 설정하고 audioRecorder 객체를 준비하고, 0.1초마다 record() 메서드를 호출하여 데시벨 값을 업데이트합니다.
//
//record() 메서드에서는 audioRecorder 객체를 사용하여 데시벨 값을 측정하고, decibels 값을 업데이트합니다.
