//
//  ReachabilityManager.swift
//  test-tasks
//
//  Created by MSI on 10.02.2021.
//

#if canImport(Alamofire)
import Alamofire
#else

import Foundation
import SystemConfiguration
import Combine

/// The `NetworkReachabilityManager` class listens for reachability changes of hosts and addresses for both WWAN and
/// WiFi network interfaces.
///
/// Reachability can be used to determine background information about why a network operation failed, or to retry
/// network requests when a connection is established. It should not be used to prevent a user from initiating a network
/// request, as it's possible that an initial request may be required to establish reachability.
open class NetworkReachabilityManager {
    /// Defines the various states of network reachability.
    public enum NetworkReachabilityStatus {
        /// It is unknown whether the network is reachable.
        case unknown
        /// The network is not reachable.
        case notReachable
        /// The network is reachable on the associated `ConnectionType`.
        case reachable(ConnectionType)
    }

    /// Defines the various connection types detected by reachability flags.
    public enum ConnectionType {
        /// The connection type is either over Ethernet or WiFi.
        case ethernetOrWiFi
        /// The connection type is a WWAN connection.
        case wwan
    }

    /// A closure executed when the network reachability status changes. The closure takes a single argument: the
    /// network reachability status.
    public typealias Listener = (NetworkReachabilityStatus) -> Void

    // MARK: - Properties

    /// Whether the network is currently reachable.
    open var isReachable: Bool { return isReachableOnWWAN || isReachableOnEthernetOrWiFi }

    /// Whether the network is currently reachable over the WWAN interface.
    open var isReachableOnWWAN: Bool { return networkReachabilityStatus == .reachable(.wwan) }

    /// Whether the network is currently reachable over Ethernet or WiFi interface.
    open var isReachableOnEthernetOrWiFi: Bool { return networkReachabilityStatus == .reachable(.ethernetOrWiFi) }

    /// The current network reachability status.
    open var networkReachabilityStatus: NetworkReachabilityStatus {
        guard let flags = self.flags else { return .unknown }
        return networkReachabilityStatusForFlags(flags)
    }

    /// The dispatch queue to execute the `listener` closure on.
    open var listenerQueue: DispatchQueue = DispatchQueue.main

    /// A closure executed when the network reachability status changes.
    open var listener: Listener?

    /// Flags of the current reachability type, if any.
    open var flags: SCNetworkReachabilityFlags? {
        var flags = SCNetworkReachabilityFlags()

        if SCNetworkReachabilityGetFlags(reachability, &flags) {
            return flags
        }

        return nil
    }

    private let reachability: SCNetworkReachability
    /// Reachability flags of the previous reachability state.
    open var previousFlags: SCNetworkReachabilityFlags

    // MARK: - Initialization

    /// Creates an instance with the specified host.
    ///
    /// - Parameter host: Host used to evaluate network reachability. Must not include the scheme (i.e. `https`).
    public convenience init?(host: String) {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, host) else { return nil }
        self.init(reachability: reachability)
    }

    /// Creates an instance that monitors the address 0.0.0.0.
    ///
    /// Reachability treats the 0.0.0.0 address as a special token that causes it to monitor the general routing
    /// status of the device, both IPv4 and IPv6.
    public convenience init?() {
        var address = sockaddr_in()
        address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        address.sin_family = sa_family_t(AF_INET)

        guard let reachability = withUnsafePointer(to: &address, { pointer in
            return pointer.withMemoryRebound(to: sockaddr.self, capacity: MemoryLayout<sockaddr>.size) {
                return SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else { return nil }

        self.init(reachability: reachability)
    }

    private init(reachability: SCNetworkReachability) {
        self.reachability = reachability

        // Set the previous flags to an unreserved value to represent unknown status
        self.previousFlags = SCNetworkReachabilityFlags(rawValue: 1 << 30)
    }

    deinit {
        stopListening()
    }

    // MARK: - Listening

    /// Starts listening for changes in network reachability status.
    ///
    /// - Returns: `true` if listening was started successfully, `false` otherwise.
    @discardableResult
    open func startListening() -> Bool {
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = Unmanaged.passUnretained(self).toOpaque()

        let callbackEnabled = SCNetworkReachabilitySetCallback(
            reachability,
            { (_, flags, info) in
                let reachability = Unmanaged<NetworkReachabilityManager>.fromOpaque(info!).takeUnretainedValue()
                reachability.notifyListener(flags)
            },
            &context
        )

        let queueEnabled = SCNetworkReachabilitySetDispatchQueue(reachability, listenerQueue)

        listenerQueue.async {
            guard let flags = self.flags else { return }
            self.notifyListener(flags)
        }

        return callbackEnabled && queueEnabled
    }

    /// Stops listening for changes in network reachability status.
    open func stopListening() {
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
    }

    // MARK: - Internal - Listener Notification

    func notifyListener(_ flags: SCNetworkReachabilityFlags) {
        guard previousFlags != flags else { return }
        previousFlags = flags

        listener?(networkReachabilityStatusForFlags(flags))
    }

    // MARK: - Internal - Network Reachability Status

    func networkReachabilityStatusForFlags(_ flags: SCNetworkReachabilityFlags) -> NetworkReachabilityStatus {
        guard isNetworkReachable(with: flags) else { return .notReachable }

        var networkStatus: NetworkReachabilityStatus = .reachable(.ethernetOrWiFi)
        
        if flags.contains(.isWWAN) { networkStatus = .reachable(.wwan) }

        return networkStatus
    }

    func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)

        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
}

// MARK: -

extension NetworkReachabilityManager.NetworkReachabilityStatus: Equatable {
    public static func ==(
        lhs: NetworkReachabilityManager.NetworkReachabilityStatus,
        rhs: NetworkReachabilityManager.NetworkReachabilityStatus)
        -> Bool
    {
        switch (lhs, rhs) {
        case (.unknown, .unknown), (.notReachable, .notReachable):
            return true
        case let (.reachable(lhsConnectionType), .reachable(rhsConnectionType)):
            return lhsConnectionType == rhsConnectionType
        default:
            return false
        }
    }
}

#endif

@available(iOS 13.0, *)
protocol NetworkStatusSupplier: NetworkStatusListener {
    
    var isInternetConnected: CurrentValueSubject<Bool, Never> { get }
}

extension NetworkStatusSupplier {
    var isInternetConnected: CurrentValueSubject<Bool, Never> {
        .init(!ReachabilityManager.shared.isNoInternet)
    }
}

// MARK: -  Subscribers must conform to this protocol
protocol NetworkStatusListener: class {
    
    /// Action on network status did change event
    /// - parameters:
    ///   - isReachable: Whether the network is currently reachable.
    func networkStatusDidChange(_ isReachable: Bool)
}

extension NetworkStatusListener {
    func networkStatusDidChange(_ isReachable: Bool) {}
}

//MARK: -  Control ReachabilityManager via
protocol NetworkTracker {

    /// Start monitoring network status
    func startMonitoring()

    /// Stop monitoring network status
    func stopMonitoring()

    /// Symply check network status
    var isNoInternet: Bool { get }

    /// Broadcast event on update status
    func updateStatus()

    // MARK: -  Subscribe via
    /// Add listener of network status
    /// - parameters:
    /// - listener: subscriber of network status event
    func addListener(_ listener: NetworkStatusListener)

    /// Remove listener of network status
    /// - parameters:
    /// - listener: subscriber of network status event
    func removeListener(_ listener: NetworkStatusListener)

}

// MARK: - Wrapper around NetworkStatusListener that provides weak reference to it's value
private final class WeakListener {
    
    private(set) weak var value: NetworkStatusListener?
    
    init(_ value: NetworkStatusListener?) {
        self.value = value
    }
}

// MARK: - Reachability Manager itself
final class ReachabilityManager {
    
    static let shared: NetworkTracker = ReachabilityManager()
    
    private var listeners = [WeakListener]()
    private let reachability: NetworkReachabilityManager?
    private(set) var isNoInternet: Bool
    
    private init() {
        reachability = NetworkReachabilityManager(host: "www.apple.com")
        isNoInternet = !(reachability?.isReachable ?? false)
        reachability?.listener = { [weak self] _ in
            self?.updateStatus()
        }
        reachability?.startListening()
    }
    
    deinit {
        reachability?.stopListening()
    }
    
}

// MARK: - Private methods
extension ReachabilityManager {
    
    private func notify(status isReachable: Bool) {
        listeners.reversed().forEach { listener in
            listener.value?.networkStatusDidChange(isReachable)
            if #available(iOS 13, *) {
                (listener as? NetworkStatusSupplier)?.isInternetConnected.value = isReachable
            }
        }
    }
    
    private func updateUserTokenIfNeeded() {
    }
    
}

// MARK: - NetworkTracker conformance
extension ReachabilityManager: NetworkTracker {
    
    func addListener(_ listener: NetworkStatusListener) {
        listeners.append(WeakListener(listener))
    }
    
    /**
     
     ### HOW IT WORKS:
     
     * Listener calls `removeListener(_:)` in its `deinit`
     * Although [documentation states](https://docs.swift.org/swift-book/LanguageGuide/Deinitialization.html) that while calling `deinit` instance is still not deallocated, it is already `nil` in listeners array
     * `compactMap` helps to clean up all `nil` references, but sometimes (1 out of 100 probably) `removeListener(_:)` is not called in listener's `deinit`
     * In order to clean up these "artifacts" we check if any of the stored listeners have th same `type(of:)` as the instance that is passed to method
     
     */
    func removeListener(_ listener: NetworkStatusListener) {
        listeners = listeners.compactMap { element -> WeakListener? in
            guard let value = element.value else { return nil }
            guard type(of: value) != type(of: listener) else { return nil }
            return element
        }
    }
    
    func startMonitoring() {
        reachability?.startListening()
    }
    
    func stopMonitoring() {
        reachability?.stopListening()
    }
    
    func updateStatus() {
        let newReachable = reachability?.isReachable ?? false
        
        if isNoInternet != !newReachable {
            isNoInternet = !newReachable
            notify(status: newReachable)
            if newReachable { updateUserTokenIfNeeded() }
        }
    }
}

