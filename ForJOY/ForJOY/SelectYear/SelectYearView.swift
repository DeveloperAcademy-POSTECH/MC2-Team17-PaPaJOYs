//
//  SelectYearView.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/02.
//

import SwiftUI
import PhotosUI

//TODO: db 비어있으면 비어있다고 알려주기
struct SelectYearView: View {
    @State private var isNewest = true
    @State private var selectedTag = "All"
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("JoyDarkG")
//                Color.white // 버튼 테스트용 배경
                    .ignoresSafeArea()
                
                VStack() {
                    HeaderView(isNewest: $isNewest, selectedTag: $selectedTag)
                        .padding(.top, 5)
                    AlbumView(isNewest: $isNewest, selectedTag: $selectedTag)
                        .padding(10)
                        .ignoresSafeArea()
                }
                
                VStack() {
                    Spacer()
                    PhotoSelectButton()
                }
                .ignoresSafeArea()
            }
        }
    }
}

struct HeaderView: View {
    @Binding var isNewest: Bool
    @Binding var selectedTag: String
    
    var body: some View {
        HStack(spacing: 50) {
            Menu {
                Button(action: {isNewest = true}) {
                    HStack {
                        Text("최근부터 보기")
                        Spacer()
                        if isNewest {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                Button(action: {isNewest = false}) {
                    Text("과거부터 보기")
                    Spacer()
                    if !isNewest {
                        Image(systemName: "checkmark")
                    }
                }
            } label: {
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 25))
                    .foregroundColor(Color("JoyBlue"))
            }
            .padding(.leading, 10)
            
            TagView(selectedTag: $selectedTag)
                .frame(alignment: .trailing)
        }
    }
}

struct TagView: View {
    @StateObject var realmManger = RealmManger()
    @Binding var selectedTag: String
    @State var isAllSelect = true

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                Button {
                    selectedTag = "All"
                    isAllSelect = true
                } label: {
                    Text("모든 태그")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .frame(height: 30)
                        .padding(.leading, 5)
                        .padding(.trailing, 5)
                        .background(isAllSelect ? Color("JoyBlue") : Color("JoyDarkG"))
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .strokeBorder(isAllSelect ? Color("JoyBlue") : Color("JoyWhite"), lineWidth: 1)
                        )
                }

                let tags = realmManger.uniqueTags
                
                ForEach( Array(tags.sorted().filter{$0 != "기본"}) , id: \.self) { i in
                    Button {
                        selectedTag = i
                        isAllSelect = false
                    } label: {
                        Text("#" + i)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .frame(height: 30)
                            .padding(.leading, 5)
                            .padding(.trailing, 5)
                            .background(isAllSelect ? Color("JoyDarkG") : (selectedTag == i ? Color("JoyBlue") : Color("JoyDarkG")))
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                            .overlay(
                                RoundedRectangle(cornerRadius: 7)
                                    .strokeBorder(isAllSelect ? Color("JoyWhite") : (selectedTag == i ? Color("JoyBlue") : Color("JoyWhite")))
                            )
                    }
                }
            }
        }
    }
}

struct PhotoSelectButton: View {
    @State var isShowActionSheet = false
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingActionSheet = false
    @State private var isShowingCameraPicker = false
    @State private var isShowingPhotoLibraryPicker = false
    @State private var isChoosen = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("JoyDarkG").opacity(0), Color("JoyDarkG")], startPoint: .top, endPoint: .bottom)
            
            Button(action: {
                isShowActionSheet = true
            }, label: {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("JoyYellow"))
                    .frame(width: 350, height: 55)
                    .overlay {
                        HStack {
                            Image(systemName: "plus")
                                .font(.system(size: 15))
                                .foregroundColor(Color("JoyDarkG"))
                            Text("새로운 추억 기록하기")
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .foregroundColor(Color("JoyDarkG"))
                        }
                    }
            })
            .confirmationDialog("photo", isPresented: $isShowActionSheet) {
                Button(action: {
                    isShowingCameraPicker = true
                }, label: {
                    Text("사진 찍으러 가기")
                        .foregroundColor(Color("JoyBlue"))
                })
                .background(Color("JoyWhite"))

                Button(action: {
                    isShowingPhotoLibraryPicker = true
                }, label: {
                    Text("사진 고르러 가기")
                        .foregroundColor(Color("JoyBlue"))
                })
                .background(Color("JoyWhite"))
                
                
                Button(role: .cancel, action: {
                }, label: {
                    Text("Cancel")
                })
            }
            .sheet(isPresented: $isShowingCameraPicker, onDismiss: loadImage) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
                    .ignoresSafeArea()
            }
            .sheet(isPresented: $isShowingPhotoLibraryPicker, onDismiss: loadImage) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
                    .ignoresSafeArea()
                    .tint(Color("JoyBlue"))
            }
        }
        .frame(height: 130)
        
        NavigationLink(
            destination: VoiceView(selectedImage: $selectedImage)
                .navigationBarBackButtonHidden(),
            isActive: $isChoosen
        ){}
        .isDetailLink(false)
    }
    
    func loadImage() {
        if let image = selectedImage {
            saveImage(image)
            isChoosen.toggle()
        }
    }
    func saveImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
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

struct AlbumView: View {
    @StateObject var realmManger = RealmManger()
    @State var memories = [Int: [Memory]]()
    @Binding var isNewest: Bool
    @Binding var selectedTag: String
    
    //TODO: GalleryView에 정렬 옵션 주기 - 변수 생성 및 바인딩 완료, 데이터 정렬 필요
    @State private var isNewestDay = true
    
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 12), count: 2)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                let memories = realmManger.yearlyMemories
                
                if selectedTag == "All" {
                    ForEach(Array(isNewest ? memories.keys.sorted(by: >) : memories.keys.sorted()), id: \.self) { key in
                        NavigationLink(destination: GalleryView(tagName: selectedTag, year: key, album: memories[key]!, isNewestDay: $isNewestDay)
                            .environmentObject(realmManger)) {
                                AlbumSubView(post: memories[key]!.first!)
                            }
                    }
                }else {
                    let filterMemories = memories.reduce(into: [Int: [Memory]]()){ result, entry in
                        let filterdMemories = entry.value.filter {$0.tag == selectedTag}
                        if !filterdMemories.isEmpty {
                            result[entry.key] = filterdMemories
                        }
                    }
                    
                    ForEach(Array(isNewest ? filterMemories.keys.sorted(by: >) : filterMemories.keys.sorted()), id: \.self) { key in
                        NavigationLink(destination: GalleryView(tagName: selectedTag, year: key, album: filterMemories[key]!, isNewestDay: $isNewestDay)
                            .environmentObject(realmManger)) {
                                AlbumSubView(post: filterMemories[key]!.first!)
                            }
                    }
                    
                }
            }
        }
    }
}

struct AlbumSubView: View {
    let post: Memory
    var body: some View {
        ZStack {
            Color("JoyWhite")
            VStack {
                Image(uiImage: UIImage(data: post.image) ?? UIImage(systemName: "house")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screenWidth * 0.4, height: screenWidth * 0.4)
                    .clipped()
                    .cornerRadius(10)
                    .padding(10)
                HStack {
                    Spacer()
                    Text("\(post.year)".replacingOccurrences(of: ",", with: ""))
                        .font(.headline)
                        .foregroundColor(Color("JoyDarkG"))
                        .padding(.top, -10)
                        .padding(.trailing, 15)
                }
                .padding(.bottom, 10)
            }
        }
        .cornerRadius(10)
    }
}
