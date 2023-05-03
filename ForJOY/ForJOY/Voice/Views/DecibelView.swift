//
//  VoiceDecibel.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/03.
//
//
import SwiftUI
import AVFoundation



struct DecibelView: View {
    
    
    @State private var decibels: CGFloat = 0
    
    
    
    let audioRecorder = try! AVAudioRecorder(url: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("audio.m4a"),
                                             settings: [
                                                AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 44100,
                                                AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                                             ])
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text(decibels, format: .number)
            Button("record") {
                record()
            }
        }
        .onAppear { // 뷰가 켜지면 실행할 블록
            // 녹음 세팅 설정
            setUpRecord()
        }
    }
    
    
    func setUpRecord() {
            try! AVAudioSession.sharedInstance().setCategory(.record)
            try! AVAudioSession.sharedInstance().setActive(true)
            audioRecorder.prepareToRecord()
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                record()
            }
        }
        
    func record() {
        audioRecorder.updateMeters()
        decibels = CGFloat(audioRecorder.averagePower(forChannel: 0))
    }
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
