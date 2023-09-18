
import SwiftUI
import AVFoundation

struct CardView: View {
    @Environment(\.dismiss) private var dismiss
  
    @Binding var players: [AVPlayer]
    @State var isPlaying = false
    @State var moveToInfoView = false
    @State var isShowAlert = false
    @State var order: Int
    
    @Binding var filteredData: [Memory]
    
    let cardWidth = UIScreen.width - 70
    let cardHeight = (UIScreen.width - 104) / 3 * 4 + 132

    var body: some View {
        NavigationStack {
            ZStack {
                Color.joyBlack
                    .ignoresSafeArea()
                
                VStack {
                    CarouselView(carouselLocation: $order, players: $players, isPlaying: $isPlaying, itemWidth: cardWidth, itemHeight: cardHeight, views: $filteredData)
                        .padding(.top, -50)
                    
                    Spacer()
                }
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
                        CoreDataManager.coreDM.deleteMemory(filteredData[order].objectID)
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            filteredData.remove(at: order)
                        }
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
                .foregroundColor(Color.joyBlue)
        }
    }
    
    private var EditButton: some View {
        Menu {
            if filteredData.count > 0 {
                NavigationLink(destination: EditInfoView(selectedData: filteredData[order < 0 ? ((order * -1)%filteredData.count) : (order%filteredData.count)])) {
                    Button(
                        action: {
                            moveToInfoView = true
                        }, label: {
                            HStack {
                                Text("편집")
                                Spacer(minLength: 0)
                                Image(systemName: "square.and.pencil")
                            }
                        }
                    )}
            }
            
            Button(
                role: .destructive,
                action: {
                    isShowAlert = true
                }, label: {
                    HStack {
                        Text("삭제")
                        Spacer(minLength: 0)
                        Image(systemName: "trash")
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
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Font.body1Kor)
                        .foregroundColor(Color.joyBlack)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Text(date)
                        .font(Font.body2)
                        .foregroundColor(Color.joyGrey200)
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
                    Circle()
                        .frame(width: 50)
                        .foregroundColor(isPlaying ? Color.joyYellow : Color.joyGrey100)
                        .overlay {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .foregroundColor(isPlaying ? Color.joyWhite : Color.joyBlue)
                        }
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
        Image(uiImage: UIImage(data: Data(base64Encoded: imageName)!) ?? UIImage(systemName: "EmptyMemory")!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imageWidth, height: imageWidth / 3 * 4)
            .clipped()
            .cornerRadius(10)
            .shadow(radius: 3)
            .padding(17)
    
    }
}
