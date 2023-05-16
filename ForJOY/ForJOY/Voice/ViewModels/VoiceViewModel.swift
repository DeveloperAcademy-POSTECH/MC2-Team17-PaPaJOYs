//
//  File.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/03.
//

import SwiftUI
import AVFoundation

class VoiceViewModel : NSObject, ObservableObject , AVAudioPlayerDelegate{
    // 녹음과 재생에 필요한 AVAudioRecorder와 AVAudioPlayer
    var audioRecorder : AVAudioRecorder!
    // 녹음 중인지 여부를 나타내는 @Published 프로퍼티
    @Published var isRecording : Bool = false
    @Published var isEndRecording : Bool = false
    @Published var recording: URL?
    // 녹음 시간을 계산하는 데 사용되는 타이머와 블링킹 효과를 구현하는 데 사용되는 타이머, 타이머의 카운트 시간과 변하는 색상을 나타내는 @Published 프로퍼티
    @Published var countSec = 0
    @Published var timerCount : Timer?
    @Published var blinkingCount : Timer?
    @Published var timer : String = "0:00"
    @Published var toggleColor : Bool = false
    
    // 녹음 시작 메소드
    func startRecording() {
        // 녹음을 위한 AVAudioSession 설정
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Cannot setup the Recording")
        }
        // 녹음 파일을 저장할 경로와 파일 이름 설정
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        recording = path.appendingPathComponent("\(Date().toString(dateFormat: "YY-MM-dd-HH-mm-ss")).m4a")
        
        // 녹음 설정
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        // AVAudioRecorder를 생성하고 녹음 시작
        do {
            print("음성1 \(recording)")
            audioRecorder = try AVAudioRecorder(url: (recording ?? URL(string: "Overnight.mp3")!), settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            isRecording = true
            isEndRecording = false
            // 녹음 시간 계산을 위한 타이머 설정
            timerCount = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (value) in
                self.countSec += 1
                self.timer = self.covertSecToMinAndHour(seconds: self.countSec)
            })
            blinkColor()
        } catch {
            print("Failed to Setup the Recording")
        }
    }
    
    // 녹음 중지 메소드
    func stopRecording(){
        audioRecorder.stop()
        isRecording = false
        isEndRecording = true
        self.countSec = 0
        timerCount!.invalidate()
        blinkingCount!.invalidate()
    }
    
    // 해당 함수는 타이머 기능으로, 일정한 시간 간격으로 toggleColor를 변경한다.
    func blinkColor() {
        blinkingCount = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (value) in
            self.toggleColor.toggle()
        })
    }
}
