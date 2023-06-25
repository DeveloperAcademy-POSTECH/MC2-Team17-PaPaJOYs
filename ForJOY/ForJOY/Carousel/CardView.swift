
import SwiftUI
import AVFoundation

struct CardView: View {
    @Binding var players: [AVPlayer]
    @State var isPlaying = false
    
    var filteredData: [Memory]
    let order: Int
    
    var cardGroup: [AnyView] {
        if filteredData.isEmpty {
            return []
        } else {
            return filteredData.enumerated().map { (i, post) in
                return AnyView(CardContentView(imageName: post.image, title: post.title, date: post.date.toString(dateFormat: "yyyy.MM.dd"), player: players[i], isPlaying: $isPlaying))
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
                    p.currentItem?.seek(to: CMTime.zero, completionHandler: nil)
                }
                isPlaying = false
            }
        }
    }
}

struct CardContentView: View {
    @State private var currentTime: Double = 0.0
    @State private var remainingTime: Double = 0.0
    
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
            ImageView(imageName: imageName)
            
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
}

struct ImageView: View {
    let imageName: Data
    
    var body: some View {
        Image(uiImage: UIImage(data: imageName)!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 300, height: 400)
            .clipped()
            .cornerRadius(10)
            .shadow(radius: 3)
            .padding()
            .padding(.top)
    }
}

