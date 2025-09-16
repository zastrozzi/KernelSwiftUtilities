//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 13/03/2025.
//

import Foundation
import SwiftUI

fileprivate struct Item: Identifiable {
    var id: UUID = .init()
    var title: String
    var type: PushType
    var color: Color
    var symbol: String
}

fileprivate let items: [Item] = [
    .init(title: "Book Icon", type: .sheet, color: .red, symbol: "book.fill"),
    .init(title: "Stack Icon", type: .navigation, color: .blue, symbol: "square.stack.3d.up"),
    .init(title: "Rectangle Icon", type: .fullScreenCover, color: .orange, symbol: "rectangle.portrait")
]

fileprivate enum PushType: String {
    case sheet = "Sheet"
    case navigation = "Navigation Link"
    case fullScreenCover = "Full Screen Cover"
}


fileprivate struct Animation1: View {
    var body: some View {
        List {
            ForEach(items) { item in
                CardView1(item: item)
            }
        }
    }
}

fileprivate struct CardView1: View {
    var item: Item

    @State private var expandSheet: Bool = false
    var body: some View {
        HStack(spacing: 12) {
            ImageView()
                .matchedGeometrySource(item.id.uuidString + "Animation 1")
            
            
            Text(item.title)
            
            Spacer(minLength: 0)
        }
        .contentShape(.rect)
        .onTapGesture {
            expandSheet.toggle()
        }
        .sheet(isPresented: $expandSheet, content: {
            HStack {
                Button {
                    expandSheet.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .contentShape(.rect)
                }
                
                Spacer(minLength: 0)
                ImageView()
                    .matchedGeometryDestination(item.id.uuidString + "Animation 1")
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .interactiveDismissDisabled()
        })
        .matchedGeometryLayer(id: item.id.uuidString + "Animation 1", animate: $expandSheet) {
            ImageView()
        } completion: { _ in
            
        }
    }
    
    @ViewBuilder
    func ImageView() -> some View {
        Image(systemName: item.symbol)
            .font(.title2)
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(item.color.gradient, in: .circle)
    }
}

fileprivate struct Animation2: View {
    var body: some View {
        List {
            ForEach(items) { item in
                CardView2(item: item)
            }
        }
    }
}

/// Card View
fileprivate struct CardView2: View {
    var item: Item
    @State private var expandSheet: Bool = false
    var body: some View {
        HStack(spacing: 12) {
            ImageView()
                .matchedGeometrySource(item.id.uuidString + "Animation 2")
            Text(item.type.rawValue)
            Spacer(minLength: 0)
        }
        .contentShape(.rect)
        .onTapGesture {
            expandSheet.toggle()
        }
        .pushView(item.type, isPresented: $expandSheet, content: {
            if item.type == .sheet {
                ImageView(isDetail: true)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .cornerRadius(20)
                    .matchedGeometryDestination(item.id.uuidString + "Animation 2")
                    .padding()
                    .presentationBackground(Color.clear)
            } else {
                VStack(spacing: 25) {
                    if item.type != .navigation {
                        HeaderView()
                    }
                    
                    ImageView(isDetail: true)
                        .matchedGeometryDestination(item.id.uuidString + "Animation 2")
                        
                        .navigationTitle(item.type.rawValue)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    expandSheet.toggle()
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: "chevron.left")
                                            .font(.callout)
                                        
                                        Text("Back")
                                    }
                                }
                            }
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
            }
        })
        .matchedGeometryLayer(id: item.id.uuidString + "Animation 2", animate: $expandSheet, sourceCornerRadius: 20, destinationCornerRadius: 20) {
            ImageView(isLayerView: true)
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        Button {
            expandSheet = false
        } label: {
            Image(systemName: "xmark")
                .font(.title3)
                .contentShape(.rect)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay {
            Text(item.type.rawValue)
        }
    }
    
    @ViewBuilder
    func ImageView(isDetail: Bool = false, isLayerView: Bool = false) -> some View {
        if isLayerView {
            Image(systemName: item.symbol)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(item.color.gradient)
        } else {
            Image(systemName: item.symbol)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(maxWidth: isDetail ? .infinity : nil, maxHeight: isDetail ? .infinity : nil)
                .frame(width: isDetail ? nil : 40, height: isDetail ? nil : 40)
                .background(item.color.gradient, in: .rect(cornerRadius: isDetail ? 20 : 30))
        }
    }
}

extension View {
    @ViewBuilder
    fileprivate func pushView<Content: View>(_ type: PushType, isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        switch type {
        case .sheet:
            self
                .sheet(isPresented: isPresented, content: {
                    content()
                        .presentationDetents([.medium, .fraction(0.99)])
//                        .interactiveDismissDisabled()
                })
        case .navigation:
            self
                .navigationDestination(isPresented: isPresented) {
                    content()
                        .navigationBarBackButtonHidden()
                }
        case .fullScreenCover:
            self
                .fullScreenCover(isPresented: isPresented, content: {
                    content()
                })
        }
    }
}

fileprivate struct MatchedGeometryPreviewView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    Animation1()
                        .navigationTitle("Effect 1")
                } label: {
                    Text("Animation 1")
                }
                
                NavigationLink {
                    Animation2()
                        .navigationTitle("Effect 2")
                } label: {
                    Text("Animation 2")
                }
            }
            .navigationTitle("Matched Geometry")
        }
    }
}

#Preview {
    MatchedGeometryPreviewView()
        .matchedGeometryWrapper(isPreview: true)
}
