//
//  TestModel.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/03.
//

import SwiftUI

struct TestModel: Identifiable {
    let tagName: String
    let images: [Image]
    
    let id = UUID()
}

class TestViewModel: ObservableObject {
    @Published var testData: [TestModel] = [
        TestModel(tagName: "이한", images: [Image("test1"), Image("test2")]),
        TestModel(tagName: "이서", images: [Image("test3"), Image("test4")])
    ]
}
