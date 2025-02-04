//
//  Environment.swift
//  InventoryManager_app
//
//  Created by 古田 舜弥 on 2024/12/14.
//

import Foundation

enum AppEnvironment {
    static let baseUrl: String = {
        return Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
    }()
}
