//
//  TestModel.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/03.
//

import SwiftUI

struct TestModel: Identifiable {
    let tagName: String
    let image: Image
    let year: String
    let idx: Int
    
    let id = UUID()
}

struct TestYearModel: Identifiable {
    let tagName: String
    let image: Image
    
    let id = UUID()
}
