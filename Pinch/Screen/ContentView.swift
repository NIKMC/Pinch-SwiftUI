//
//  ContentView.swift
//  Pinch
//
//  Created by Ivan Nikitin on 30.05.2023.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    
    var pages: [Page]
    @State private var pageIndex: Int = 1
    
    //MARK: -
    
    var imagePage: some View {
        Image(currentPage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(12)
            .padding()
            .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
            .opacity(isAnimating ? 1 : 0)
            .offset(x: imageOffset.width, y: imageOffset.height)
            .scaleEffect(imageScale)
            .onTapGesture(count: 2, perform:  {
                if imageScale == 1 {
                    withAnimation(.spring()) {
                        imageScale = 5
                    }
                } else {
                    resetImageState()
                }
            })
        // MARK: - Drag Gesture
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        withAnimation(.linear(duration: 0.5)) {
                            imageOffset = value.translation
                            
                        }
                    })
                    .onEnded({ _ in
                        if imageScale <= 1 {
                            resetImageState()
                        } else {
                            
                        }
                    })
            )
        //MARK: Magnification
        
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        withAnimation(.linear(duration: 1)) {
                            if imageScale >= 1 && imageScale <= 5 {
                                imageScale = value
                            } else {
                                if imageScale > 5 {
                                    imageScale = 5
                                }
                            }
                        }
                    }
                    .onEnded { _ in
                        if imageScale > 5 {
                            imageScale = 5
                        } else if imageScale <= 1 {
                            resetImageState()
                        }
                    }
            )
    }
    
    var controlPannel: some View {
        Group {
            HStack {
                
                //Scale Down
                Button {
                    withAnimation(.spring()) {
                        if imageScale > 1 {
                            imageScale -= 1
                            if imageScale <= 1 {
                                resetImageState()
                            }
                        }
                    }
                } label: {
                    ControllImageView(icon: "minus.magnifyingglass")
                }
                
                //Reset
                Button {
                    resetImageState()
                } label: {
                    ControllImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                }
                
                //Scale Up
                Button {
                    withAnimation(.spring()) {
                        if imageScale < 5 {
                            imageScale += 1
                            
                            if imageScale > 5 {
                                imageScale = 5
                            }
                        }
                    }
                } label: {
                    ControllImageView(icon: "plus.magnifyingglass")
                }
            }
            .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
            .background(.ultraThinMaterial)
            .opacity(isAnimating ? 1 : 0)
            .cornerRadius(8)
            
        }.padding(.bottom, 30)
    }
    
    var thumbnailSection: some View {
        HStack(spacing: 12) {
            Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .padding(8)
                .foregroundStyle(.secondary)
                .onTapGesture ( perform: {
                    withAnimation(.easeOut) {
                        isDrawerOpen.toggle()
                    }
                })
            
            // MARK: - Thumbnails
            ForEach(pages, id: \.ID) { item in
                Image(item.thumbnailName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .opacity(isDrawerOpen ? 1 : 0)
                    .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                    .onTapGesture {
                        isAnimating = true
                        pageIndex = item.id
                    }
            }
            
            Spacer()
        }
            .padding(EdgeInsets(top: 16, leading: 8, bottom: 26, trailing: 8))
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .opacity(isAnimating ? 1 : 0)
            .frame(width: 260)
            .padding(.top, UIScreen.main.bounds.height / 12)
            .offset(x: isDrawerOpen ? 20 : 215)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                
                imagePage
            }
            .navigationTitle("Pinch&Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            })
            //MARK: - InfoPannel
            
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                ,
                alignment: .top
            )
            //MARK: - Controls
            
            .overlay(
                controlPannel
                ,
                alignment: .bottom
            )
            //MARK: - Drawer
            
            .overlay(
                thumbnailSection
                ,
                alignment: .topTrailing
            )
        }
        .navigationViewStyle(.stack)
        
    }
    
    // MARK: - Functions
    
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
//    func prepareThumbnail(of size: CGSize, completionHandler: @escaping (UIImage?) -> Void)
    
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
    
    
}


//MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(pages: PagesData.pagesData)
    }
}
