
import SwiftUI
import AVFoundation

struct CardView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var players: [AVPlayer]
    @State var isPlaying = false
    @State var moveToInfoView = false
    @State var isShowAlert = false
    @State var order: Int
    
    let cardWidth = UIScreen.width - 70
    let cardHeight = (UIScreen.width - 104) / 3 * 4 + 132
    
    var filteredData: [Memory]
    
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
                
                VStack {
                    CarouselView(carouselLocation: $order, players: $players, isPlaying: $isPlaying, itemWidth: cardWidth, itemHeight: cardHeight, views: cardGroup)
                        .padding(.top, -50)
                    
                    Spacer()
                }
                
                NavigationLink(
                    isActive: $moveToInfoView,
                    destination: {
                        EditInfoView(selectedData: filteredData[order%filteredData.count])
                    },
                    label: {
                        EmptyView()
                    })
            }
            .onDisappear {
                for p in players {
                    p.pause()
                    p.currentItem?.seek(to: CMTime.zero, completionHandler: nil)
                }
                isPlaying = false
            }
            
            .alert(
                "정말로 삭제하시겠습니까?",
                isPresented: $isShowAlert,
                actions: {
                    Button("취소", role: .cancel) {
                        isShowAlert = false
                    }
                    Button("삭제", role: .destructive) {
                        //TODO: DB 삭제
                        CoreDataManager.coreDM.deleteMemory(filteredData[order].objectID)
                    }
                }, message: {
                    Text("한 번 삭제된 추억은 복구가 불가능합니다.")
                }
            )
            .navigationBarBackButtonHidden()
            .navigationBarItems(leading: BackButton)
            .navigationBarItems(trailing: EditButton)
        }
    }
    
    private var BackButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.joyBlueL)
        }
    }
    
    private var EditButton: some View {
        Menu {
            Button(
                action: {
                    moveToInfoView = true
                }, label: {
                    HStack {
                        Text("편집")
                        Spacer(minLength: 0)
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 17))
                    }
                }
            )
            
            Button(
                role: .destructive,
                action: {
                    isShowAlert = true
                }, label: {
                    HStack {
                        Text("삭제")
                        Spacer(minLength: 0)
                        Image(systemName: "trash")
                            .font(.system(size: 17))
                    }
                }
            )
        } label: {
            Image(systemName: "ellipsis")
                .foregroundColor(Color.joyBlue)
        }
    }
}

class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    @Binding var isPlaying: Bool
    
    init(isPlaying: Binding<Bool>) {
        _isPlaying = isPlaying
        super.init()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
}

struct CardContentView: View {
    @State private var currentTime: Double = 0.0
    @State private var remainingTime: Double = 0.0
    
    @Binding var isPlaying: Bool
    
    let imageName: String
    let title: String
    let date: String
    var player: AVPlayer
    
    init(imageName: String, title: String, date: String, player: AVPlayer, isPlaying: Binding<Bool>) {
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
    
    @State private var audioDelegate: AudioPlayerDelegate? = nil

    
    var body: some View {
        VStack(spacing: 7) {
            ImageView(imageName: imageName)
            
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title3)
                        .foregroundColor(Color.joyDarkG)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Text(date)
                        .foregroundColor(Color.joyLightG)
                }
                .padding(.leading, 27)
                
                Spacer()

                Button(action: {
                    if isPlaying {
                        player.pause()
                    } else {
                        // If player finished playing, seek to the beginning
                        if player.currentTime() == player.currentItem?.duration {
                            player.seek(to: CMTime.zero)
                        }
                        player.play()
                    }
                    isPlaying.toggle()
                }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 50))
                        .foregroundColor(isPlaying ? Color.joyYellow : Color.joyBlue)
                }
                .padding(.trailing, 20)
                .onAppear {
                    // Add notification to handle playback finished
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                        isPlaying = false
                    }
                }
            }
            .padding(.bottom, 21)
        }
    }
}

struct ImageView: View {
    let imageName: String
    let imageWidth = UIScreen.width - 104
    var body: some View {
        //TODO: 대체 이미지 ("house" 말고)
        Image(uiImage: UIImage(data: Data(base64Encoded: imageName)!) ?? UIImage(systemName: "house")!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imageWidth, height: imageWidth / 3 * 4)
            .clipped()
            .cornerRadius(10)
            .shadow(radius: 3)
            .padding(17)
    
    }
}
