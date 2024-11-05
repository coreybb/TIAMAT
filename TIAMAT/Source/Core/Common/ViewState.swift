/// Represents the possible states of a view's content, including loading and error states.
/// Maintains previous content for smooth state transitions.
///
/// Example Usage:
/// ```swift
/// class ViewModel: ViewStatePresenting {
///     @Published var state = ViewState<[Item]>.idle([])
///
///     func loadData() async {
///         state = .loading(previous: currentContent)
///         do {
///             let items = try await fetchItems()
///             state = .idle(items)
///         } catch {
///             state = .error(error, previous: currentContent)
///         }
///     }
/// }
/// ```
enum ViewState<T> {
    /// Content is loaded and ready for display
    case idle(T)
    /// Content is being loaded; optionally maintains previous content
    case loading(previous: T?)
    /// An error occurred; optionally maintains previous content
    case error(Error, previous: T?)
}
