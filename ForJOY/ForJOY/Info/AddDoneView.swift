//
//  AddDoneView.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/11.
//

import SwiftUI

struct AddDoneView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.joyBlack
                    .ignoresSafeArea()
                ZStack{
                    VStack{
                        Spacer()
                        LottieView(jsonName: "SaveComplete2")
                            .frame(width: 500, height: 500)
                    }
                    .frame(width: 400, height: 650)
                    
                    VStack{
                        Spacer()
                        Text("소중한 추억이 인화되었어요")
                            .foregroundColor(Color.joyWhite)
                        
                    }
                    .frame(width: 400, height: 300)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    dismiss()
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}
