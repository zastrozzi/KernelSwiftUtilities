//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/08/2022.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

#if compiler(>=5.7)
extension NavigationLink {
    public init<Value: Sendable, WrappedDestination>(unwrapping value: Binding<Value?>, @ViewBuilder destination: @escaping (Binding<Value>) -> WrappedDestination, onNavigate: @Sendable @escaping (_ isActive: Bool) -> Void, @ViewBuilder label: @escaping () -> Label) where Destination == WrappedDestination? {
//        self.init(destination: Binding(unwrapping: value).map(destination), isActive: value.isPresent().didSet(onNavigate), label: label)
//        let _ = value.isPresent().didSet(onNavigate)
        if #available(iOS 16.0, *) { preconditionFailure("iOS 16 Deprecated") }
        else {
            self.init(destination: Binding(unwrapping: value).map(destination), isActive: value.isPresent().didSet(onNavigate), label: label)
        }
//        self.init(destination: Binding(unwrapping: value).map { unwrapped in destination(unwrapped).onAppear { onNavigate(true) }.onDisappear { onNavigate(false) } as! WrappedDestination }, label: label)
    }
    
    public init<Enum: Sendable, Case: Sendable, WrappedDestination>(unwrapping bkEnum: Binding<Enum?>, case casePath: KernelCasePath<Enum, Case>, @ViewBuilder destination: @escaping (Binding<Case>) -> WrappedDestination, onNavigate: @Sendable @escaping (Bool) -> Void, @ViewBuilder label: @escaping () -> Label) where Destination == WrappedDestination? {
        self.init(unwrapping: bkEnum.bkCase(casePath), destination: destination, onNavigate: onNavigate, label: label)
    }
}


#if DEBUG
struct NavigationLinkExampleView: View {
    
    struct Post: Identifiable {
        var id: UUID
        var title: String
    }
    
    @State var postToEdit: Post?
    @State var posts: [Post] = [.init(id: .init(), title: "1"), .init(id: .init(), title: "2")]
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(self.posts) { post in
                    NavigationLink(unwrapping: self.$postToEdit) { $draft in
                        EditPostView(post: $draft)
                    } onNavigate: { isActive in
                        MainActor.assumeIsolated {
                            self.postToEdit = isActive ? post : nil
                        }
                    } label: {
                        Text("Navigate to \(post.title)")
                    }
                }
            }
        }
        
    }
    
    struct EditPostView: View {
        @Binding var post: Post
        
        var body: some View {
            Text("EditPostView - \(post.title)")
        }
    }
}

struct NavigationLinkEnumExampleView: View {
    
    struct Post: Identifiable {
        var id: UUID
        var title: String
    }
    
    enum Route {
        case edit(Post)
        case view(Post)
        case none
    }
    
    @State var route: Route?
    @State var posts: [Post] = [.init(id: .init(), title: "1"), .init(id: .init(), title: "2")]
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(self.posts) { post in
                    HStack {
                        Text("Post \(post.title)")
                        Spacer()
                        NavigationLink(
                            unwrapping: self.$route, case: /Route.view,
                            destination: { ViewPostView(post: $0) },
                            onNavigate: { _ in
//                                MainActor.assumeIsolated {
//                                    self.route = $0 ? .view(post) : nil
//                                }
                            },
                            label: { Text("View") }
                        )
                        NavigationLink(
                            unwrapping: self.$route, case: /Route.edit,
                            destination: { EditPostView(post: $0) },
                            onNavigate: { _ in
//                                MainActor.assumeIsolated {
//                                    self.route = $0 ? .edit(post) : nil
//                                }
                            },
                            label: { Text("Edit") }
                        )
                    }.padding().background(Color.gray.opacity(0.1).cornerRadius(8)).padding(.horizontal)
                    
                    
                }
            }
        }
        
    }
    
    struct EditPostView: View {
        @Binding var post: Post
        
        var body: some View {
            Text("EditPostView - \(post.title)")
        }
    }
    
    struct ViewPostView: View {
        @Binding var post: Post
        
        var body: some View {
            Text("ViewPostView - \(post.title)")
        }
    }
}

struct NavigationLinkExampleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationLinkExampleView()
    }
}

struct NavigationLinkEnumExampleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationLinkEnumExampleView()
    }
}

#endif
#endif
