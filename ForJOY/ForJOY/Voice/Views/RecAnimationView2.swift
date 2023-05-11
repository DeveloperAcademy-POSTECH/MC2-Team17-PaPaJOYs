//
//  RecAnimationView2.swift
//  ForJOY
//
//  Created by Sehui Oh on 2023/05/11.
//

import SwiftUI
import AVFoundation

struct RecAnimationView2: View {
    
    @ObservedObject var vm: VoiceViewModel
    
    
    @Binding var decibels : CGFloat
    @Binding var circle1: CGFloat
    @Binding var circle2: CGFloat
    
    @Binding var blueCircleOffset: CGSize
    @Binding var yellowCircleOffset: CGSize
    @Binding var blurSize : Double
    @Binding var remainingTime : TimeInterval
    
//    let audioRecorder = try! AVAudioRecorder(
//        url: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("audio.m4a"), // 녹음 파일의 저장 경로
//        settings: [
//            AVFormatIDKey: Int(kAudioFormatMPEG4AAC), // 오디오 인코딩 포맷 설정
//            AVSampleRateKey: 44100, // 샘플 레이트 설정
//            AVNumberOfChannelsKey: 1, // 채널 수 설정
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue // 오디오 인코딩 품질 설정
//        ])
    
    var body: some View {
        
        ZStack{
            Color(.blue)
            VStack {
                ZStack {
                    
                    Circle()
                        .fill(Color("JoyBlue"))
                        .frame(width: circle1 * 175) //데시벨 값에 따라서 크기수정 되게 GlobalStore.circle
                        .offset(blueCircleOffset)
                        .blur(radius: blurSize)
                    
                    Circle()
                        .fill(Color("JoyYellow"))
                        .frame(width: circle2 * 120) //데시벨 값에 따라서 크기수정 되게 GlobalStore.circle
                        .offset(yellowCircleOffset)
                        .blur(radius: blurSize)
                    
                    VStack{
                        Text("Decibels: \(Int(decibels))")
                            .font(.headline)
                            .padding()
                        Text("Remaining Time : \(Int(remainingTime))")
                            .font(.headline)
                            .padding()
                    }
                    
                }

            }
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
//    
    
    
}
