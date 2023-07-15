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
    @State var remainingTime: TimeInterval = 300.0
    @State var settingTime =  300.0
    
    @State var recProgress : Double = 0.0
    @State var decibels: CGFloat = 0
    @State var timer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var blueCircleOffset: CGSize = .init(width: -40, height: 0)
    @State var yellowCircleOffset: CGSize = .init(width: 80, height: 40)
    @State var blurSize : Double = 20
    
    @State var circle1: Double = 1.0
    @State var circle2: Double = 1.0
    
    @State var progressOpacity = 1.0
    @State var showLottieView = true
    
    @State var maskFrameSize : CGFloat = 240
    
    @State var recording: URL?
   
    
    let audioRecorder = try! AVAudioRecorder(
        url: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("audio.m4a"),
        settings: [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    )
    
    func getRandomOffset() -> CGSize {
        let x = CGFloat.random(in: -50...80)
        let y = CGFloat.random(in: -60...60)
        return CGSize(width: x, height: y)
    }
    
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
    
    func timeString(from time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func setUpRecord() {
        try! AVAudioSession.sharedInstance().setCategory(.record)
        try! AVAudioSession.sharedInstance().setActive(true)
        audioRecorder.prepareToRecord()
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in // 0.1초 간격으로 실행되는 타이머 생성
            record()
        }
    }
    
    func setEndRecord() {
        try! AVAudioSession.sharedInstance().setActive(false)
        audioRecorder.isMeteringEnabled = false
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in // 0.1초 간격으로 실행되는 타이머 생성
        }
    }
    
    func record() {
        audioRecorder.updateMeters()
        decibels = 100+CGFloat(audioRecorder.averagePower(forChannel: 0))
        withAnimation(Animation.easeInOut(duration: 2)) {
            circleSize()
        }
    }
    
    func endButton() {
        withAnimation(Animation.easeInOut(duration: 2.1)) {
            blueCircleOffset = .init(width: -40, height: -30)
            yellowCircleOffset = .init(width: 73, height: 37.5)
            blurSize = 0
        }
        
    }
    
    var body: some View {
        ZStack{
            Color("JoyDarkG")
                .ignoresSafeArea()
           
            VStack{
                ZStack{
                    CircularProgressView(recProgress : $recProgress, progressOpacity: $progressOpacity)
                    
                    if !vm.isRecording && !vm.isEndRecording {
                        Button(action: {
                            vm.startRecording()
                        }){
                            ZStack{
                                Circle()
                                    .fill(Color("JoyBlue"))
                                    .frame(width: 190)
                                    .blur(radius: 30)
                                    .opacity(0.6)
                                Image(systemName: "mic.fill")
                                    .resizable()
                                    .frame(width: 27, height: 40)
                                    .foregroundColor(Color("JoyWhite"))
                            }
                        }
                        
                    } else {
                        ZStack{
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color("JoyBlue"),Color("JoyBlueL")]), startPoint: .bottom, endPoint: .top))
                                    .frame(width: circle1 * 175, height: circle1 * 175) //데시벨 값에 따라서 크기수정 되게 GlobalStore.circle
                                    .offset(blueCircleOffset)
                                    .blur(radius: blurSize)
                                
                                Circle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color("JoyYellow"),Color("JoyYellowL")]), startPoint: .bottom, endPoint: .top))
                                    .frame(width: circle2 * 120, height: circle2 * 120) //데시벨 값에 따라서 크기수정 되게 GlobalStore.circle
                                    .offset(yellowCircleOffset)
                                    .blur(radius: blurSize)
                            }
                            .mask{
                                Circle()
                                    .frame(width: maskFrameSize, height: maskFrameSize)
                                    .blur(radius: 0)
                            }
                            
                            
                            if vm.isRecording && !vm.isEndRecording {
                                Button(action: {
                                    endButton()
                                    maskFrameSize = 700
                                    remainingTime = 0.0
                                    recProgress = 1.0
                                    vm.isRecording = false
                                    vm.isEndRecording = true
                                    vm.stopRecording()
                                    progressOpacity = 0
                                }, label: {
                                    Image(systemName: "stop.fill")
                                        .foregroundColor(Color("JoyWhite"))
                                        .font(.system(size: 50))
                                        .opacity(0.6)
                                        .padding(120)
                                })
                            }
//                            }else if !vm.isRecording && vm.isEndRecording {
//                                ZStack{
//                                    LottieView(jsonName: "RecComplete2")
//                                        .frame(width: 910, height: 910)
//                                    LottieView(jsonName: "panpare")
//                                        .frame(width: 900, height: 900)
//                                }
//                            }

                        }
                    }

                }
                .onAppear(){
                    if vm.isRecording && !vm.isEndRecording{
                        setUpRecord()
                    }
                }
                .onDisappear(){
                    if !vm.isRecording && vm.isEndRecording{
                        setEndRecord()
                    }
                }
            }
        }
        .onReceive(timer2) { _ in
            if !vm.isEndRecording{
                
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
                    maskFrameSize = 700
                }
            }
        }
    }
}
