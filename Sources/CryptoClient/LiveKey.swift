import CryptoKit
import Dependencies
import Foundation

extension CryptoClient: DependencyKey {
    public static var liveValue: Self {
        let actor = CryptoActor()

        return Self(
            currentNonceString: { await actor.currentNonce() },
            generateEncodedNonceString: { await actor.generateEncodedNonceString() }
        )
    }
}

fileprivate actor CryptoActor {
    private(set) var internalNonce: String?
    
    func currentNonce() -> String? {
        internalNonce
    }
    
    func generateEncodedNonceString() -> String {
        let nonce = randomNonceString()
        self.internalNonce = nonce
        return sha256(nonce)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}
