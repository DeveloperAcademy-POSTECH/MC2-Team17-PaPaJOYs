//
//  ContentView.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/02.
//

// new version test

import SwiftUI

struct ContentView: View {
    @StateObject var homeHomel = CarouselViewModel()
    var body: some View {
        Home()
        // Using it as Environment Object...
//            .environmentObject(homeModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
