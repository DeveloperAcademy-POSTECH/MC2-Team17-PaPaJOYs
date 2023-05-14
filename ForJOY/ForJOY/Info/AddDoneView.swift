//
//  AddDoneView.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/11.
//

import SwiftUI

struct AddDoneView: View {
    var body: some View {
        VStack{
            LottieView(jsonName: "SaveComplete")
                .frame(width: 1000, height: 1000)
            Text("추억이 저장되었어요")
                .foregroundColor(Color("JoyWhite"))
        }
    }
}

struct AddDoneView_Previews: PreviewProvider {
    static var previews: some View {
        AddDoneView()
    }
}
