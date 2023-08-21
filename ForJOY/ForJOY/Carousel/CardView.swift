
import SwiftUI
import AVFoundation

struct CardView: View {
    @Binding var players: [AVPlayer]
    @State var isPlaying = false
    @State var moveToInfoView = false
    @State var isShowAlert = false
    @State var order: Int
    
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
                CarouselView(carouselLocation: $order, players: $players, isPlaying: $isPlaying, itemHeight: 520, views: cardGroup)
                
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
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    //TODO: Dissmiss
                }
                ToolbarItem(placement: .navigationBarTrailing) {
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
                            .font(.system(size: 25))
                            .foregroundColor(Color("JoyBlue"))
                    }
                }
            }
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
    let imageName: String
    
    var body: some View {
        //TODO: 대체 이미지 ("house" 말고)
        Image(uiImage: UIImage(data: Data(base64Encoded: imageName)!) ?? UIImage(systemName: "house")!)
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
