//
//  ContentView.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/02.
//

// ContentView 지우지 말아주세요!!
// 각자 작업한 뷰 연결 전까진 앱 시작점은 ContentView로 두겠습니다!!

import SwiftUI

struct ContentView: View {
    @AppStorage("widgetLaunched") private var widgetLaunched = false
        
        var body: some View {
            if widgetLaunched {
                VoiceView()
            } else {
                SelectYearView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
