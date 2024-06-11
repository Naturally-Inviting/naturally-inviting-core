import ComposableArchitecture
import StoreKit

#if canImport(UIKit)
import UIKit
#endif

@available(iOSApplicationExtension, unavailable)
extension StoreKitClient: DependencyKey {
    public static let liveValue = Self(
        latestTransaction: { productId in
            guard let verification = await Transaction.latest(for: productId)
            else { return nil }
            
            let transaction = try checkVerified(verification)
            guard transaction.revocationDate == nil else { return nil }
            guard !transaction.isUpgraded else { return nil }
            
            return .init(rawValue: transaction)
        },
        fetchProducts: { products in
            let response = try await Product.products(for: products)
            return response.map(StoreProduct.init(rawValue:))
        },
        observeCustomerPurchases: { storeProducts in
            AsyncStream<PaymentTransaction> { continuation in
                let task = Task {
                    for await result in Transaction.currentEntitlements {
                        let transaction = try checkVerified(result)
                        continuation.yield(PaymentTransaction(rawValue: transaction))
                    }
                    
                    continuation.finish()
                }
                
                continuation.onTermination = { _ in
                    task.cancel()
                }
            }
        },
        updateObserver: {
            AsyncStream<PaymentTransaction> { continuation in
                Task {
                    for await result in Transaction.updates {
                        let transaction = try checkVerified(result)
                        continuation.yield(PaymentTransaction(rawValue: transaction))
                    }
                }
            }
        },
        purchase: { product in
            guard let product = product.rawValue else { throw StoreKitClientError.invalidProduct }
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                return .init(rawValue: transaction)
                
            case .pending, .userCancelled:
                return nil
                
            @unknown default:
                throw StoreKitClientError.unknownError
            }
        },
        finishTransaction: { transaction in
            await transaction.rawValue?.finish()
        },
        requestStoreReview: {
            #if os(iOS)
            guard
                let scene = UIApplication.shared.connectedScenes
                    .first(where: { $0 is UIWindowScene })
                    as? UIWindowScene
            else { return }
            SKStoreReviewController.requestReview(in: scene)
            #else
            return
            #endif
        },
        subscriptionStatus: { product in
            let statuses = try await product.subscription?.status ?? []
            return statuses.first?.state
        },
        showManageSubscription: {
            #if os(iOS)
            if let window = UIApplication.shared.connectedScenes.first {
                try await AppStore.showManageSubscriptions(in: window as! UIWindowScene)
            }
            #endif
        }
    )
}
