//
//  CarouselViewmodel.swift
//  ForJOY
//
//  Created by Sunjoo IM on 2023/05/03.
//

import SwiftUI

class CarouselViewModel: ObservableObject {
    
    @Published var cards = [
        Card(cardColor: Color("blue"), title: "Neurobics for your mind."),
        Card(cardColor: Color("purple"), title: "Brush up on hygine."),
        Card(cardColor: Color("green"), title: "Don't skip breakfast."),
        Card(cardColor: Color.yellow, title: "Brush up on hygine."),
        Card(cardColor: Color.orange, title: "Neurobics for your mind.")
    ]
    
}

