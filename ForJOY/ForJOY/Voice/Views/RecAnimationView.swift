//
//  RecAnimationView.swift
//  ForJOY
//
//  Created by Sehui Oh on 2023/05/04.
//

import SwiftUI


struct RecAnimationView: View {
    
    @State private var blueCircleOffset: CGSize = .init(width: -20, height: 0)
    @State private var yellowCircleOffset: CGSize = .init(width: 50, height: 60)
     @State private var remainingTime: Double = 30.0 // Set the initial remaining time here
    @State private var blurSize : Double = 10
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
                         .frame(width: 175, height: 175)
                         .offset(blueCircleOffset)
                         .blur(radius: blurSize)
                     
                     Circle()
                         .fill(Color("JoyYellow"))
                         .frame(width: 120, height: 120)
                         .offset(yellowCircleOffset)
                         .blur(radius: blurSize)
                 }
                 Text("Remaining Time: \(Int(remainingTime))")
                     .font(.headline)
                     .padding()
                 Button("RecEnd") {
                        isRecEnd.toggle()
                        remainingTime = 0
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
                     withAnimation(Animation.easeInOut(duration: 8)) {
                         blueCircleOffset = getRandomOffset()
                         yellowCircleOffset = getRandomOffset()
                     }
                 } else if Int(remainingTime)-297 > 0 {
                     withAnimation(Animation.easeInOut(duration: 8)) {
                         blueCircleOffset = .init(width: 20, height: 60)
                         yellowCircleOffset = .init(width: 50, height: 00)
                     }
                 }
             }else if Int(remainingTime) == 0{
                 withAnimation(Animation.easeInOut(duration: 4)) {
                     blueCircleOffset = .init(width: -20, height: 0)
                     yellowCircleOffset = .init(width: 50, height: 60)
                 }
             }
         }
     }
     
     func animateCircles() {
         if remainingTime > 0 {
             withAnimation(Animation.easeInOut(duration: 5)) {
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
