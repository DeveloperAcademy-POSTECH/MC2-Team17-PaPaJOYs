////
////  RecAnimationView.swift
////  ForJOY
////
////  Created by Sehui Oh on 2023/05/04.
////  why cant commit?
//
//import SwiftUI
//import Combine
//import AVFoundation
//
//struct RecAnimationView: View {
//    //    @EnvironmentObject var GlobalStore: globalStore
//    @ObservedObject var vm: VoiceViewModel
//    @ObservedObject var rt: RemainingTimeModel
//    @State private var blueCircleOffset: CGSize = .init(width: -40, height: 0)
//    @State private var yellowCircleOffset: CGSize = .init(width: 80, height: 40)
//    //    @Binding var remainingTime: TimeInterval // Set the initial remaining time here
//    @State private var blurSize : Double = 50
//    
//    //    @State private var isRecEnd = false
//    
//    @State var circleX_1: CGFloat = 1.0
//    @State var circleX_2: CGFloat = 1.0
//    @State var circleY_1: CGFloat = 1.0
//    @State var circleY_2: CGFloat = 1.0
//    @Binding var decibels : CGFloat
//    
//    // record에서도 사용해야함
//    var timer3 = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // Timer to decrement the remaining time
//    
//    let audioRecorder = try! AVAudioRecorder(
//        url: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("audio.m4a"), // 녹음 파일의 저장 경로
//        settings: [
//            AVFormatIDKey: Int(kAudioFormatMPEG4AAC), // 오디오 인코딩 포맷 설정
//            AVSampleRateKey: 44100, // 샘플 레이트 설정
//            AVNumberOfChannelsKey: 1, // 채널 수 설정
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue // 오디오 인코딩 품질 설정
//        ])
//    
//    var body: some View {
//        ZStack{
//            //            Color("JoyDarkG")
//            //                .ignoresSafeArea()
//            VStack {
//                ZStack {
//                    
//                    Circle()
//                        .fill(Color("JoyBlue"))
//                        .frame(width: circleX_1 * 175, height: circleY_1 * 175) //데시벨 값에 따라서 크기수정 되게 GlobalStore.circle
//                        .animation(.linear(duration: 0.5).delay(0.5))
//                    //                        .frame(width: 175, height: 175)
//                        .offset(blueCircleOffset)
//                        .blur(radius: blurSize)
//                    
//                    Circle()
//                        .fill(Color("JoyYellow"))
//                        .frame(width: circleX_2 * 120, height: circleY_2 * 120) //데시벨 값에 따라서 크기수정 되게 GlobalStore.circle
//                        .animation(.linear(duration: 0.5).delay(0.5))
//                    //                        .frame(width: 120, height: 120)
//                        .offset(yellowCircleOffset)
//                        .blur(radius: blurSize)
//                    
//                    VStack{
//                        Text("Decibels: \(Int(decibels))")
//                            .font(.headline)
//                            .padding()
//                        Text("Remaining Time : \(Int(rt.remainingTime))")
//                            .font(.headline)
//                            .padding()
//                    }
//                    
//                }
//                
//                //                Text("Remaining Time: \(Int(remainingTime))")
//                //                    .font(.headline)
//                //                    .padding()
//                
//                //                Button("RecEnd") {
//                //                    vm.isEndRecording.toggle()
//                //                    remainingTime = 0
//                //                }
//            }
//        }
//        .onAppear {
//            animateCircles()
//        }
//        .onAppear { // 뷰가 생성될 때(setup 함수 대체) 실행할 블록
//            setUpRecord() // 녹음 세팅 설정
//        }
//        .onReceive(timer3) { _ in
//            
//            if rt.remainingTime > 0 {
//                rt.remainingTime -= 1
//                
//                if Int(rt.remainingTime) % 3 == 0 { // Move the circles randomly every 5 seconds
//                    withAnimation(Animation.easeInOut(duration: 2)) {
//                        blueCircleOffset = getRandomOffset()
//                        yellowCircleOffset = getRandomOffset()
//                        blurSize = (rt.remainingTime/7) + 10
//                        //블러 사이즈 비례
//                        
//                    }
//                } else if Int(rt.remainingTime)-297 > 0 {
//                    withAnimation(Animation.easeInOut(duration: 2)) {
//                        blueCircleOffset = .init(width: 20, height: 60)
//                        yellowCircleOffset = .init(width: 50, height: 00)
//                        blurSize = (rt.remainingTime/7) + 10
//                    }
//                }
//            }else if Int(rt.remainingTime) == 0{
//                withAnimation(Animation.easeInOut(duration: 3)) {
//                    blueCircleOffset = .init(width: -40, height: 0)
//                    yellowCircleOffset = .init(width: 70, height: 70)
//                    blurSize = 10
//                }
//            }
//        }
//        
//        
//    }
//    
//    func animateCircles() {
//        if rt.remainingTime > 0 {
//            withAnimation(Animation.easeInOut(duration: 2)) {
//                blueCircleOffset = getRandomOffset()
//                yellowCircleOffset = getRandomOffset()
//                rt.remainingTime -= 1
//                
//                if Int(rt.remainingTime) % 3 == 0 { // Move the circles randomly every 5 seconds
//                    withAnimation(Animation.easeInOut(duration: 2)) {
//                        blueCircleOffset = getRandomOffset()
//                        yellowCircleOffset = getRandomOffset()
//                        blurSize = (rt.remainingTime/7) + 10
//                        //블러 사이즈 비례d
//                        
//                    }
//                } else if Int(rt.remainingTime)-297 > 0 {
//                    withAnimation(Animation.easeInOut(duration: 2)) {
//                        blueCircleOffset = .init(width: 20, height: 60)
//                        yellowCircleOffset = .init(width: 50, height: 00)
//                        blurSize = (rt.remainingTime/7) + 10
//                    }
//                }
//            }
//        }else if Int(rt.remainingTime) == 0{
//            withAnimation(Animation.easeInOut(duration: 3)) {
//                blueCircleOffset = .init(width: -40, height: 0)
//                yellowCircleOffset = .init(width: 70, height: 70)
//                blurSize = 10
//            }
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + rt.remainingTime) {
//            animateCircles()
//            circleSize()
//        }
//    }
//    
//    func circleSize(){
//        if decibels < 28 {
//            self.circleX_1 = 0.8
//            self.circleY_1 = 0.8
//            self.circleX_2 = 1.2
//            self.circleY_2 = 1.2
//        } else if decibels > 28 {
//            self.circleX_1 = 1.0
//            self.circleY_1 = 1.0
//            self.circleX_2 = 1.0
//            self.circleY_2 = 1.0  //데시벨 값에 따라서 크기수정 되게 GlobalStore.circle
//        }
//    }
//    
//    func getRandomOffset() -> CGSize {
//        let x = CGFloat.random(in: -50...80)
//        let y = CGFloat.random(in: -60...60)
//        return CGSize(width: x, height: y)
//    }
//    
//    
//    func setUpRecord() { // 녹음 세팅을 설정하는 함수
//        try! AVAudioSession.sharedInstance().setCategory(.record) // 녹음 모드로 세팅
//        try! AVAudioSession.sharedInstance().setActive(true) // 오디오 세션 활성화
//        audioRecorder.prepareToRecord() // 녹음 준비
//        audioRecorder.isMeteringEnabled = true // 녹음 시 미터링 기능 사용
//        audioRecorder.record() // 녹음 시작
//        
//        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in // 0.1초 간격으로 실행되는 타이머 생성
//            record() // record() 메서드 호출
//        }
//    }
//    
//    func record() { // 녹음을 실행하고 데시벨 값을 업데이트하는 함수
//        audioRecorder.updateMeters() // 미터링 값을 업데이트
//        decibels = -CGFloat(audioRecorder.averagePower(forChannel: 0)) // 현재 데시벨 값을 decibels 속성에 저장
//    }
//}
//
//
////struct RecAnimationView_Previews: PreviewProvider {
////    static var previews: some View {
////        RecAnimationView()
////    }
////}
