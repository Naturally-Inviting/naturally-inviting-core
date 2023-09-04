import StoreKit

public struct StoreKitClient {
    public var latestTransaction: @Sendable (String) async throws -> PaymentTransaction?
    public var fetchProducts: @Sendable (Set<String>) async throws -> [StoreProduct]
    public var observeCustomerPurchases: @Sendable ([StoreProduct]) async throws -> AsyncStream<PaymentTransaction>
    public var updateObserver: @Sendable () async -> AsyncStream<PaymentTransaction>
    public var purchase: @Sendable (StoreProduct) async throws -> PaymentTransaction?
    public var finishTransaction: @Sendable (PaymentTransaction) async throws -> Void
    public var requestStoreReview: @Sendable () async -> Void
    public var subscriptionStatus: @Sendable (Product) async throws -> Product.SubscriptionInfo.RenewalState?
    public var showManageSubscription: @Sendable () async throws -> Void
    
    public enum StoreKitClientError: Error {
        case failedVerification
        case invalidProduct
        case transaction
        case transactionRawValueNil
        case transactionCancelled
        case unknownError
    }
    
    public struct StoreProduct: Equatable, Identifiable {
        public var id: String
        public var type: Product.ProductType
        public var displayName: String
        public var description: String
        public var price: Decimal
        public var displayPrice: String
        public var isFamilyShareable: Bool
        public var subscription: Product.SubscriptionInfo?
        public var rawValue: Product?
        
        public init(
            id: String,
            type: Product.ProductType,
            displayName: String,
            description: String,
            price: Decimal,
            displayPrice: String,
            isFamilyShareable: Bool,
            subscription: Product.SubscriptionInfo? = nil,
            rawValue: Product?
        ) {
            self.id = id
            self.type = type
            self.displayName = displayName
            self.description = description
            self.price = price
            self.displayPrice = displayPrice
            self.isFamilyShareable = isFamilyShareable
            self.subscription = subscription
            self.rawValue = rawValue
        }
    }
    
    public struct PaymentTransaction: Equatable, Identifiable {
        public var rawValue: Transaction?
        public var jsonRepresentation: Data
        public var id: UInt64
        public var originalID: UInt64
        public var webOrderLineItemID: String?
        public var productID: String
        public var subscriptionGroupID: String?
        public var appBundleID: String
        public var purchaseDate: Date
        public var originalPurchaseDate: Date
        public var expirationDate: Date?
        public var isUpgraded: Bool
        public var offerType: Transaction.OfferType?
        public var offerID: String?
        public var revocationDate: Date?
        public var revocationReason: Transaction.RevocationReason?
        public var productType: Product.ProductType
        public var appAccountToken: UUID?
        public var environment: AppStore.Environment
        public var deviceVerification: Data
        public var deviceVerificationNonce: UUID
        public var ownershipType: Transaction.OwnershipType
        public var signedDate: Date
        
        public init(
            rawValue: Transaction? = nil,
            jsonRepresentation: Data,
            id: UInt64,
            originalID: UInt64,
            webOrderLineItemID: String? = nil,
            productID: String,
            subscriptionGroupID: String? = nil,
            appBundleID: String,
            purchaseDate: Date,
            originalPurchaseDate: Date,
            expirationDate: Date? = nil,
            isUpgraded: Bool,
            offerType: Transaction.OfferType? = nil,
            offerID: String? = nil,
            revocationDate: Date? = nil,
            revocationReason: Transaction.RevocationReason? = nil,
            productType: Product.ProductType,
            appAccountToken: UUID? = nil,
            environment: AppStore.Environment,
            deviceVerification: Data,
            deviceVerificationNonce: UUID,
            ownershipType: Transaction.OwnershipType,
            signedDate: Date
        ) {
            self.rawValue = rawValue
            self.jsonRepresentation = jsonRepresentation
            self.id = id
            self.originalID = originalID
            self.webOrderLineItemID = webOrderLineItemID
            self.productID = productID
            self.subscriptionGroupID = subscriptionGroupID
            self.appBundleID = appBundleID
            self.purchaseDate = purchaseDate
            self.originalPurchaseDate = originalPurchaseDate
            self.expirationDate = expirationDate
            self.isUpgraded = isUpgraded
            self.offerType = offerType
            self.offerID = offerID
            self.revocationDate = revocationDate
            self.revocationReason = revocationReason
            self.productType = productType
            self.appAccountToken = appAccountToken
            self.environment = environment
            self.deviceVerification = deviceVerification
            self.deviceVerificationNonce = deviceVerificationNonce
            self.ownershipType = ownershipType
            self.signedDate = signedDate
        }
    }
    
    public static func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreKitClientError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

extension SKPaymentTransactionState {
    public var canBeVerified: Bool {
        switch self {
        case .purchasing, .failed, .deferred:
            return false
        case .purchased, .restored:
            return true
        @unknown default:
            return false
        }
    }
}

extension StoreKitClient.PaymentTransaction {
    init(rawValue: Transaction) {
        self.rawValue = rawValue
        self.jsonRepresentation = rawValue.jsonRepresentation
        self.id = rawValue.id
        self.originalID = rawValue.originalID
        self.webOrderLineItemID = rawValue.webOrderLineItemID
        self.productID = rawValue.productID
        self.subscriptionGroupID = rawValue.subscriptionGroupID
        self.appBundleID = rawValue.appBundleID
        self.purchaseDate = rawValue.purchaseDate
        self.originalPurchaseDate = rawValue.originalPurchaseDate
        self.expirationDate = rawValue.expirationDate
        self.isUpgraded = rawValue.isUpgraded
        self.offerType = rawValue.offerType
        self.offerID = rawValue.offerID
        self.revocationDate = rawValue.revocationDate
        self.revocationReason = rawValue.revocationReason
        self.productType = rawValue.productType
        self.appAccountToken = rawValue.appAccountToken
        self.environment = rawValue.environment
        self.deviceVerification = rawValue.deviceVerification
        self.deviceVerificationNonce = rawValue.deviceVerificationNonce
        self.ownershipType = rawValue.ownershipType
        self.signedDate = rawValue.signedDate
    }
}

extension StoreKitClient.StoreProduct {
    init(rawValue: Product) {
        self.id = rawValue.id
        self.type = rawValue.type
        self.displayName = rawValue.displayName
        self.description = rawValue.description
        self.price = rawValue.price
        self.displayPrice = rawValue.displayPrice
        self.isFamilyShareable = rawValue.isFamilyShareable
        self.subscription = rawValue.subscription
        self.rawValue = rawValue
    }
}
