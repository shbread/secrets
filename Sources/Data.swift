import Foundation
import CryptoKit

private let label = "archive"

extension Data {
    public var encrypted: Self {
        get async {
            await Task
                .detached(priority: .utility) {
                    key
                        .flatMap { key in
                            try? AES.GCM.seal(self, using: key).combined
                        }
                    ?? .init()
                }
                .value
        }
    }
    
    public var decrypted: Self {
        get async {
            await Task
                .detached(priority: .utility) {
                    key
                        .flatMap { key in
                            try? AES.GCM.seal(self, using: key).combined
                        }
                    ?? .init()
                }
                .value
        }
    }
    
    private var key: SymmetricKey? {
        retrieve ?? generate
    }
    
    private var retrieve: SymmetricKey? {
        let query = [kSecClass: kSecClassKey,
                     kSecAttrApplicationLabel: label,
                     kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
                     kSecUseDataProtectionKeychain: true,
                     kSecReturnRef: true] as [String: Any]

        var item: CFTypeRef?
        
        guard
            SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
            let data = SecKeyCopyExternalRepresentation(item as! SecKey, nil) as Data?
        else { return nil }
        
        return .init(data: data)
    }
    
    private var generate: SymmetricKey? {
        let key = SymmetricKey(size: .bits256)

        guard
            let query = SecKeyCreateWithData(
                key
                    .withUnsafeBytes {
                        Data($0)
                    } as CFData,
                ([kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
                 kSecAttrKeyClass: kSecAttrKeyClassPrivate]
                 as [String: Any]) as CFDictionary,
                nil),
            SecItemAdd([
                kSecClass: kSecClassKey,
                kSecAttrApplicationLabel: label,
                kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
                kSecUseDataProtectionKeychain: true,
                kSecValueRef: query]
                       as [String: Any] as CFDictionary, nil) == errSecSuccess
        else { return nil }
        
        return key
    }
}
