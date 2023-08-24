//
//  ContentView.swift
//  SoundVisualizer
//
//  Created by 조호식 on 2023/08/23.
//

import SwiftUI

let svNumberOfSamples: Int = 40

struct SoundVisualizer: View {
    @ObservedObject private var mic = MicrophoneMonitor(numberOfSamples: svNumberOfSamples)
    
    private func svNormalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 4 // between 0.1 and 25
        
        return CGFloat(level * (80 / 25)) // scaled to max at 300 (our height of our bar)
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(mic.svSoundSamples.indices, id: \.self) { index in
                    BarView(value: self.svNormalizeSoundLevel(level: mic.svSoundSamples[index]), index: index)
                }
            }
            .frame(width: 218, height: 35)
            .clipped()
        }
    }
}

//struct SoundVisualizer_Previews: PreviewProvider {
//    static var previews: some View {
//        SoundVisualizer()
//    }
//}
