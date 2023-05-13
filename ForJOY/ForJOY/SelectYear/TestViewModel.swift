//
//  TestViewModel.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/08.
//

import SwiftUI

class TestViewModel: ObservableObject {
    @Published var testData: [TestModel] = [
        TestModel(tagName: "조이한", imageName: "test1", year: "2023", idx: 1),
        TestModel(tagName: "조이한", imageName: "test2", year: "2021", idx: 1),
        TestModel(tagName: "조이한", imageName: "test3", year: "2020", idx: 1),
        TestModel(tagName: "조이한", imageName: "test4", year: "2019", idx: 1),
        TestModel(tagName: "조이서", imageName: "test5", year: "2023", idx: 2),
        TestModel(tagName: "조이서", imageName: "test6", year: "2022", idx: 2),
        TestModel(tagName: "조이서", imageName: "test7", year: "2020", idx: 2),
        TestModel(tagName: "고양이", imageName: "test8", year: "2017", idx: 1)
    ]
}
