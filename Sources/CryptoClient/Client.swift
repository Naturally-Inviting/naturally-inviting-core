import Foundation

public struct CryptoClient {
    public var currentNonceString: @Sendable () async -> String?
    public var generateEncodedNonceString: @Sendable () async -> String
    
    public init(
        currentNonceString: @Sendable @escaping () async -> String?,
        generateEncodedNonceString: @Sendable @escaping () async -> String
    ) {
        self.currentNonceString = currentNonceString
        self.generateEncodedNonceString = generateEncodedNonceString
    }
}
