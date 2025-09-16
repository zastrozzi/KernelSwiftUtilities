//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 11/8/23.
//

import Foundation
import AsyncAlgorithms

struct KeyInputSubscriptions {
    
    /// What to have to get key input as it is available.
    public struct Subscription {
        /// Who you be?
        public let uid: UUID
        
        /// What u want?
        public let type: Topic
        
        /// How you want it?
        public let channel: AsyncChannel<UInt8.StandardIn>
        
        /// What you can  subscribe about?
        public enum Topic {
            case omni
            case functions
            case modifiers
            case arrows
            case nonEscape
        }
        
        /// Initiailzes an identified subscription for a topic with the provided channel.
        init(for topic: Topic,
             with channel: AsyncChannel<UInt8.StandardIn>) {
            self.type = topic
            self.channel = channel
            self.uid = UUID()
        }
    }
    
    /// Current global subscription tracker.
    static public var global = KeyInputSubscriptions()
    
    /// Interested in all.
    public var omniSubscribers = [Subscription]()
    
    /// Interested in arrows.
    public var arrowSubscribers = [Subscription]()
    
    /// Interested in function keys.
    public var functionSubscribers = [Subscription]()
    
    /// Interested in modifiers.
    public var modifierSubscribers = [Subscription]()
    
    /// Interested in not everything, but anything not in another case.
    public var nonEscapeSubscribers = [Subscription]()
    
    /// Provide a channel and topic to be provided a sequnce for the topic.
    public mutating func subscribe(_ sub: Subscription) {
        
        switch sub.type {
            
        case .omni:
            if !omniSubscribers.contains(where: { $0.uid == sub.uid }) {
                omniSubscribers.append(sub)
            }
            
        case .functions:
            if !functionSubscribers.contains(where: { $0.uid == sub.uid }) {
                functionSubscribers.append(sub)
            }
            
        case .modifiers:
            if !modifierSubscribers.contains(where: { $0.uid == sub.uid }) {
                modifierSubscribers.append(sub)
            }
            
        case .arrows:
            if !arrowSubscribers.contains(where: { $0.uid == sub.uid }) {
                arrowSubscribers.append(sub)
            }
            
        case .nonEscape:
            if !nonEscapeSubscribers.contains(where: { $0.uid == sub.uid }) {
                nonEscapeSubscribers.append(sub)
            }
        }
    }
    
    /// Cease being provided sequence data on the provided subscription.
    public mutating func unsubscribe(_ sub: Subscription) {
        
        switch sub.type {
            
        case .omni:
            if let i = omniSubscribers.firstIndex(where: { $0.uid == sub.uid }) {
                omniSubscribers.remove(at: i)
            }
            
        case .functions:
            if let i = functionSubscribers.firstIndex(where: { $0.uid == sub.uid }) {
                functionSubscribers.remove(at: i)
            }
            
        case .modifiers:
            if let i = modifierSubscribers.firstIndex(where: { $0.uid == sub.uid }) {
                modifierSubscribers.remove(at: i)
            }
            
        case .arrows:
            if let i = arrowSubscribers.firstIndex(where: { $0.uid == sub.uid }) {
                arrowSubscribers.remove(at: i)
            }
            
        case .nonEscape:
            if let i = nonEscapeSubscribers.firstIndex(where: { $0.uid == sub.uid }) {
                arrowSubscribers.remove(at: i)
            }
            
        }
    }

}
