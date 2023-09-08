//
//  CustomImagePicker.swift
//  ForJOY
//
//  Created by hyebin on 2023/09/07.
//

import SwiftUI
import PhotosUI

extension View {
    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        self
        .frame(width: size.width, height: size.height)
    }
}

struct CropView: View {
    @Environment(\.dismiss) private var dismiss
    
    var image: UIImage?
    @Binding var showCropView: Bool
    var onCrop: (UIImage?, Bool) -> ()
    
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false
    
    var body: some View {
        NavigationStack {
            ImageView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background (Color.black.ignoresSafeArea())
                .navigationTitle("이동 및 크기 조절")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        HStack {
                            Button("취소"){
                                dismiss()
                            }
                            
                            Spacer(minLength: 0)
                            
                            Button("선택"){
                                let renderer = ImageRenderer(content: ImageView(true))
                                renderer.proposedSize = .init(CGSize(width: 346, height: 459))
                                
                                if let image = renderer.uiImage {
                                    onCrop(image, true)
                                } else {
                                    onCrop(nil, false)
                                }
                                
                                showCropView = false
                            }
                        }
                        .foregroundColor(.white)
                    }
                }
        }
    }
    
    @ViewBuilder
    func ImageView(_ hideGrids: Bool = false) -> some View {
        GeometryReader {
            let size = $0.size
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay() {
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .named("CROPVIEW"))
                            
                            Color.clear
                                .onChange(of: isInteracting) { newValue in
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if rect.minX > 0 {
                                            offset.width = offset.width - rect.minX
                                        }
                                        if rect.minY > 0 {
                                            offset.height = offset.height - rect.minY
                                        }
                                        if rect.maxX < size.width {
                                            offset.width = rect.minX - offset.width
                                        }
                                        if rect.maxY < size.height {
                                            offset.height = rect.minY - offset.height
                                        }
                                    }
                                    
                                    if !newValue {
                                        lastStoredOffset = offset
                                    }
                                }
                        }
                    }
                    .frame(size)
            }
        }
        .scaleEffect(scale)
        .offset(offset)
        .overlay {
            if !hideGrids {
                Grids()
            }
        }
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting) { _, out, _  in
                    out = true
                }
                .onChanged { value in
                    let translation = value.translation
                    offset = CGSize(
                        width: translation.width+lastStoredOffset.width,
                        height: translation.height+lastStoredOffset.height
                    )
                }
        )
        .gesture(
            MagnificationGesture()
                .updating($isInteracting) { _, out, _  in
                    out = true
                }
                .onChanged { value in
                    let updatedScale = value + lastScale
                    scale = (updatedScale < 1 ? 1 : updatedScale)
                }
                .onEnded { value in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if scale < 1 {
                            scale = 1
                            lastScale = 0
                        } else {
                            lastScale = scale-1
                        }
                    }
                }
        )
        .frame(width: 346, height: 459)
        .cornerRadius(0)
    }
    
    @ViewBuilder
    func Grids() -> some View {
        ZStack {
            HStack {
                ForEach(1...5, id: \.self) { _ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(width: 1)
                        .frame(maxWidth: .infinity)
                }
            }
            
            VStack {
                ForEach(1...8, id: \.self) { _ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(height: 1)
                        .frame(maxHeight: .infinity)
                }
            }
        }
    }
}
