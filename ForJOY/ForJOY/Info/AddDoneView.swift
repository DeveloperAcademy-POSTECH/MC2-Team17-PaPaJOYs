//
//  AddDoneView.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/11.
//

import SwiftUI

struct AddDoneView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Text("This is Last Page.")
        
        Button(action: {
        }, label: {
            NavigationLink(
                destination: SelectYearView()
                    .navigationBarBackButtonHidden())
            {
            Text("Main으로 돌아가기")
                .foregroundColor(Color.white)
                .frame(width: 100, height: 60, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 10)
                .fill(Color.purple))
                }
        })
    }
}
