//
//  CardView.swift
//  CarouselTutorial
//
//  Created by Sunjoo IM on 2023/05/04.
//

import SwiftUI
import AVFoundation

struct CardView: View {
    
    @State private var isPlaying = false
    
    var body: some View {
        
        ZStack {
            Color("JoyDarkG")
                .ignoresSafeArea()
            
            CarouselView(itemHeight: 520, views: [
                // Card 1
                AnyView(CardSubView()),
                
                // Card 2
                AnyView(
                    VStack{
                        Image("2")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .clipped()
                            .shadow(radius: 3)
                            .padding()
                            .padding(.top)
                        
                        VStack {
                            Text("마운틴듀 와앙~")
                                .font(.title3)
                                .bold()
                                .frame(width: 300, alignment: .leading)
                                .allowsTightening(true)
                                .padding(.leading, 51)
                            Text("2023.05.03")
                                .foregroundColor(Color("JoyLightG"))
                                .frame(width: 300, alignment: .leading)
                                .padding(.leading, 51)
                            
                        }
                        
                        HStack(spacing: 10){
                            Spacer().frame(width: 14)
                            
                            Button {
                                isPlaying.toggle()
                            } label: {
                                Label("Toggle Play", systemImage: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .font(.system(size: 30))
                                    .foregroundColor(isPlaying ? Color("JoyYellow") : Color("JoyBlue"))
                            }
                            
                            ProgressView(value: 0.3)
                            
                            Text("01:24")
                                .foregroundColor(Color("JoyLightG"))
                            
                            Spacer().frame(width: 16)
                        }
                        
                        Spacer()
                    }
                ),
                // Card 3
                AnyView(
                    VStack{
                        Image("3")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .clipped()
                            .shadow(radius: 3)
                            .padding()
                            .padding(.top)
                        
                        VStack {
                            Text("마조리카 아기")
                                .font(.title3)
                                .bold()
                                .frame(width: 300, alignment: .leading)
                                .allowsTightening(true)
                                .padding(.leading, 51)
                            Text("2023.05.03")
                                .foregroundColor(Color("JoyLightG"))
                                .frame(width: 300, alignment: .leading)
                                .padding(.leading, 51)
                            
                        }
                        
                        HStack(spacing: 10){
                            Spacer().frame(width: 14)
                            
                            Button {
                                isPlaying.toggle()
                            } label: {
                                Label("Toggle Play", systemImage: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .font(.system(size: 30))
                                    .foregroundColor(isPlaying ? Color("JoyYellow") : Color("JoyBlue"))
                            }
                            
                            ProgressView(value: 0.3)
                            
                            Text("01:24")
                                .foregroundColor(Color("JoyLightG"))
                            
                            Spacer().frame(width: 16)
                        }
                        
                        Spacer()
                    }
                ),
                // Card 4
                AnyView(
                    VStack{
                        Image("4")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .clipped()
                            .shadow(radius: 3)
                            .padding()
                            .padding(.top)
                        
                        VStack {
                            Text("아기상어 스티커 덕지덕지 아기")
                                .font(.title3)
                                .bold()
                                .frame(width: 300, alignment: .leading)
                                .allowsTightening(true)
                                .padding(.leading, 51)
                            Text("2023.05.03")
                                .foregroundColor(Color("JoyLightG"))
                                .frame(width: 300, alignment: .leading)
                                .padding(.leading, 51)
                            
                        }
                        
                        HStack(spacing: 10){
                            Spacer().frame(width: 14)
                            
                            Button {
                                isPlaying.toggle()
                            } label: {
                                Label("Toggle Play", systemImage: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .font(.system(size: 30))
                                    .foregroundColor(isPlaying ? Color("JoyYellow") : Color("JoyBlue"))
                            }
                            
                            ProgressView(value: 0.3)
                            
                            Text("01:24")
                                .foregroundColor(Color("JoyLightG"))
                            
                            Spacer().frame(width: 16)
                        }
                        
                        Spacer()
                    }
                ),
                // Card 5
                AnyView(
                    VStack{
                        Image("5")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .clipped()
                            .shadow(radius: 3)
                            .padding()
                            .padding(.top)
                        
                        VStack {
                            Text("카와이 아기😍")
                                .font(.title3)
                                .bold()
                                .frame(width: 300, alignment: .leading)
                                .allowsTightening(true)
                                .padding(.leading, 51)
                            Text("2023.05.03")
                                .foregroundColor(Color("JoyLightG"))
                                .frame(width: 300, alignment: .leading)
                                .padding(.leading, 51)
                            
                        }
                        
                        HStack(spacing: 10){
                            Spacer().frame(width: 14)
                            
                            Button {
                                isPlaying.toggle()
                            } label: {
                                Label("Toggle Play", systemImage: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .font(.system(size: 30))
                                    .foregroundColor(isPlaying ? Color("JoyYellow") : Color("JoyBlue"))
                            }
                            
                            ProgressView(value: 0.3)
                            
                            Text("01:24")
                                .foregroundColor(Color("JoyLightG"))
                            
                            Spacer().frame(width: 16)
                        }
                        
                        Spacer()
                    }
                ),
                // Card 6
                AnyView(
                    VStack{
                        GeometryReader { geo in
                            Image("6")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 270, height: 360)
                                .border(.red)
                                .cornerRadius(10)
                                .clipped()
                                .shadow(radius: 3)
                                .padding()
                                .padding(.top)
                                .frame(width: geo.size.width, height: geo.size.height)
                        }
                        
                        VStack {
                            Text("사진 사이즈 조정 어떻게하니")
                                .font(.title3)
                                .bold()
                                .frame(width: 300, alignment: .leading)
                                .allowsTightening(true)
                                .padding(.leading, 51)
                            Text("2023.05.03")
                                .foregroundColor(Color("JoyLightG"))
                                .frame(width: 300, alignment: .leading)
                                .padding(.leading, 51)
                            
                        }
                        
                        HStack(spacing: 10){
                            Spacer().frame(width: 14)
                            
                            Button {
                                isPlaying.toggle()
                            } label: {
                                Label("Toggle Play", systemImage: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .font(.system(size: 30))
                                    .foregroundColor(isPlaying ? Color("JoyYellow") : Color("JoyBlue"))
                            }
                            
                            ProgressView(value: 0.3)
                            
                            Text("01:24")
                                .foregroundColor(Color("JoyLightG"))
                            
                            Spacer().frame(width: 16)
                        }
                        
                        Spacer()
                    }
                ),
                // Card 7
                AnyView(
                    VStack{
                        GeometryReader { geo in
                            Image("7")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 250, height: 360)
                                .border(.red)
                                .cornerRadius(10)
                                .clipped()
                                .shadow(radius: 3)
                                .padding()
                                .padding(.top)
                                .frame(width: geo.size.width, height: geo.size.height)
                        }
                        
                        VStack {
                            Text("사진 크기 어케 맞추니")
                                .font(.title3)
                                .bold()
                                .frame(width: 300, alignment: .leading)
                                .allowsTightening(true)
                                .padding(.leading, 51)
                            Text("2023.05.03")
                                .foregroundColor(Color("JoyLightG"))
                                .frame(width: 300, alignment: .leading)
                                .padding(.leading, 51)
                            
                        }
                        
                        HStack(spacing: 10){
                            Spacer().frame(width: 14)
                            
                            Button {
                                isPlaying.toggle()
                            } label: {
                                Label("Toggle Play", systemImage: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .font(.system(size: 30))
                                    .foregroundColor(isPlaying ? Color("JoyYellow") : Color("JoyBlue"))
                            }
                            
                            ProgressView(value: 0.3)
                            
                            Text("01:24")
                                .foregroundColor(Color("JoyLightG"))
                            
                            Spacer().frame(width: 16)
                        }
                        
                        Spacer()
                    }
                )
            ])
        }
    }
}


struct CardSubView: View {
    
    let player = AVPlayer(url : URL(fileURLWithPath: Bundle.main.path(forResource: "Overnight", ofType: "mp3")!))
    
    @State private var isPlaying = false
    @State private var currentTime: Double = 0.0
    @State private var remainingTime: Double = 0.0
    @State private var currentAmount: CGFloat = 0
    
    var body: some View {
            
        VStack{
            
            Image("1")
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .clipped()
                .shadow(radius: 3)
                .padding()
                .padding(.top)
                .scaleEffect(1 + currentAmount)
            // Pinch Zoom
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            currentAmount = value - 1
                        }
                        .onEnded { value in
                            currentAmount = 0
                        }
                )
                .zIndex(1.0)

            VStack {
                Text("애플디벨로퍼아카데미 @포스텍")
                    .font(.title3)
                    .bold()
                    .frame(width: 300, alignment: .leading)
                    .allowsTightening(true)
                    .padding(.leading, 51)
                Text("2023.05.03")
                    .foregroundColor(Color("JoyLightG"))
                    .frame(width: 300, alignment: .leading)
                    .padding(.leading, 51)
                
            }
            
            HStack(spacing: -8) {
                
                Spacer().frame(width: 29)
                
                Button(action: {
                    if isPlaying {
                        player.pause()
                    } else {
                        player.play()
                    }
                    isPlaying.toggle()
                }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 30))
                        .foregroundColor(isPlaying ? Color("JoyYellow") : Color("JoyBlue"))
                }
                
                Slider(value: $currentTime, in: 0...remainingTime)
                    .accentColor(Color("JoyBlue"))
                    .frame(width: 160)
                    .padding(.horizontal)
                    .onChange(of: currentTime) { time in
                        let cmTime = CMTime(seconds: time, preferredTimescale: 1)
                        player.seek(to: cmTime)
                    }
                
                    Text(timeString(time: remainingTime - currentTime))
                    .font(.system(size: 16))
                    .frame(width: 40)
                        .foregroundColor(Color("JoyLightG"))
                        .padding(.trailing)
                
                Spacer().frame(width: 14)
            }
            .onAppear {
                player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { time in
                    currentTime = time.seconds
                    remainingTime = player.currentItem?.duration.seconds ?? 0.0
                }
            }

            
            Spacer()
        }
    }
    
    func timeString(time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
        
    }
}
