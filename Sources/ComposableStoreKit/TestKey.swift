import Dependencies
import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay

extension DependencyValues {
    public var storeKit: StoreKitClient {
        get { self[StoreKitClient.self] }
        set { self[StoreKitClient.self] = newValue }
    }
}

extension StoreKitClient: TestDependencyKey {
    public static let previewValue = Self.noop
    
    public static let testValue = Self(
        latestTransaction: unimplemented("\(Self.self).latestTransaction"),
        fetchProducts: unimplemented("\(Self.self).fetchProducts"),
        observeCustomerPurchases: unimplemented("\(Self.self).observeCustomerPurchases"),
        updateObserver: unimplemented("\(Self.self).updateObserver", placeholder: AsyncStream { _ in }),
        purchase: unimplemented("\(Self.self).purchase"),
        finishTransaction: unimplemented("\(Self.self).finishTransaction"),
        requestStoreReview: unimplemented("\(Self.self).requestStoreReview"),
        subscriptionStatus: unimplemented("\(Self.self).subscriptionStatus"),
        showManageSubscription: unimplemented("\(Self.self).showManageSubscription")
    )
}

extension StoreKitClient {
    public static let noop = Self(
        latestTransaction: { _ in nil },
        fetchProducts: { _ in [] },
        observeCustomerPurchases: { _ in AsyncStream { _ in } },
        updateObserver: { AsyncStream { _ in } },
        purchase: { _ in nil },
        finishTransaction: { _ in },
        requestStoreReview: { },
        subscriptionStatus: { _ in nil},
        showManageSubscription: {}
    )
}
