import Foundation

class KeychainHelper {
    static let shared = KeychainHelper() // シングルトン

    private init() {} // 外部からのインスタンス生成を防ぐ

    func save(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        _ = delete(forKey: key) // 同じキーのデータが存在する場合は削除
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func retrieve(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data, let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        return value
    }

    func delete(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }

    // ここに saveCredentials を追加
    func saveCredentials(workplaceID: String, token: String, placeName: String) {
        let credentials = [
            "workplaceID": workplaceID,
            "token": token,
            "placeName": placeName
        ]

        for (key, value) in credentials {
            let success = save(value, forKey: key)
            if success {
                print("\(key)の保存に成功しました")
            } else {
                print("\(key)の保存に失敗しました")
            }
        }
    }
}
