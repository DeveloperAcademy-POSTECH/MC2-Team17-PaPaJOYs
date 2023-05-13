//
//  CardModel.swift
//  ForJOY
//
//  Created by Sunjoo IM on 2023/05/12.
//


import SwiftUI

struct CardModel: Identifiable, Hashable {
    var recordImage : String
    var recordName: String
    var recordDate : String
    var recordAudio : String
    let idx : Int
    
    let id = UUID()

}
