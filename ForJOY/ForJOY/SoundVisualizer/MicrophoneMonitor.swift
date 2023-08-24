//
//  MicrophoneMonitor.swift
//  SoundVisualizer
//
//  Created by 조호식 on 2023/08/23.
//

import Foundation
import AVFoundation

class MicrophoneMonitor: ObservableObject {
    
    // 1
    private var svAudioRecorder: AVAudioRecorder
    private var svTimer: Timer?
    
    private var svCurrentSample: Int
    private let svNumberOfSamples: Int
    
    // 2
    @Published public var svSoundSamples: [Float]
    
    init(numberOfSamples: Int) {
        self.svNumberOfSamples = numberOfSamples // In production check this is > 0.
        self.svSoundSamples = [Float](repeating: -160, count: numberOfSamples)
        self.svCurrentSample = 0
        
        // 3
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { (isGranted) in
                if !isGranted {
                    fatalError("You must allow audio recording for this demo to work")
                }
            }
        }
        
        // 4
        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
        let recorderSettings: [String:Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        
        // 5
        do {
            svAudioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            
            svStartMonitoring()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // 6
    private func svStartMonitoring() {
        svAudioRecorder.isMeteringEnabled = true
        svAudioRecorder.record()
        svTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
            self.svAudioRecorder.updateMeters()
            // Shift samples to the left and add a new sample at the end
            self.svSoundSamples.removeFirst()
            self.svSoundSamples.append(self.svAudioRecorder.averagePower(forChannel: 0))
        })
    }
    
    // 8
    deinit {
        svTimer?.invalidate()
        svAudioRecorder.stop()
    }
}
