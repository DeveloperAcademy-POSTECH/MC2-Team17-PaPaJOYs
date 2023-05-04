//
//  Home.swift
//  ForJOY
//
//  Created by Sunjoo IM on 2023/05/03.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var model: CarouselViewModel
    var body: some View {
        VStack {
            HStack {
                Button(action: {}, label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.gray)
                })
                Text("Health TIps")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.leading)
                
                Spacer()
            }
            .padding()
            
            // Carousel....
            
            ZStack {
                
                ForEach(model.cards.indices.reversed(), id: \.self){index in
                    model.cards[index].cardColor
                }
            }
            
            Spacer()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
