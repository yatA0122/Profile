//
//  LoginResponse.swift
//  InventoryManager_app
//
//  Created by 古田 舜弥 on 2024/12/04.
//

struct LoginResponse: Codable {
    let status: String
    let Token: String?
    let message: String?
}
