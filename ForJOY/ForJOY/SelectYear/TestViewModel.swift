//
//  TestViewModel.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/08.
//

import SwiftUI

class TestViewModel: ObservableObject {
    @Published var testData: [TestModel] = [
        TestModel(tagName: "조이한", image: Image("test1"), year: "2023", idx: 1),
        TestModel(tagName: "조이서", image: Image("test3"), year: "2023", idx: 2),
        TestModel(tagName: "조이서", image: Image("test4"), year: "2022", idx: 1),
        TestModel(tagName: "조이한", image: Image("test2"), year: "2021", idx: 1)
    ]
    
    @Published var testName: [String : Bool] = [
        "조이한" : false,
        "조이서" : false
    ]
}
