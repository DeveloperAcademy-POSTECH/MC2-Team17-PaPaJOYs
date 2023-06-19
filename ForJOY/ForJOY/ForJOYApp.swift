//
//  ForJOYApp.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/02.
//

// 2023/06/19 dev 브랜치 생성

import SwiftUI

@main
struct ForJOYApp: App {
    @State var linkActive = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                NavigationLink(destination: VoiceView()
                    .navigationBarBackButtonHidden(),
                               isActive: $linkActive) {
                    EmptyView()
                }
                SelectYearView()
                    .background(Color("JoyDarkG"))
            }
            .accentColor(Color("JoyWhite"))
            .onOpenURL { url in
                guard url.scheme == "forjoy" else { return }
                linkActive = true
            }
        }
    }
}

