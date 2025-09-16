//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 11/1/23.
//
import Foundation
import KernelSwiftTerminal

/// A View NavMenu can navigate to.
enum Screen: String, CaseIterable {
    case ingress
    case decode
    case generate
    case run
    case report
    case logs
    
    var advice: [Messager.Message] {
        let advisementTime = Date()
        
        switch self {
            
        case .ingress:
            return [Messager.Message(value: "You can pass the url as a command line argument.", time: advisementTime),
                    Messager.Message(value: "If not, use the arrow keys to change the url.", time: advisementTime),
                    Messager.Message(value: "The next step is to decode what is ingressed.", time: advisementTime)
            ]
        case .decode:
            return [Messager.Message(value: "You can decode the utf-8 data that was ingressed to an OpenAPI document",
                                time: advisementTime),]

        case .generate:
            return [Messager.Message(value: "You can create filters to exclude specs from plan generation.",
                                time: advisementTime),
                    Messager.Message(value: "You can alter the presentation order. WIP",
                                time: advisementTime),
                    Messager.Message(value: "You can modify means and expectations before they execute. WIP",
                                time: advisementTime)
                   ]
        case .run:
            return [Messager.Message(value: "You can execute presented plans or reject them them. individually WIP",
                                time: advisementTime),
                   ]
        case .report:
            return [Messager.Message(value: "You can examine the results. WIP",
                                time: advisementTime),]
        case .logs:
            return [Messager.Message(value: "You heard it here.",
                                time: advisementTime),]
        }
    }
}

/// A action NavMenu ca nperform.
enum Command: String, CaseIterable {
    case quit
    case advise
}

struct CommandAction {
    var method: () -> ()
    
}

class NavMenuModel: ObservableObject {
    @Published var selectedScreen: Screen? = .ingress
    @Published var isSeeekingAdvice = false
    
    /// Can be overriden by the current selected screen perhaps
    @Published var commandActions: [Command:() ->()]?
    = [.quit : {exit(0)},
       .advise : {}]
}

struct PhaseView: View {
    @ObservedObject var model = NavMenuModel()

    var body: some View {
        Group {
            HStack {
                Spacer()
                Text("Phases")
                    .bold()
                    .foregroundColor(.magenta)
                
                Spacer()
            }
            
            HStack(alignment:.center, spacing: 1) {
                ForEach(Screen.allCases, id: \.self) { screen in
                    Button(screen.rawValue.capitalized) {
                        model.selectedScreen = screen
                    }
                    .background(.blue)
                    .foregroundColor(.yellow)                    }
            }
        }
    }
}


struct CommandsView: View {
    @ObservedObject var model = NavMenuModel()
    
    var body: some View {
        Group {
            
            HStack {
                Spacer()
                Text("Commands").bold()
                    .foregroundColor(.magenta)
                Spacer()
            }
            
            HStack(alignment: .center, spacing: 1) {
                
                ForEach(Command.allCases, id:\.self) { command in
                    
                    Button(command.rawValue) {
                        if command == .advise {
                            model.commandActions?[.advise] = {
                                model.isSeeekingAdvice.toggle()
                                Messager.advice = model.selectedScreen?.advice ?? [Messager.Message(value: "Idk",
                                                                                                    time: Date())]
                            }
                        }
                        if let action = model.commandActions?[command] {
                            Messager.log(sys: .execution, s: "executing \(command.rawValue)")
                            action()
                        }else {
                            Messager.log(sys: .execution, s: "no action")
                        }
                    }
                    .background(.blue)
                    .foregroundColor(.yellow)
                    
                }
            }
        }
    }
}

struct AdviceView: View {
    var body: some View {
        VStack {
            Text("Advice")
            ScrollView {
                ForEach(Messager.advice) { message in
                    Text("\(message.value)")
                }
            }
        }
    }
}

struct NavMenuView: View {
     
    @ObservedObject var model = NavMenuModel()
    @ObservedObject var tester: TesterModel
    
    var logs: some View {
        MessagesView()
    }
    
    var body: some View {
        VStack {
            if model.isSeeekingAdvice {
                AdviceView()
            }
            PhaseView(model: model)
            CommandsView(model: model)            
        }
    }
}
