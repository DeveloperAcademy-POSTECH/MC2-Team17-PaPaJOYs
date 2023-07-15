//
//  VoiceView.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/03.
//

import SwiftUI
import PhotosUI

struct VoiceView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var voiceViewModel = VoiceViewModel()
    
    @State private var effect1 = false
    @State private var effect2 = false
    @State var recording: URL?
    @State var isChoosen = false
    
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        NavigationStack{
            ZStack{
                TimerView(vm: voiceViewModel)
                VStack {
                    Spacer()
                    Button(action: {
                        isChoosen = true
                    }, label: {
                        if !voiceViewModel.isRecording && voiceViewModel.isEndRecording {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color("JoyWhite"))
                                .frame(width: screenWidth * 0.9, height: 60)
                                .overlay(
                                    Text("완료")
                                        .font(.system(size: 16))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("JoyDarkG"))
                                )
                        }
                    })
                    .frame(width: 400, height: 250)
                    .onChange(of: voiceViewModel.recording) { newValue in
                        recording = newValue
                    }
                }

                NavigationLink(
                    destination: InfoView(selectedImage: $selectedImage, recording: $recording)
                        .navigationBarBackButtonHidden()
                        .environment(\.managedObjectContext, viewContext)
                        .environmentObject(voiceViewModel)
                    ,
                    isActive: $isChoosen
                ){}
                .isDetailLink(false)
            }
        }
        
    }
}
