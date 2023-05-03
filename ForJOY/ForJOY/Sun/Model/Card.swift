//
//  Card.swift
//  ForJOY
//
//  Created by Sunjoo IM on 2023/05/03.
//

import SwiftUI

// Card Model...

struct Card: Identifiable {
    
    var id = UUID().uuidString
    var cardColor: Color
    var offset: CGFloat = 0
    var title: String
}
