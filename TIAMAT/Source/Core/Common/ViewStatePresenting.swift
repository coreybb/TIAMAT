/// Protocol for types that manage view state transitions.
/// Provides helper properties and methods for state handling.
///
/// Conforming types must provide:
/// - A `state` property of type `ViewState<Content>`
/// - `Content` type that represents the view's data
protocol ViewStatePresenting: AnyObject {
    associatedtype Content
    var state: ViewState<Content> { get set }
}

extension ViewStatePresenting {
    
    /// Indicates whether content is currently loading
    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }
    
    /// The current content, if any exists.
    /// Returns:
    /// - Active content in idle state
    /// - Previous content in loading/error states
    var currentContent: Content? {
        switch state {
        case .idle(let content):
            content
        case .loading(previous: let previous):
            previous
        case .error(_, previous: let previous):
            previous
        }
    }
    
    /// Updates the state on the main actor.
    /// - Parameter newState: The new state to transition to
    @MainActor
    func updateState(to newState: ViewState<Content>) {
        state = newState
    }
    
    
    /// Indicates whether the current state represents an error
    var hasError: Bool {
        if case .error = state { return true }
        return false
    }
}


/// Additional convenience properties for Collection types
extension ViewStatePresenting where Content: Collection {
    
    /// Indicates whether the current content is empty or nil
    var isEmpty: Bool { currentContent?.isEmpty ?? true }
    
    /// The count of current content items, or 0 if nil
    var count: Int { currentContent?.count ?? 0 }
}
