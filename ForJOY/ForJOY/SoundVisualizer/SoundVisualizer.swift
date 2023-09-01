//
//  ContentView.swift
//  SoundVisualizer
//
//  Created by 조호식 on 2023/08/23.
//

import SwiftUI

// 샘플의 수를 정의합니다. 이 값은 마이크에서 얼마나 많은 사운드 샘플을 가져올지를 결정합니다.
let svNumberOfSamples: Int = 80

struct SoundVisualizer: View {
    // MicrophoneMonitor 객체를 사용하여 마이크의 입력을 모니터링합니다.
    // svNumberOfSamples만큼의 샘플을 모니터링하도록 설정됩니다.
    @StateObject private var mic = MicrophoneMonitor(numberOfSamples: svNumberOfSamples)
    
    // 사운드 레벨을 정규화하는 함수입니다.
    // 이 함수는 입력된 사운드 레벨을 0과 300 사이의 값으로 변환합니다.
    private func svNormalizeSoundLevel(level: Float) -> CGFloat {
        // 사운드 레벨을 0.1과 25 사이의 값으로 정규화합니다.
        let level = max(0.2, CGFloat(level) + 50) / 10
        
        // 위에서 정규화된 값을 0과 300 사이로 확장/변환합니다.
        return CGFloat(level * (150 / 25))
    }
    
    // SoundVisualizer의 본문입니다.
    var body: some View {
        VStack {
            HStack(spacing: 3) {
                // mic.svSoundSamples의 각 샘플에 대하여 BarView를 생성합니다.
                ForEach(mic.svSoundSamples.indices, id: \.self) { index in
                    BarView(value: self.svNormalizeSoundLevel(level: mic.svSoundSamples[index]), index: index)
                }
            }
            .frame(width: 218, height: 35) // HStack의 크기를 설정합니다.
            .clipped() // 뷰의 내용이 경계를 초과할 경우 잘라냅니다.
        }
    }
}


//struct SoundVisualizer_Previews: PreviewProvider {
//    static var previews: some View {
//        SoundVisualizer()
//    }
//}
