//
//  BarView.swift
//  SoundVisualizer
//
//  Created by 조호식 on 2023/08/24.
//

import SwiftUI

struct BarView: View {
    var value: CGFloat
    var index: Int // 인덱스도 받도록 수정

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [index % 2 == 0 ? Color.joyBlue : Color.joyYellow, index % 2 == 0 ? Color.joyBlue : Color.joyYellow]),
                                     startPoint: .top,
                                     endPoint: .bottom))
                .frame(width: 2, height: value)
        }
    }
}
