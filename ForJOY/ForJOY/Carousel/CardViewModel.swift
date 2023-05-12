
import SwiftUI

class CardViewModel: ObservableObject {
    
    @Published var cardData: [CardModel] = [
        CardModel(recordImage: "1", recordName: "애플디벨로퍼아카데미 @포스텍", recordDate: "2023.05.11", recordAudio: "Overnight", idx: 1),
        CardModel(recordImage: "2", recordName: "와앙~~~~~~~~", recordDate: "2023.04.12", recordAudio: "Overnight", idx: 2),
        CardModel(recordImage: "3", recordName: "알 유 마조리카?", recordDate: "2023.03.13", recordAudio: "Overnight", idx: 3),
        CardModel(recordImage: "4", recordName: "아기상어 타투", recordDate: "2023.02.14", recordAudio: "Overnight", idx: 4),
        CardModel(recordImage: "5", recordName: "카와이 베이비😍", recordDate: "2023.01.15", recordAudio: "Overnight", idx: 5),
        CardModel(recordImage: "6", recordName: "사진 사이즈 조정하는법;;", recordDate: "2022.12.16", recordAudio: "Overnight", idx: 6),
        CardModel(recordImage: "7", recordName: "사진 크기ㅜㅜ", recordDate: "2022.11.17", recordAudio: "Overnight", idx: 7),
    ]
}
