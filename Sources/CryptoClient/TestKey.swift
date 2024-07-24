import Dependencies
import Foundation

public extension DependencyValues {
    var cryptoClient: CryptoClient {
        get { self[CryptoClient.self] }
        set { self[CryptoClient.self] = newValue }
    }
}

extension CryptoClient: TestDependencyKey {
    public static var noop: Self {
        Self(
            currentNonceString: { nil },
            generateEncodedNonceString: { "" }
        )
    }
    
    public static var testValue: Self {
        Self(
            currentNonceString: unimplemented("\(Self.self).currentNonceString", placeholder: ""),
            generateEncodedNonceString: unimplemented("\(Self.self).generateEncodedNonceString", placeholder: "")
        )
    }
}
