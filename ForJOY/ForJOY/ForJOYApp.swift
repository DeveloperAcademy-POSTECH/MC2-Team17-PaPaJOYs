//
//  ForJOYApp.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/02.
//

// 2023/06/19 dev 브랜치 생성

import SwiftUI

//TODO: 온보딩 끝나고 필요한 권한 받기
@main
struct ForJOYApp: App {
    @State var linkActive = false
    @State var image: UIImage? = nil
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                NavigationLink(destination: VoiceView(selectedImage: $image)
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

