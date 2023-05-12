
import SwiftUI
import AVFoundation

struct CardView: View {
    @ObservedObject var cardViewModel = CardViewModel()
    @State private var isPlaying = false
    
    var cardGroup: [AnyView] {
        cardViewModel.cardData.map{ AnyView(CardSubView(imageName: $0.recordImage, title: $0.recordName, date: $0.recordDate, recordName: $0.recordAudio)) }
    }
    
    var body: some View {
        
        ZStack {
            Color("JoyDarkG")
                .ignoresSafeArea()
            
            CarouselView(itemHeight: 520, views: cardGroup)
        }
    }
}


struct CardSubView: View {
    
    @State private var isPlaying = false
    @State private var currentTime: Double = 0.0
    @State private var remainingTime: Double = 0.0
    @State private var currentAmount: CGFloat = 0
    
    let imageName: String
    let title: String
    let date: String
    let recordName: String
    
    var player: AVPlayer?
    
    init(imageName: String, title: String, date: String, recordName: String) {
        self.imageName = imageName
        self.title = title
        self.date = date
        self.recordName = recordName
        self.player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: recordName, ofType: "mp3")!))
    }
    
    var body: some View {
        VStack{
            Image(imageName) // 이미지 파일 이름 : "1"
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
                Text(title) // 게시물 제목 : "애플디벨로퍼아카데미 @포스텍"
                    .font(.title3)
                    .bold()
                    .frame(width: 300, alignment: .leading)
                    .allowsTightening(true)
                    .padding(.leading, 51)
                Text(date)  // 등록 날짜 : "2023.05.03"
                    .foregroundColor(Color("JoyLightG"))
                    .frame(width: 300, alignment: .leading)
                    .padding(.leading, 51)
                
            }
            
            HStack(spacing: -8) {
                
                Spacer().frame(width: 29)
                
                Button(action: {
                    if isPlaying {
                        player!.pause()
                    } else {
                        player!.play()
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
                        player!.seek(to: cmTime)
                    }
                
                Text(timeString(time: remainingTime - currentTime))
                    .font(.system(size: 16))
                    .frame(width: 40)
                    .foregroundColor(Color("JoyLightG"))
                    .padding(.trailing)
                
                Spacer().frame(width: 14)
            }
            .onAppear {
                player!.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { time in
                    currentTime = time.seconds
                    remainingTime = player!.currentItem?.duration.seconds ?? 0.0
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
