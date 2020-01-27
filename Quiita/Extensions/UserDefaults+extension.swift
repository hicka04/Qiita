//
//  UserDefaults+extension.swift
//  Quiita
//
//  Created by hicka04 on 2020/01/19.
//  Copyright © 2020 hicka04. All rights reserved.
//

import Foundation
import Combine

extension UserDefaults {
    
    func set<Value: Codable>(_ value: Value, forKey key: String) {
        let data = try? JSONEncoder().encode(value)
        self.setValue(data, forKey: key)
    }
    
    func codable<Value: Codable>(forKey key: String) -> Value? {
        guard let data = self.data(forKey: key),
            let value = try? JSONDecoder().decode(Value.self, from: data) else {
                return nil
        }
        return value
    }
}
