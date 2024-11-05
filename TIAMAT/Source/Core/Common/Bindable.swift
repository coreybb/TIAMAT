import Foundation
import Combine

/// Protocol for types that need to handle Combine publisher subscriptions.
/// Provides a convenient way to manage subscriptions and their lifecycle.
///
/// Example Usage:
/// ```swift
/// class MyViewController: UIViewController, Bindable {
///     var cancellables = Set<AnyCancellable>()
///
///     func setupBindings() {
///         // Simple subscription on main queue
///         subscribe(viewModel.$items) { [weak self] items in
///             self?.updateUI(with: items)
///         }
///
///         // Subscription with specific queue
///         subscribe(dataStream, receiveOn: .global()) { data in
///             // Handle background work
///         }
///     }
/// }
/// ```
protocol Bindable: AnyObject {
    
    /// Storage for active subscriptions to prevent them from being canceled.
    var cancellables: Set<AnyCancellable> { get set }
    
    /// Subscribes to a publisher and stores the subscription.
    /// - Parameters:
    ///   - publisher: The publisher to subscribe to
    ///   - scheduler: The DispatchQueue to receive values on
    ///   - handler: Closure to execute when values are received
    /// - Note: Subscriptions are automatically stored in the cancellables set
    func subscribe<P: Publisher>(
        _ publisher: P,
        receiveOn scheduler: DispatchQueue,
        handler: @escaping (P.Output) -> Void
    ) where P.Failure == Never
}

// MARK: - Default Implementation

extension Bindable {
    
    /// Default implementation that handles subscription setup and storage.
    /// - Parameters:
    ///   - publisher: The publisher to subscribe to
    ///   - scheduler: The DispatchQueue to receive values on (defaults to main queue)
    ///   - handler: Closure to execute when values are received
    /// - Note: Automatically stores subscription in cancellables set to prevent premature cancellation
    func subscribe<P: Publisher>(
        _ publisher: P,
        receiveOn scheduler: DispatchQueue = .main,
        handler: @escaping (P.Output) -> Void
    ) where P.Failure == Never {
        publisher
            .receive(on: scheduler)
            .sink(receiveValue: handler)
            .store(in: &cancellables)
    }
}
