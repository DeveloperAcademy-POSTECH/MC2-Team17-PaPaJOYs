//
//  RecAnimationView.swift
//  ForJOY
//
//  Created by Sehui Oh on 2023/05/04.
//

import SwiftUI


struct RecAnimationView: View {
//    @EnvironmentObject var GlobalStore: globalStore
    @State private var blueCircleOffset: CGSize = .init(width: -40, height: 0)
    @State private var yellowCircleOffset: CGSize = .init(width: 80, height: 40)
    @State private var remainingTime: Double = 300.0 // Set the initial remaining time here
    @State private var blurSize : Double = 50
    @State private var isRecEnd = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // Timer to decrement the remaining time
    
    var body: some View {
        ZStack{
            Color("JoyDarkG")
                .ignoresSafeArea()
            VStack {
                ZStack {
                    Circle()
                        .fill(Color("JoyBlue"))
//                        .frame(width: GlobalStore.circleX_1 * 175, height: GlobalStore.circleY_1 * 175) //데시벨 값에 따라서 크기수정 되게 GlobalStore.circle
                        .frame(width: 175, height: 175)
                        .offset(blueCircleOffset)
                        .blur(radius: blurSize)
                    
                    Circle()
                        .fill(Color("JoyYellow"))
//                        .frame(width: GlobalStore.circleX_2 * 120, height: GlobalStore.circleY_2 * 120) //데시벨 값에 따라서 크기수정 되게 GlobalStore.circle
                        .frame(width: 120, height: 120)
                        .offset(yellowCircleOffset)
                        .blur(radius: blurSize)
                }
                Text("Remaining Time: \(Int(remainingTime))")
                    .font(.headline)
                    .padding()
                Button("RecEnd") {
                    isRecEnd.toggle()
                    remainingTime = 10
                }
            }
        }
        .onAppear {
            animateCircles()
        }
        .onReceive(timer) { _ in
            
            if remainingTime > 0 {
                remainingTime -= 1
                
                if Int(remainingTime) % 3 == 0 { // Move the circles randomly every 5 seconds
                    withAnimation(Animation.easeInOut(duration: 7)) {
                        blueCircleOffset = getRandomOffset()
                        yellowCircleOffset = getRandomOffset()
                        blurSize = (remainingTime/7) + 10
                        //블러 사이즈 비례
                        
                    }
                } else if Int(remainingTime)-297 > 0 {
                    withAnimation(Animation.easeInOut(duration: 7)) {
                        blueCircleOffset = .init(width: 20, height: 60)
                        yellowCircleOffset = .init(width: 50, height: 00)
                        blurSize = (remainingTime/7) + 10
                    }
                }
            }else if Int(remainingTime) == 0{
                withAnimation(Animation.easeInOut(duration: 3)) {
                    blueCircleOffset = .init(width: -40, height: 0)
                    yellowCircleOffset = .init(width: 70, height: 70)
                    blurSize = 0
                }
            }
        }
//        .onReceive(GlobalStore.$decibels) { value in  //데시벨 값에 따라서 크기수정 되게 GlobalStore.circle
//            if value < 40 {
//                self.GlobalStore.circleX_1 = 2.0
//                self.GlobalStore.circleY_1 = 2.0
//                self.GlobalStore.circleX_2 = 1.0
//                self.GlobalStore.circleY_2 = 1.0
//            } else if value > 40 {
//                self.GlobalStore.circleX_1 = 1.0
//                self.GlobalStore.circleY_1 = 1.0
//                self.GlobalStore.circleX_2 = 2.0
//                self.GlobalStore.circleY_2 = 2.0  //데시벨 값에 따라서 크기수정 되게 GlobalStore.circle
//            }
//        }

        
    }
    
    func animateCircles() {
        if remainingTime > 0 {
            withAnimation(Animation.easeInOut(duration: 4)) {
                blueCircleOffset = getRandomOffset()
                yellowCircleOffset = getRandomOffset()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + remainingTime) {
            animateCircles()
        }
    }
    
    func getRandomOffset() -> CGSize {
        let x = CGFloat.random(in: -50...80)
        let y = CGFloat.random(in: -60...60)
        return CGSize(width: x, height: y)
    }
}


struct RecAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        RecAnimationView()
    }
}
