
import SwiftUI
import AVFoundation

struct CardView: View {
    @Binding var filteredData: [PostModel]
    @Binding var players: [AVPlayer]
    
    var cardGroup: [AnyView] {
        if filteredData.isEmpty {
            return []
        } else {
            return filteredData.enumerated().map { (i, post) in
                let player = players[i]
                return AnyView(CardSubView(imageName: post.imageName, title: post.title, date: post.date, player: player))
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color("JoyDarkG")
                .ignoresSafeArea()
            CarouselView(players: $players, itemHeight: 520, views: cardGroup)
        }
    }
}

struct CardSubView: View {
    @ObservedObject var postViewModel = PostViewModel()
    @State private var isPlaying = false
    @State private var currentTime: Double = 0.0
    @State private var remainingTime: Double = 0.0
    @State private var currentAmount: CGFloat = 0
    
    let imageName: String
    let title: String
    let date: String
    
    // 플레이어 방식 고민 필요
    var player: AVPlayer
    
    var body: some View {
        VStack{
            Image(imageName)
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
            
            VStack(spacing: 3) {
                Text(title)
                    .font(.title3)
                    .bold()
                    .frame(width: 300, alignment: .leading)
                    .allowsTightening(true)
                    .padding(.leading, 51)
                Text(date)
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

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
