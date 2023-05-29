//
//  File.swift
//  
//
//  Created by Oluwayomi M on 2023-05-27.
//

import Foundation

public struct Error: Codable{
    public let code: String
    public let description : String
    
    public init(code: String, description: String) {
        self.code = code
        self.description = description
    }
}
