//  CircularProgressView.swift
//  ForJOY
//
//  Created by Sehui Oh(olive) on 2023/05/03.
//
import SwiftUI


struct CircularProgressView: View {
    @Binding var recProgress: Double
    @Binding var progressOpacity : Double

    var body: some View {
        ZStack{
            Circle()
                .stroke(
                    Color.joyBlue.opacity(progressOpacity),
                    lineWidth: 1
                )
                .frame(width: 260)
            
            Circle() 
                .trim(from: 0, to: recProgress)
                .stroke(
                    Color.joyBlue.opacity(progressOpacity),
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round)
                )
                .frame(width: 260)
                .rotationEffect(.degrees(-90))//What Degree is Proper? Clockwise?
                .animation(.easeInOut(duration: 2), value: recProgress)
        }
    }
}
