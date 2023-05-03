//
//  File.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/03.
//

import Foundation
import AVFoundation

class VoiceViewModel : NSObject, ObservableObject , AVAudioPlayerDelegate{
    // 녹음과 재생에 필요한 AVAudioRecorder와 AVAudioPlayer
    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    // 재생 중인 녹음 파일의 인덱스
    var indexOfPlayer = 0
    // 녹음 중인지 여부를 나타내는 @Published 프로퍼티
    @Published var isRecording : Bool = false
    // 녹음 파일 목록을 담는 @Published 배열
    @Published var recordingsList = [Recording]()
    // 녹음 시간을 계산하는 데 사용되는 타이머와 블링킹 효과를 구현하는 데 사용되는 타이머, 타이머의 카운트 시간과 변하는 색상을 나타내는 @Published 프로퍼티
    @Published var countSec = 0
    @Published var timerCount : Timer?
    @Published var blinkingCount : Timer?
    @Published var timer : String = "0:00"
    @Published var toggleColor : Bool = false
    // 현재 재생 중인 녹음 파일의 URL
    var playingURL : URL?
    
    // 초기화 메소드
    override init(){
        super.init()
        // 앱이 실행될 때 저장된 녹음 파일을 불러옴
        fetchAllRecording()
    }
    
    // 녹음 파일 재생이 끝났을 때 호출되는 AVAudioPlayerDelegate 메소드
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        for i in 0..<recordingsList.count {
            if recordingsList[i].fileURL == playingURL {
                recordingsList[i].isPlaying = false
            }
        }
    }
    
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
        let fileName = path.appendingPathComponent("CO-Voice : \(Date().toString(dateFormat: "dd-MM-YY 'at' HH:mm:ss")).m4a")
        // 녹음 설정
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        // AVAudioRecorder를 생성하고 녹음 시작
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            isRecording = true
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
        self.countSec = 0
        timerCount!.invalidate()
        blinkingCount!.invalidate()
    }
    
    // 저장된 모든 녹음 파일을 가져와서 recordingsList 배열에 추가하는 메소드
    func fetchAllRecording(){
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
        for i in directoryContents {
            recordingsList.append(Recording(fileURL : i, createdAt:getFileDate(for: i), isPlaying: false))
        }
        // recordingsList를 생성 날짜를 기준으로 내림차순 정렬
        recordingsList.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending})
    }
    
    // 녹음 파일 재생 메소드
    func startPlaying(url : URL) {
        playingURL = url
        let playSession = AVAudioSession.sharedInstance()
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing failed in Device")
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            // 현재 재생 중인 파일을 recordingsList 배열에서 찾아서 isPlaying 속성을 true로 변경
            for i in 0..<recordingsList.count {
                if recordingsList[i].fileURL == url {
                    recordingsList[i].isPlaying = true
                }
            }
        } catch {
            print("Playing Failed")
        }
    }
    // 해당 함수는 녹음 중지 시 호출되며, 녹음 중인 오디오 레코더를 정지하고, 재생 중 표시되는 리스트에서 해당 녹음 파일의 재생 여부를 false로 변경한다.
    func stopPlaying(url : URL) {
        audioPlayer.stop()
        for i in 0..<recordingsList.count {
            if recordingsList[i].fileURL == url {
                recordingsList[i].isPlaying = false
            }
        }
    }
    
    // 해당 함수는 녹음 파일을 삭제할 때 호출되며, 해당 파일을 삭제하고, 재생 중인 경우에는 재생을 중지시킨다. 마지막으로, 리스트에서 해당 파일을 제거한다.
    func deleteRecording(url : URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Can't delete")
        }
        for i in 0..<recordingsList.count {
            if recordingsList[i].fileURL == url {
                if recordingsList[i].isPlaying == true{
                    stopPlaying(url: recordingsList[i].fileURL)
                }
                recordingsList.remove(at: i)
                break
            }
        }
    }
    
    // 해당 함수는 타이머 기능으로, 일정한 시간 간격으로 toggleColor를 변경한다.
    func blinkColor() {
        blinkingCount = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (value) in
            self.toggleColor.toggle()
        })
    }
    
    // 해당 함수는 녹음 파일의 생성 일자를 가져오는 함수로, 파일이 존재하는 경우 생성일자를 반환하고, 파일이 존재하지 않는 경우 현재 날짜를 반환한다.
    func getFileDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
           let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
}

