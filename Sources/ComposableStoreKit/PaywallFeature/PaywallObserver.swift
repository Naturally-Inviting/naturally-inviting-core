import ComposableArchitecture
import StoreKit
import SwiftUI

public struct PaywallObserver: Reducer {
    // MARK: - State
    public struct State: Equatable {
        internal let subscriptionGroupId: String
        internal var isTaskInFlight: Bool

        public init(subscriptionGroupId: String) {
            self.subscriptionGroupId = subscriptionGroupId
            self.isTaskInFlight = false
        }
    }

    // MARK: - Action
    public enum Action: Equatable {
        public enum Delegate: Equatable {
            case userRequiresUpgrade
        }

        case delegate(Delegate)
        case setRequestInFlight(isLoading: Bool)
        case didReturnValue([Product.SubscriptionInfo.Status])
        case failedToLoadSubscriptionStatus
    }

    public init() {}

    // MARK: - Reducer Body
    public var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case let .setRequestInFlight(isLoading):
                state.isTaskInFlight = isLoading
                return .none

            case let .didReturnValue(values):
                state.isTaskInFlight = false
                /// If the user has any value that is not revoked
                /// or expired then they are a subscriber
                let isSubscribed = !values
                    .filter { $0.state != .revoked && $0.state != .expired }
                    .isEmpty

                if !isSubscribed {
                    return .send(.delegate(.userRequiresUpgrade))
                }

                return .none
                
            case .failedToLoadSubscriptionStatus:
                return .none

            case .delegate:
                return .none
            }
        }
    }
}

internal struct PaywallObserverViewModifier: ViewModifier {
    let store: StoreOf<PaywallObserver>
    @ObservedObject var viewStore: ViewStore<String, PaywallObserver.Action>

    internal init(
        store: StoreOf<PaywallObserver>
    ) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: \.subscriptionGroupId)
    }

    func body(content: Content) -> some View {
        content
            .subscriptionStatusTask(for: viewStore.state, priority: .high) { taskState in
                switch taskState {
                case .loading:
                    store.send(.setRequestInFlight(isLoading: true))

                case .failure:
                    store.send(.failedToLoadSubscriptionStatus)

                case let .success(values):
                    store.send(.didReturnValue(values))

                @unknown default:
                    break
                }
            }
    }
}

extension View {
    public func paywallObserver(store: StoreOf<PaywallObserver>) -> some View {
        self.modifier(
            PaywallObserverViewModifier(store: store)
        )
    }
}


#Preview {
    Text("Hello, world!")
        .paywallObserver(
            store: .init(
                initialState: .init(subscriptionGroupId: "21381215"),
                reducer: {
                    PaywallObserver()
                        ._printChanges()
                }
            )
        )
}
