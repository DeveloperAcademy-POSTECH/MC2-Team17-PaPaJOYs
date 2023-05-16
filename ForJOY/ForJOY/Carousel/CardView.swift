
import SwiftUI
import AVFoundation

struct CardView: View {
//    @StateObject var players = Players()
    @Binding var players: [AVPlayer]
    @State var isPlaying = false
    
    var filteredData: [Memory]
    let order: Int
    
    var cardGroup: [AnyView] {
        if filteredData.isEmpty {
            return []
        } else {
            return filteredData.enumerated().map { (i, post) in
                return AnyView(CardSubView(imageName: post.image, title: post.title, date: post.date.toString(dateFormat: "yyyy.MM.dd"), player: players[i], isPlaying: $isPlaying))
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("JoyDarkG")
                    .ignoresSafeArea()
                CarouselView(carouselLocation: order, players: $players, isPlaying: $isPlaying, itemHeight: 520, views: cardGroup)
            }
            .onDisappear {
                for p in players {
                    p.pause()
                    p.currentItem?.seek(to: CMTime.zero)
                }
                isPlaying = false
            }
        }
    }
}

struct CardSubView: View {
    @State private var currentTime: Double = 0.0
    @State private var remainingTime: Double = 0.0
    @State private var currentAmount: CGFloat = 0
    
    @Binding var isPlaying: Bool
    
    
    let imageName: Data
    let title: String
    let date: String
    var player: AVPlayer
    
    init(imageName: Data, title: String, date: String, player: AVPlayer, isPlaying: Binding<Bool>) {
        self.imageName = imageName
        self.title = title
        self.date = date
        self.player = player
        self._isPlaying = isPlaying
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category. Error :\(error)")
        }
    }
    
    var body: some View {
        VStack{
            Image(uiImage: UIImage(data: imageName)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 400)
                .clipped()
                .cornerRadius(10)
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
            
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.title3)
                        .foregroundColor(Color("JoyDarkG"))
                        .bold()
                        .allowsTightening(true)
                    Text(date)
                        .foregroundColor(Color("JoyLightG"))
                }
                .padding(.leading, 20)
                Spacer()
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
                        .font(.system(size: 40))
                        .foregroundColor(isPlaying ? Color("JoyYellow") : Color("JoyBlue"))
                }
                .padding(.trailing, 20)
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

