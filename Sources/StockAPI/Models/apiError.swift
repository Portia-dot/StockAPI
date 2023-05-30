//
//  File.swift
//  
//
//  Created by Oluwayomi M on 2023-05-27.
//

import Foundation

public enum APIError: CustomNSError{
    case invalidURL
    case invalidResponseType
    
    case httpStatusCodeFailed(statusCode: Int, error: Error?)
    
    public static var errorDomain: String {
        "StocksAPI"
    }
    public var errorCode: Int {
        switch self{
        case .invalidURL: return 0
        case .invalidResponseType: return 1
        case .httpStatusCodeFailed: return 2

        }
    }
    public var errorUserInfo: [String : Any]{
        let text: String
        switch self{
        case .invalidURL:
            text = "Invalid URL"
        case .invalidResponseType:
            text = "Invalid Reponse Type"
        case let .httpStatusCodeFailed(statusCode, error):
            if let error = error{
                text = "Error: Status Code \(statusCode), message: \(error.description)"
            }else{
                text = "Error: Status Code \(statusCode)"
            }
        }
        return [NSLocalizedDescriptionKey: text]
    }
}
