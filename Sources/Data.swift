import Foundation
import CryptoKit

private let label = "archive"

extension Data {
    public var compressed: Self {
        get async {
            await Task
                .detached(priority: .utility) {
                    try! (self as NSData).compressed(using: .lzfse) as Self
                }
                .value
        }
    }
    
    private var key: SymmetricKey{
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
    
    private var generate: SymmetricKey {
        let key = SymmetricKey(size: .bits256)

        SecItemAdd([
            kSecClass: kSecClassKey,
            kSecAttrApplicationLabel: label,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
            kSecUseDataProtectionKeychain: true,
            kSecValueRef:
                SecKeyCreateWithData(key
                                        .withUnsafeBytes {
                                            Data($0)
                                        } as CFData,
                                               ([kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
                                                kSecAttrKeyClass: kSecAttrKeyClassPrivate]
                                                as [String: Any]) as CFDictionary,
                                               nil)!]
                   as [String: Any] as CFDictionary, nil)
        
        return key
    }
}
