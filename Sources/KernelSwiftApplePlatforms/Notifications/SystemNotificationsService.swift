//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/09/2023.
//

import Foundation
import Collections
import KernelSwiftCommon

#if os(iOS)
import UIKit
#endif

#if os(macOS)
import AppKit
#endif

extension KernelDI.Injector {
    @available(iOS 17.0, macOS 14.0, *)
    public var systemNotificationsService: KernelAppUtils.Notifications.SystemNotificationsService {
        get { self[KernelAppUtils.Notifications.SystemNotificationsService.Token.self] }
        set { self[KernelAppUtils.Notifications.SystemNotificationsService.Token.self] = newValue }
    }
}

extension KernelAppUtils.Notifications {
    @Observable @MainActor
    @available(iOS 17.0, macOS 14.0, *)
    public class SystemNotificationsService: KernelDI.Injectable, KernelDI.ServiceLoggable, @unchecked Sendable {
        public typealias FeatureContainer = KernelAppUtils.Notifications
        
        @ObservationIgnored
        private var eventStore: KernelAppUtils.SimpleMemoryCache<Notification.Name, Deque<NotificationEvent>> = .init()
        
        @ObservationIgnored
        private var taskStore: KernelAppUtils.TaggedMemoryCache<Notification.Name, UUID, Task<Void, Swift.Error>> = .init()
        
        nonisolated required public init() {
            Self.logger.debug("Initialising SystemNotificationsService")
        }
        
        public func setup() {
//            registerNotificationCenterObservers()
        }
        
        
#if os(iOS)
        private func registerNotificationCenterObservers() {
            NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.didFinishLaunchingNotification), name: UIApplication.didFinishLaunchingNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.didBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.willResignActiveNotification), name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMemoryWarningNotification), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.willTerminateNotification), name: UIApplication.willTerminateNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.significantTimeChangeNotification), name: UIApplication.significantTimeChangeNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.backgroundRefreshStatusDidChangeNotification), name: UIApplication.backgroundRefreshStatusDidChangeNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.protectedDataWillBecomeUnavailableNotification), name: UIApplication.protectedDataWillBecomeUnavailableNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.protectedDataDidBecomeAvailableNotification), name: UIApplication.protectedDataDidBecomeAvailableNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.userDidTakeScreenshotNotification), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification), name: UIApplication.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShowNotification), name: UIApplication.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification), name: UIApplication.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHideNotification), name: UIApplication.keyboardDidHideNotification, object: nil)
        }
#endif
        
#if os(macOS)
        private func registerNotificationCenterObservers() async {
            
        }
#endif
        private func registerTaskObservers() {
            
        }
        
        
        public func addObserver(key: UUID, for name: Notification.Name, task: Task<Void, Swift.Error>) throws {
            if taskStore.has(key) { throw TypedError(.notificationServiceDesynchronised) }
            if !eventStore.has(name) { eventStore.set(name, value: .init()) }
            taskStore.set(key, tag: name, value: task)
//            taskStore.set(name, value: .init(operation: {
//                for await notification in NotificationCenter.default.notifications(named: name)
//                    .map( {
//                        KernelAppUtils.Notifications.NotificationEvent(ts:.now,
//                                                                     name:$0.name)
////                        NotificationEvent(timestamp: .now,
////                                          name: $0.name)
//                    }) {
//                    eventStore.update(name) { deque in
//                        deque.append(notification)
//                    }
//                    KernelAppUtils.Application.logger.debug("\(notification)")
//                }
//            }))
        }
        
        public func removeObserver(for name: Notification.Name, deleteHistory: Bool = false) {
//            if let task = taskStore.get(name) {
//                task.cancel()
//                taskStore.unset(name)
//            }
//            guard deleteHistory else { return }
//            if eventStore.has(name) { eventStore.unset(name) }
        }
        
        public func logEventHistory(for name: Notification.Name) {
            guard let events = eventStore.get(name) else { return }
            Self.logger.debug("\(events)")
        }
        
        public func removeAllObservers(deleteHistory: Bool = false) {
//            for name in taskStore.keys() {
//                if let task = taskStore.get(name) {
//                    task.cancel()
//                    taskStore.unset(name)
//                }
//            }
//            
//            guard deleteHistory else { return }
//            for name in eventStore.keys() {
//                if eventStore.has(name) { eventStore.unset(name) }
//            }
        }
        
        public func logAllObservers() {
            Self.logger.debug("EventStore: \(eventStore.keys())")
            Self.logger.debug("TaskStore: \(taskStore.keys())")
        }
        
        public func clearEventHistory(for name: Notification.Name) {
            if eventStore.has(name) { eventStore.set(name, value: []) }
        }
        
        public func clearAllEventHistory() {
            for name in eventStore.keys() {
                if eventStore.has(name) { eventStore.set(name, value: []) }
            }
        }
        
        @objc private func didEnterBackgroundNotification() {
            Self.logger.debug("didEnterBackgroundNotification")
        }
        
        @objc private func willEnterForegroundNotification() {
            Self.logger.debug("willEnterForegroundNotification")
        }
        
        @objc private func didFinishLaunchingNotification() {
            Self.logger.debug("didFinishLaunchingNotification")
        }
        
        @objc private func didBecomeActiveNotification() {
            Self.logger.debug("didBecomeActiveNotification")
        }
        
        @objc private func willResignActiveNotification() {
            Self.logger.debug("willResignActiveNotification")
        }
        
        @objc private func didReceiveMemoryWarningNotification() {
            Self.logger.debug("didReceiveMemoryWarningNotification")
        }
        
        @objc private func willTerminateNotification() {
            Self.logger.debug("willTerminateNotification")
        }
        
        @objc private func significantTimeChangeNotification() {
            Self.logger.debug("significantTimeChangeNotification")
        }
        
        @objc private func backgroundRefreshStatusDidChangeNotification() {
            Self.logger.debug("backgroundRefreshStatusDidChangeNotification")
        }
        
        @objc private func protectedDataWillBecomeUnavailableNotification() {
            Self.logger.debug("protectedDataWillBecomeUnavailableNotification")
        }
        
        @objc private func protectedDataDidBecomeAvailableNotification() {
            Self.logger.debug("protectedDataDidBecomeAvailableNotification")
        }
        
        @objc private func userDidTakeScreenshotNotification() {
            Self.logger.debug("userDidTakeScreenshotNotification")
        }
        
        @objc private func keyboardWillShowNotification() {
            Self.logger.debug("keyboardWillShowNotification")
        }
        
        @objc private func keyboardDidShowNotification() {
            Self.logger.debug("keyboardDidShowNotification")
        }
        
        @objc private func keyboardWillHideNotification() {
            Self.logger.debug("keyboardWillHideNotification")
        }
        
        @objc private func keyboardDidHideNotification() {
            Self.logger.debug("keyboardDidHideNotification")
        }
    }
}
