import ComposableArchitecture
import StoreKit
import SwiftUI

@Reducer
public struct PaywallObserver {
    @ObservableState
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
            case userHasPremium
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

                return .send(.delegate(.userHasPremium))
                
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

    internal init(
        store: StoreOf<PaywallObserver>
    ) {
        self.store = store
    }

    func body(content: Content) -> some View {
        content
            .subscriptionStatusTask(
                for: store.subscriptionGroupId,
                priority: .high
            ) { taskState in
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
