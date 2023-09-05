//
//  InfoView.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/09.
//

import SwiftUI
import Photos

struct InfoView: View {
    @State private var title: String = ""
    @State private var date = Date()
    @State private var tag: String?
    @State private var toAddDoneView = false
    @State private var isAddData: Bool = false
    @State private var pushBackButton = false
    @State private var showTagView = false
    
    @Binding var selectedImage: UIImage?
    @Binding var recording: URL?
    @Binding var pageNumber: Int
    
    var body: some View {
        NavigationStack {
            VStack{
                if selectedImage != nil {
                    GeometryReader { geometry in
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width - 30, height: geometry.size.height)
                            .cornerRadius(10)
                            .clipped()
                            .padding(.horizontal, 15)
                            .padding(.top, 25)
                    }
                } else {
                    Text("No image")
                }
                
                List {
                    HStack{
                        Text("제목")
                        Spacer(minLength: 0)
                        TextField("제목", text: $title)
                            .font(.system(size: (17.0 - CGFloat(title.count)*0.3)))
                            .multilineTextAlignment(.trailing)
                            .onChange(of: title) { newValue in
                                title = String(newValue.prefix(20))
                            }
                            .padding(.trailing, 4)
                    }
                    .listRowBackground(Color.joyWhite)
                    
                    HStack(){
                        Text("태그")
                            .frame(width: 60, alignment: .leading)
                        
                        Spacer(minLength: 0)
                        
                        Button(
                            action: {showTagView = true},
                            label: {
                                if tag == nil {
                                    Text("없음 \(Image(systemName: "chevron.right"))")
                                        .frame(maxWidth: 250, alignment: .trailing)
                                        .foregroundColor(.black)
                                }else {
                                    Text("\(tag!)\(Image(systemName: "chevron.right"))")
                                        .frame(maxWidth: 250, alignment: .trailing)
                                        .foregroundColor(.black)
                                }
                            }
                        )
                    }
                    .listRowBackground(Color.joyWhite)
                    
                    DatePicker(
                        "날짜",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    .tint(Color.joyBlue)
                    .listRowBackground(Color.joyWhite)
                }
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
            }
            .background(Color.joyDarkG)
            .foregroundColor(.black)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton)
            .navigationBarItems(trailing: DoneButton)
            
            .alert("다시 녹음하시겠습니까?", isPresented: $pushBackButton, actions: {
                Button("취소", role: .cancel) { }
                Button("다시 녹음", role: .destructive) { pageNumber = 0 }
            }, message: {
                Text("재녹음 시 이전에 녹음된 정보는 삭제됩니다.")
            })
            
            .sheet(isPresented: $showTagView) {
                InfoTagView(selectTag: $tag, showTagView: $showTagView)
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    private var BackButton: some View {
        Button {
            pushBackButton = true
        } label: {
            Text("\(Image(systemName: "chevron.backward")) 다시 녹음")
                .foregroundColor(.joyBlue)
        }
    }
    
    private var DoneButton: some View {
        Button {
            if !isAddData {
                if title != "" {
                    doneAction()
                    isAddData = true
                }
            }
            pageNumber = 2
        } label: {
            Text("완료")
                .foregroundColor(title == "" ? .gray : Color.joyBlue)
        }
        .disabled(title == "")
    }
}

extension InfoView {
    func doneAction() {
        let year = Int(date.toString(dateFormat: "yyyy"))!
        
        CoreDataManager.coreDM.addMemory(title, Int16(year), date, tag ?? "없음", selectedImage!.jpegData(compressionQuality: 0.8)!.base64EncodedString(), recording!.absoluteString)
        saveImage()
    }

    func saveImage() {
        let albumName = "forJoy"
        
        guard let image = selectedImage,
              let data = image.jpegData(compressionQuality: 1) else {
            return
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let folders = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)
        
        var albumFound = false
        folders.enumerateObjects { collection, index, stop in
            if let assetCollection = collection as? PHAssetCollection {
                albumFound = true
                saveImageToAlbum(imageData: data, album: assetCollection)
                stop.pointee = true
            }
        }
        
        if !albumFound {
            var albumPlaceholder: PHObjectPlaceholder?
            PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { success, error in
                if success, let placeholder = albumPlaceholder {
                    let createdAlbum = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                    if let album = createdAlbum.firstObject {
                        saveImageToAlbum(imageData: data, album: album)
                    }
                } else if let error = error {
                    print("Error creating album: \(error.localizedDescription)")
                }
            })
        }
    }

    func saveImageToAlbum(imageData: Data, album: PHAssetCollection) {
        var placeholder: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAsset(from: UIImage(data: imageData)!)
            let assetPlaceholder = request.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
            albumChangeRequest?.addAssets([assetPlaceholder] as NSArray)
            placeholder = assetPlaceholder
        }, completionHandler: { success, error in
            if success {
                print("Image saved to album")
            } else if let error = error {
                print("Error saving image: \(error.localizedDescription)")
            }
        })
    }
}
