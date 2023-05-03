////
////  oliveView.swift
////  ForJOY
////
////  Created by Sehui Oh on 2023/05/02.
////
//
//import SwiftUI
//
//
//struct oliveView: View {
//
//
//    @State var isRecOn = false
//    @State var remainingTime: TimeInterval = 60.0
//    @State var isRecEnd = false
//    @State var recProgress = 0.0
//
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//
//
//    func timeString(from time: TimeInterval) -> String {
//        let minutes = Int(time) / 60 % 60
//        let seconds = Int(time) % 60
//        return String(format: "%02d:%02d", minutes, seconds)
//    }
//
//
//    var body: some View {
//
//        //Zstack2 START
//        ZStack{
//            //background color
//            Color("JoyDarkG")
//                .ignoresSafeArea()
//
//            //Vstack1 Start
//            VStack{
//
//                Button(action: {
//                    isRecEnd = true
//                    isRecOn = false
//                    recProgress = 1.0
//                    remainingTime = 0.0
//                }){
//                    Text("End")
//
//                }
//                //Zstack1 Start
//                ZStack{
//
//
//                    Button(action: {
//                        isRecOn = true
//                    }){
//                        Text("")
//                            .padding(120)
//                            .overlay(Circle()
//                                .fill(Color("JoyYellow"))
//                                .opacity(1))
//
//                    }
//                    //timer count
//                    Text("\(timeString(from: remainingTime))")
//                        .foregroundColor(Color("JoyBlue"))
//                         .font(.system(size:40,weight: .medium))
//
//                    CircularProgressView(recProgress : $recProgress)
//
//                    //                //Zstack2 START
//                    //                ZStack{
//                    //                                Circle()
//                    //                                    .fill(Color.blue)
//                    //                                    .frame(width: 100)
//                    //                                    .blur(radius: 20)
//                    //
//                    //                                Circle()
//                    //                                    .fill(Color.yellow)
//                    //                                    .frame(width: 70)
//                    //                                    .blur(radius: 20)
//                    //                                    .position(x: 300, y: 450)
//                    //                            }//Zstack2 END
//
//                }//Zstack1 END
//
//                Text("Progress \(recProgress)")
//
//            }//Vstack1 END
//
//        }//Zstack2 END
//                        .onReceive(timer) { _ in
//                            if !isRecEnd{
//                                if isRecOn && remainingTime > 0 {
//                    remainingTime -= 1
//                    recProgress += (1/remainingTime)
//                } else if remainingTime <= 0 {
//                    isRecOn = false
//                    remainingTime = 0.0
//                }
//            }
//        }
//
//
//
//
//        }//Body End
//
//    }//Struct END
//
//
//
//    struct oliveView_Previews: PreviewProvider {
//        static var previews: some View {
//            oliveView()
//        }
//    }
