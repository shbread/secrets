import Foundation
import CryptoKit

private let label = "Secrets"

enum Security {
    static var key: SymmetricKey?
    
    private static var retrieve: SymmetricKey? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrLabel: label,
            kSecUseDataProtectionKeychain: true,
            kSecAttrSynchronizable: true,
            kSecReturnData: true] as [String: Any]

        var item: CFTypeRef?
        
        guard
            SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
            let data = item as? Data
        else { return nil }
        
        key = .init(data: data)
        return key
    }
    
    private static var generate: SymmetricKey? {
        key = .init(size: .bits256)
        
        guard
            SecItemAdd([
                kSecClass: kSecClassGenericPassword,
                kSecAttrLabel: label,
                kSecUseDataProtectionKeychain: true,
                kSecAttrSynchronizable: true,
                kSecValueData: key!
                    .withUnsafeBytes {
                        Data($0)
                    }] as [String: Any] as CFDictionary, nil) == errSecSuccess
                
        else { return nil }
        
        return key
    }
    
    static func encrypt(data: Data) -> Data {
        (key ?? retrieve ?? generate)
            .flatMap { key in
                try? AES
                    .GCM
                    .seal(data, using: key)
                    .combined
            }
        ?? .init()
    }
    
    static func decrypt(data: Data) -> Data {
        (key ?? retrieve)
            .flatMap { key in
                (try? AES
                    .GCM
                    .SealedBox(combined: data))
                    .flatMap {
                        try? AES
                            .GCM
                            .open($0, using: key)
                    }
            }
        ?? .init()
    }
}
