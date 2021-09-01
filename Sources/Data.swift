import Foundation
import CryptoKit

private let account = "Secrets.Archive.v1"

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
                            (try? AES.GCM.SealedBox(combined: self))
                                .flatMap {
                                    try? AES.GCM.open($0, using: key)
                                }
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
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecUseDataProtectionKeychain: true,
            kSecReturnData: true] as [String: Any]

        var item: CFTypeRef?
        
        guard
            SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
            let data = item as? Data
        else { return nil }
        
        return .init(data: data)
    }
    
    private var generate: SymmetricKey? {
        let key = SymmetricKey(size: .bits256)
        
        guard
            SecItemAdd([
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: account,
                kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
                kSecUseDataProtectionKeychain: true,
                kSecValueData: key
                    .withUnsafeBytes {
                        Data($0)
                    }] as [String: Any] as CFDictionary, nil) == errSecSuccess
                
        else { return nil }
        
        return key
    }
}
