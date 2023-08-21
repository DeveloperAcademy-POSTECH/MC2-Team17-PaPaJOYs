//
//  InfoView.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/09.
//

import SwiftUI
import PhotosUI


struct InfoView: View {
    @State var title: String = ""
    @State var date = Date()
    @State var tag: String?
    @State var toAddDoneView = false
    @State var isAddData: Bool = false
    @State private var pushBackButton = false
    
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
                        Spacer(minLength: 100)
                        TextField("제목", text: $title)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: title) { newValue in
                                title = String(newValue.prefix(20))
                            }
                    }
                    .listRowBackground(Color("JoyWhite"))
                    
                    HStack(){
                        Text("태그")
                            .frame(width: 60, alignment: .leading)
                        Spacer(minLength: 190)
                        NavigationLink(destination: InfoTagView(selectTag: $tag), label: {
                            if tag == nil {
                                Text("없음")
                                    .frame(width: 60, alignment: .trailing)
                            }else {
                                Text(tag!)
                                    .frame(width: 60, alignment: .trailing)
                            }
                        })
                    }
                    .listRowBackground(Color("JoyWhite"))
                    
                    DatePicker(
                        "날짜",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    .tint(Color("JoyBlue"))
                    .listRowBackground(Color("JoyWhite"))
                }
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
            }
            .background(Color("JoyDarkG"))
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
        }
    }
    
    private var BackButton: some View {
        Button {
            pushBackButton = true
        } label: {
            Text("\(Image(systemName: "chevron.backward")) 다시 녹음")
        }
    }
    
    private var DoneButton: some View {
        Button {
            saveImage()
            
            if !isAddData {
                if title != "" {
                    doneAction()
                    isAddData = true
                }
            }
            pageNumber = 2
        } label: {
            Text("완료")
        }
        .disabled(title == "")
    }
    
    func saveImage() {
        guard let imageData = selectedImage!.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        let folderName = "ForJoy"
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", folderName)
        let folders = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)
        
        if let folder = folders.firstObject {
            // Folder found, save the image to the folder
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: imageData, options: nil)
                let placeholder = creationRequest.placeholderForCreatedAsset
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: folder)
                albumChangeRequest?.addAssets([placeholder] as NSFastEnumeration)
            } completionHandler: { _, _ in
                // Image saved successfully to the folder
            }
        } else {
            PHPhotoLibrary.shared().performChanges {
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: folderName)
            } completionHandler: { success, error in
                if success {
                    let fetchOptions = PHFetchOptions()
                    fetchOptions.predicate = NSPredicate(format: "title = %@", folderName)
                    let createdFolders = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)
                    if let createdFolder = createdFolders.firstObject {
                        let creationRequest = PHAssetCreationRequest.forAsset()
                        creationRequest.addResource(with: .photo, data: imageData, options: nil)
                        let placeholder = creationRequest.placeholderForCreatedAsset
                        let albumChangeRequest = PHAssetCollectionChangeRequest(for: createdFolder)
                        albumChangeRequest?.addAssets([placeholder] as NSFastEnumeration)
                    }
                } else {
                }
            }
        }
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
