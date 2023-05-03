//
//  CircularProgressView.swift
//  ForJOY
//
//  Created by Sehui Oh(olive) on 2023/05/03.
//

import SwiftUI


struct CircularProgressView: View {

    @Binding var recProgress: Double

    var body: some View {


        ZStack{

            Circle() // Progress 1
                .stroke(
                    Color("JoyBlue").opacity(0.5),
                    lineWidth: 2)
                .frame(width: 260)
            Circle() // Progress 2
                .trim(from: 0, to: recProgress)
                .stroke(
                    Color("JoyBlue"),
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round))
                    .frame(width: 260)
                    .rotationEffect(.degrees(-90))//What Degree is Proper? Clockwise?
                    .animation(.easeInOut(duration: 2), value: recProgress)
        }
    }//Body End
}//Struct End

//struct CircularProgressView_Previews: PreviewProvider {
//    static var previews: some View {
//        CircularProgressView()
//    }
//}
