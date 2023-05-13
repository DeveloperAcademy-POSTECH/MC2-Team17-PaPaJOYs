//
//  PostModel.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/12.
//

import SwiftUI

struct PostModel: Identifiable, Hashable {
    let tagName: String
    let imageName: String
    let audioName: String
    let title: String
    let year: String
    let date: String
    let idx: Int
    
    let id = UUID()
}
