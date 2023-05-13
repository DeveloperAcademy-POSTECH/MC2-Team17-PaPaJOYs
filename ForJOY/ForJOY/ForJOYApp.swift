//
//  ForJOYApp.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/02.
//

import SwiftUI

@main
struct ForJOYApp: App {
//    var GlobalStore = globalStore() //GlobalStore.swift 의 ObservableObject/Published
    var body: some Scene {
        WindowGroup {
            // 본인 뷰로 테스트 후 커밋할 때 제외하거나 ContentView로 돌려놓기!!!!!
            ContentView()
//            CameraView()
//                .environmentObject(GlobalStore) //GlobalStore.swift 의 ObservableObject/Published
                .environmentObject(GlobalStore) //GlobalStore.swift 의 ObservableObject/Published
//            SelectYearView()
//                .accentColor(.white)
        }
    }
}

