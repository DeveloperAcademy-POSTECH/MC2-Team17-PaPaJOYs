//
//  TestViewModel.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/08.
//

import SwiftUI

class TestViewModel: ObservableObject {
    @Published var testData: [TestModel] = [
        TestModel(tagName: "이한", image: Image("test1"), year: "2023", idx: 1),
        TestModel(tagName: "이서", image: Image("test3"), year: "2023", idx: 2),
        TestModel(tagName: "이서", image: Image("test4"), year: "2022", idx: 1),
        TestModel(tagName: "이한", image: Image("test2"), year: "2021", idx: 1)
    ]
    
    @Published var testName: [String] = ["이한", "이서"]
    
    @Published var yearData: [String: [TestYearModel]] = [
        "2023": [TestYearModel(tagName: "이한", image: Image("tes1")),
                 TestYearModel(tagName: "이서", image: Image("tes3"))],
        "2022": [TestYearModel(tagName: "이한", image: Image("tes2"))],
        "2021": [TestYearModel(tagName: "이서", image: Image("tes4"))],
        "2020": [TestYearModel(tagName: "이한", image: Image("tes2")),
                 TestYearModel(tagName: "이서", image: Image("tes4"))],
    ]
}
