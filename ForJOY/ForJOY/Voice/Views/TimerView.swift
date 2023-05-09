//
//  oliveView.swift
//  ForJOY
//
//  Created by Sehui Oh on 2023/05/02.
//

import SwiftUI


struct TimerView: View {

    @ObservedObject var vm = VoiceViewModel()
    @State var isRecOn : Bool = false
    @State var remainingTime: TimeInterval = 30.0
    @State var settingTime =  30.0
    @State var isRecEnd : Bool = false
    @State var recProgress : Double = 0.0

    let timer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()


    func timeString(from time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
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
                            RecAnimationView(remainingTime: $remainingTime)
                                .mask{
                                    Circle()
                                        .frame(width: 240, height: 240)
                                        .blur(radius: 10)
                                }
                            
                            if vm.isRecording && !vm.isEndRecording {
                                
                                Button(action: {
                                    remainingTime = 0.0
                                    recProgress = 1.0
                                    vm.isRecording = false
                                    vm.isEndRecording = true
                                    vm.stopRecording()
                                }){
                                    Text("End")
                                        .padding(120)
                                    
                                }
                            }else if !vm.isRecording && vm.isEndRecording {
                                
                            }
                            
                            
                        }
                    }
                        
                        //timer count
//                        Text("\(timeString(from: remainingTime))")
//                            .foregroundColor(Color("JoyBlue"))
//                            .font(.system(size:40,weight: .medium))
                    CircularProgressView(recProgress : $recProgress)
                        
                        
                    }//Zstack1 END

                Text("Progress \(recProgress)") // 임시로 표기
                Text("Time\(timeString(from: remainingTime))") // 임시로 표기
                Text("isEndRecording? \(vm.isEndRecording ? "true":"false")")
                Text("isRecording? \(vm.isRecording ? "true":"false")")

            }//Vstack1 END

            
        }//Zstack2 END
                        .onReceive(timer2) { _ in
                            if !vm.isEndRecording{
                                if vm.isRecording && remainingTime > 0 {
                    remainingTime -= 1
                    recProgress += (1/settingTime)
                } else if remainingTime <= 0 {
                    vm.isRecording = false
                    vm.isEndRecording = true
                    vm.stopRecording()
                }
            }
        }




        }//Body End

    }//Struct END



    struct TimerView_Previews: PreviewProvider {
        static var previews: some View {
            TimerView()
        }
    }
