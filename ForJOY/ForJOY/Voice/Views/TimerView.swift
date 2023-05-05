//
//  oliveView.swift
//  ForJOY
//
//  Created by Sehui Oh on 2023/05/02.
//

import SwiftUI


struct TimerView: View {


    @State var isRecOn = false
    @State var remainingTime: TimeInterval = 60.0
    @State var isRecEnd = false
    @State var recProgress = 0.0

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()


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
                    
                    if !isRecOn && !isRecEnd {
                        
                        Button(action: {
                            isRecOn = true
                        }){
                            Text("")
                                .padding(120)
                                .overlay(Circle()
                                    .fill(Color("JoyYellow"))
                                    .opacity(1))
                                    
                            
                        }

                    } else if isRecOn && !isRecEnd {
                        Button(action: {
                            isRecEnd = true
                            isRecOn = false
                            recProgress = 1.0
                            remainingTime = 0.0
                        }){
                            Text("")
                                .padding(120)
                                .overlay(Circle()
                                    .fill(Color.red)
                                    .opacity(1))
                        }
                    }
                        
                        //timer count
                        Text("\(timeString(from: remainingTime))")
                            .foregroundColor(Color("JoyBlue"))
                            .font(.system(size:40,weight: .medium))
                        
                        CircularProgressView(recProgress : $recProgress)
                        
                    }//Zstack1 END

                Text("Progress \(recProgress)")

            }//Vstack1 END

        }//Zstack2 END
                        .onReceive(timer) { _ in
                            if !isRecEnd{
                                if isRecOn && remainingTime > 0 {
                    remainingTime -= 1
                    recProgress += (1/remainingTime)
                } else if remainingTime <= 0 {
                    isRecOn = false
                    remainingTime = 0.0
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
