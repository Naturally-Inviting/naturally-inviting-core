import ComposableArchitecture
import StoreKit
import SwiftUI

@Reducer
public struct PaywallFeature {
    @Reducer
    public struct Destination {
        public enum State: Equatable {
            case alert(AlertState<Action.Alert>)
        }

        public enum Action: Equatable {
            case alert(Alert)
            public enum Alert: Equatable {}
        }

        public func reduce(into state: inout State, action: Action) -> Effect<Action> {
            return .none
        }
    }

    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        internal let subscriptionGroupId: String
        @Presents var destination: Destination.State?

        public init(subscriptionGroupId: String) {
            self.subscriptionGroupId = subscriptionGroupId
        }
    }

    // MARK: - Action
    public enum Action: Equatable {
        public enum Delegate: Equatable {
            case storePurchaseDidComplete
        }

        case delegate(Delegate)
        case purchasePending
        case purchaseErrorDidOccur
        case destination(PresentationAction<Destination.Action>)
    }

    public init() {}

    // MARK: - Reducer Body
    public var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .purchasePending:
                state.destination = .alert(
                    .init(
                        title: {
                            TextState("Purchase pending")
                        },
                        message: {
                            TextState("Please check the status later or contact the account holder to proceed.")
                        }
                    )
                )
                return .none

            case .purchaseErrorDidOccur:
                state.destination = .alert(
                    .init(
                        title: {
                            TextState("Purchase Unsuccessful")
                        },
                        message: {
                            TextState("Please check your payment details and try again.")
                        }
                    )
                )
                return .none

            case .destination:
                return .none

            case .delegate:
                return .none
            }
        }
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
    }
}

// MARK: - View
public struct PaywallFeatureView: View {
    @Bindable var store: StoreOf<PaywallFeature>

    public init(
        store: StoreOf<PaywallFeature>
    ) {
        self.store = store
    }

    public var body: some View {
        VStack {
            #if os(watchOS)
            content
            #elseif os(iOS)
            content
                .subscriptionStoreButtonLabel(.multiline)
                .storeButton(.visible, for: .restorePurchases, .redeemCode)
            #elseif os(macOS)
            content
                .subscriptionStoreButtonLabel(.multiline)
                .storeButton(.visible, for: .restorePurchases)
            #endif
        }
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    }

    @ViewBuilder
    var content: some View {
        SubscriptionStoreView(groupID: store.subscriptionGroupId, visibleRelationships: .upgrade)
            .subscriptionStorePickerItemBackground(.thinMaterial)
            .storeButton(.hidden, for: .cancellation)
            .subscriptionStoreControlStyle(.automatic)
            .onInAppPurchaseCompletion { product, result in
                await sendStoreAction(result: result)
            }
    }

    @MainActor
    func sendStoreAction(result: Result<Product.PurchaseResult, any Error>) {
        switch result {
        case .success(.success(.verified)):
            store.send(.delegate(.storePurchaseDidComplete))

        case .success(.pending):
            store.send(.purchasePending)

        case .success(.userCancelled):
            break

        case .success(.success(.unverified)):
            store.send(.purchaseErrorDidOccur)

        case .failure:
            store.send(.purchaseErrorDidOccur)

        @unknown default:
            break
        }
    }
}

// MARK: - Preview
#Preview {
    PaywallFeatureView(
        store: .init(
            initialState: .init(
                subscriptionGroupId: "21381215"
            ),
            reducer: {
                PaywallFeature()
            }
        )
    )
}
