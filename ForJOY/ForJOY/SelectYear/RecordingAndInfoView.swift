//
//  RecordingAndInfoView.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/08/19.
//

import SwiftUI

struct RecordingAndInfoView: View {
    @State private var pageNumber = 0
    @State private var recording: URL?
    @Binding var selectedImage: UIImage?
    
    
    var body: some View {
        ZStack {
            if pageNumber == 0 {
                VoiceView(selectedImage: $selectedImage, recording: $recording, pageNumber: $pageNumber)
            } else if pageNumber == 1 {
                InfoView(selectedImage: $selectedImage, recording: $recording, pageNumber: $pageNumber)
            }
        }
    }
}
