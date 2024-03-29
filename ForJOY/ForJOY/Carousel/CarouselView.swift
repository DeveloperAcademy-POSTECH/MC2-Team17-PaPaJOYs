// 전체 구조 수정 필요


import SwiftUI
import AVKit

struct CarouselView: View {
    @GestureState private var dragState = DragState.inactive
    @Binding var carouselLocation: Int
    @Binding var players: [AVPlayer]
    @Binding var isPlaying: Bool
    
    var itemWidth: CGFloat
    var itemHeight: CGFloat
    @Binding var views: [Memory]
    
    private func onDragEnded(drag: DragGesture.Value) {
        let dragThreshold:CGFloat = 200
        if drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold{
            carouselLocation = carouselLocation - 1
        } else if (drag.predictedEndTranslation.width) < (-1 * dragThreshold) || (drag.translation.width) < (-1 * dragThreshold)
        {
            carouselLocation = carouselLocation + 1
        }
        for p in players {
            p.pause()
            p.currentItem?.seek(to: CMTime.zero, completionHandler: nil)
        }
        isPlaying = false
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ZStack {
                        ForEach(views.indices, id: \.self) {i in
                            VStack {
                                Spacer()

                                drawCard(views)[i]
                                    .frame(width: itemWidth, height: self.getHeight(i))
                                    .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .shadow(radius: 4)
                                    .opacity(self.getOpacity(i))
                                    .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                                    .offset(x: self.getOffset(i))
                                    .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                                
                                Spacer()
                            }
                        }
                    }
                    .gesture(
                        DragGesture()
                            .updating($dragState) { drag, state, transaction in
                                state = .dragging(translation: drag.translation)
                            }
                            .onEnded(onDragEnded)
                    )
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    Spacer().frame(height: itemHeight + 90)
                    Text("\(relativeLoc() + 1) / \(views.count)")
                        .font(Font.body3)
                        .foregroundColor(Color.joyWhite)
                        .background(Capsule().fill(Color.joyGrey300).frame(width: 50, height: 30))
                    Spacer()
                }
            }
        }
    }
    
    func relativeLoc() -> Int {
        if views.count != 0 {
            return ((views.count * 10000) + carouselLocation) % views.count
        } else {
            return 0
        }
    }
    
    func getHeight(_ i:Int) -> CGFloat{
        if i == relativeLoc(){
            return itemHeight
        } else {
            return itemHeight - 100
        }
    }
    
    func getOpacity(_ i:Int) -> Double{
        if i == relativeLoc()
        {
            return 1
        } else if i + 1 == relativeLoc()
                    || i - 1 == relativeLoc()
                    || i + 2 == relativeLoc()
                    || i - 2 == relativeLoc()
                    || (i + 1) - views.count == relativeLoc()
                    || (i - 1) + views.count == relativeLoc()
                    || (i + 2) - views.count == relativeLoc()
                    || (i - 2) + views.count == relativeLoc()
                    
        {
            return 0.8
        } else {
            return 0
        }
    }
    
    func getOffset(_ i:Int) -> CGFloat{
        if (i) == relativeLoc()
        {
            return self.dragState.translation.width
        }
        
        else if (i) == relativeLoc() + 1
                || (relativeLoc() == views.count - 1 && i == 0)
        {
            return self.dragState.translation.width + (itemWidth + 18)
        }
        else if (i) == relativeLoc() - 1
                || (relativeLoc() == 0 && (i) == views.count - 1)
        {
            return self.dragState.translation.width - (itemWidth + 18)
        }
    
        else if (i) == relativeLoc() + 2
                || (relativeLoc() == views.count - 1 && i == 1)
                || (relativeLoc() == views.count - 2 && i == 0)
        {
            return self.dragState.translation.width + (2 * (itemWidth + 18))
        }
        else if (i) == relativeLoc() - 2
                || (relativeLoc() == 1 && i == views.count - 1)
                || (relativeLoc() == 0 && i == views.count - 2)
        {
            return self.dragState.translation.width - (2 * (itemWidth + 18))
        }
        
        else if (i) == relativeLoc() + 3
                || (relativeLoc() == views.count - 1 && i == 2)
                || (relativeLoc() == views.count - 2 && i == 1)
                || (relativeLoc() == views.count - 3 && i == 0)
        {
            return self.dragState.translation.width + (3 * (itemWidth + 18))
        }
        
        else if (i) == relativeLoc() - 3
                || (relativeLoc() == 2 && i == views.count - 1)
                || (relativeLoc() == 1 && i == views.count - 2)
                || (relativeLoc() == 0 && i == views.count - 3)
        {
            return self.dragState.translation.width - (3 * (itemWidth + 18))
        }
        
        else {
            return 10000
        }
    }
}

extension CarouselView {
    func drawCard(_ data: [Memory]) -> [AnyView] {
        if data.isEmpty {
            return []
        } else {
            let contents = data.enumerated().map { (i, post) in
                return AnyView(CardContentView(imageName: post.image, title: post.title, date: post.date.toString(dateFormat: "yyyy.MM.dd"), player: players[i], isPlaying: $isPlaying))
            }
            return contents
        }
    }
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

