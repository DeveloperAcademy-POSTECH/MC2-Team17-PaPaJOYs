//
//  AddDoneView.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/11.
//

import SwiftUI

struct AddDoneView: View {
    var body: some View {
        ZStack{
            Color("JoyDarkG")
                .ignoresSafeArea()
            ZStack{
                VStack{
                    LottieView(jsonName: "SaveComplete")
                        .frame(width: 500, height: 500)
                    Spacer()
                }
                .frame(width: 400, height: 600)
                
                VStack{
                    Spacer()
                    Text("소중한 추억이 저장되었어요")
                        .foregroundColor(Color("JoyWhite"))
                }
                .frame(width: 400, height: 300)
            }


        }//Zstack END
    }//BODY END
}//Struct END

struct AddDoneView_Previews: PreviewProvider {
    static var previews: some View {
        AddDoneView()
    }
}
