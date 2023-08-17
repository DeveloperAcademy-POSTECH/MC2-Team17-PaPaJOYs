//
//  VoiceViewModel.swift
//  ForJOY
//
//  Created by Nayeon Kim on 2023/05/17.
//

import SwiftUI
import AVFoundation

// 사용자의 목소리를 녹음하고 제어하는 뷰 모델
class VoiceViewModel : NSObject, ObservableObject , AVAudioPlayerDelegate{
    @Published var isRecording : Bool = false        // 현재 녹음 중인지 상태
    @Published var isEndRecording : Bool = false     // 녹음이 종료되었는지 상태
    @Published var recording: URL?                   // 녹음 파일의 URL
    @Published var countSec = 0                      // 녹음된 시간(초)
    @Published var timerCount : Timer?               // 녹음 시간을 업데이트하기 위한 타이머
    @Published var blinkingCount : Timer?            // 컬러 변경을 위한 타이머(깜빡임 효과)
    @Published var timer : String = "0:00"           // 표시될 녹음 시간 문자열
    @Published var toggleColor : Bool = false        // 컬러 깜빡임 효과를 위한 토글 변수
    
    var audioRecorder : AVAudioRecorder!             // 오디오 녹음을 위한 객체
    
    // 녹음 시작하는 메소드
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Cannot setup the Recording")
        }
        
        // 녹음 파일 저장 경로 설정
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        recording = path.appendingPathComponent("\(Date().toString(dateFormat: "YY-MM-dd-HH-mm-ss")).m4a")
        
        // 녹음 설정
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            // 녹음 준비 및 시작
            audioRecorder = try AVAudioRecorder(url: (recording ?? URL(string: "Overnight.mp3")!), settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            isRecording = true
            isEndRecording = false
            
            // 녹음 시간 업데이트
            timerCount = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (value) in
                self.countSec += 1
                self.timer = self.covertSecToMinAndHour(seconds: self.countSec)
            })
            blinkColor()  // 컬러 깜빡임 시작
        } catch {
            print("Failed to Setup the Recording")
        }
    }
    
    // 녹음 중지하는 메소드
    func stopRecording(){
        audioRecorder.stop()
        isRecording = false
        isEndRecording = true
        self.countSec = 0
        timerCount!.invalidate()
        blinkingCount!.invalidate()
    }
    
    // 일정한 간격으로 toggleColor 값을 변경하여 컬러 깜빡임 효과 생성
    func blinkColor() {
        blinkingCount = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (value) in
            self.toggleColor.toggle()
        })
    }
}

extension VoiceViewModel {
    // 초를 분과 초로 변환하는 함수
    func covertSecToMinAndHour(seconds : Int) -> String{
        let (_,m,s) = (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        let sec : String = s < 10 ? "0\(s)" : "\(s)"
        return "\(m):\(sec)"
    }
}
