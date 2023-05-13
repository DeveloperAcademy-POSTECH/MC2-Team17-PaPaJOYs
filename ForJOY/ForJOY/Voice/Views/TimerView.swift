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
//    @State var isRecOn : Bool = false
    @State var remainingTime: TimeInterval = 30.0
    @State var settingTime =  30.0
//    @State var isRecEnd : Bool = false
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
    
    
    let audioRecorder = try! AVAudioRecorder(
        url: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("audio.m4a"), // 녹음 파일의 저장 경로
        settings: [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC), // 오디오 인코딩 포맷 설정
            AVSampleRateKey: 44100, // 샘플 레이트 설정
            AVNumberOfChannelsKey: 1, // 채널 수 설정
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue // 오디오 인코딩 품질 설정
        ])
    
    
    
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
        }
    
    func timeString(from time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func setUpRecord() { // 녹음 세팅을 설정하는 함수
        try! AVAudioSession.sharedInstance().setCategory(.record) // 녹음 모드로 세팅
        try! AVAudioSession.sharedInstance().setActive(true) // 오디오 세션 활성화
        audioRecorder.prepareToRecord() // 녹음 준비
        audioRecorder.isMeteringEnabled = true // 녹음 시 미터링 기능 사용
        audioRecorder.record() // 녹음 시작

        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in // 0.1초 간격으로 실행되는 타이머 생성
            record()
            // record() 메서드 호출
        }
    }

    func record() { // 녹음을 실행하고 데시벨 값을 업데이트하는 함수
        audioRecorder.updateMeters() // 미터링 값을 업데이트
        decibels = 100+CGFloat(audioRecorder.averagePower(forChannel: 0))
        // 현재 데시벨 값을 decibels 속성에 저장
        withAnimation(Animation.easeInOut(duration: 2)) {
            circleSize()
        }
    }
    
    
    /// 제자리로 돌아가는 함수 ////
        func endButton() {
//            vm.isRecording = false
//            vm.isEndRecording = true
//            vm.stopRecording()

            withAnimation(Animation.easeInOut(duration: 2.1)) {
                blueCircleOffset = .init(width: -40, height: -30)
                yellowCircleOffset = .init(width: 73, height: 37.5)
                blurSize = 0
            }

        }

    


    var body: some View {
        //Zstack2 START
        ZStack{
            //background color
            Color("JoyDarkG")
                .ignoresSafeArea()
            
            

            //Vstack1 Start
            VStack{

                //Zstack1 Start
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
                                }){
                                    Text("   ")
                                        .padding(120)
                                    
                                }
                            }else if !vm.isRecording && vm.isEndRecording {
                            
                                ZStack{
                                    
                                    if showLottieView{
                                        ZStack{
                                            LottieView(jsonName: "RecComplete2")
                                                .frame(width: 910, height: 910)
                                            LottieView(jsonName: "panpare")
                                                .frame(width: 900, height: 900)
                                        }
                                    }
                                    
                                }
                            }
                            
                            
                            
                        }
                    }
                        
                    
                        
                        
                    }//Zstack1 END
                .onAppear(){
                    setUpRecord()
                }

//                Text("Progress \(recProgress)") // 임시로 표기
//                Text("Time\(timeString(from: remainingTime))") // 임시로 표기
//                Text("isEndRecording? \(vm.isEndRecording ? "true":"false")")
//                Text("isRecording? \(vm.isRecording ? "true":"false")")
//                Text("Decibels: \(Int(decibels))")
//                Text("circle1 : \(circle1)")
//                Text("circle2 : \(circle2)")
                
                

            }//Vstack1 END
            
            
        }//Zstack2 END
        .onReceive(timer2) { _ in
            if !vm.isEndRecording{
                
                if vm.isRecording && remainingTime > 0 {
                    
                    
                    remainingTime -= 1
                    recProgress += (1/settingTime)
                    
                    
                    withAnimation(Animation.easeInOut(duration: 9)) {
                        blueCircleOffset = getRandomOffset()
                        yellowCircleOffset = getRandomOffset()
                        
                        
                        if Int(remainingTime) % 7 == 0 { // Move the circles randomly every 5 seconds
//                            withAnimation(Animation.easeInOut(duration: 7)) {
//                                blueCircleOffset = getRandomOffset()
//                                yellowCircleOffset = getRandomOffset()
                                blurSize = (remainingTime/7) + 0
  
                                //블러 사이즈 비례d
                                
//                            }
                        }
                        
//                        else if Int(remainingTime)-295 > 0 {
////                            withAnimation(Animation.easeInOut(duration: 5)) {
//                                blueCircleOffset = .init(width: 20, height: 60)
//                                yellowCircleOffset = .init(width: 50, height: 00)
//                                blurSize = (remainingTime/7) + 0
//
////                            }
//                        }
                    }
                    
                    
                } else if remainingTime <= 0 {
                    
                    endButton()
                    vm.isRecording = false
                    vm.isEndRecording = true
                    vm.stopRecording()
                    progressOpacity = 0
                    maskFrameSize = 700
//
//                    withAnimation(Animation.easeInOut(duration: 3)) {
//                        blueCircleOffset = .init(width: -40, height: 0)
//                        yellowCircleOffset = .init(width: 70, height: 70)
//                        blurSize = 10
//                    }
                    
                }
            }
        }




        }//Body End

    }//Struct END



struct TimerView_Previews: PreviewProvider {
    @StateObject static var vm = VoiceViewModel()
    
    static var previews: some View {
        TimerView(vm: vm)
    }
}
