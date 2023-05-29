import Foundation

public struct StockAPI {
    private let session = URLSession.shared
    private let jsonDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    private let baseURL = "https://query1.finance.yahoo.com"
    
    public func fetchQuotes(symbols: String) async throws -> [Quotes]{
        let urlSession = URLSession.shared

        
        let crumbUrl = URL(string: "https://query2.finance.yahoo.com/v1/test/getcrumb")!
        var crumbRequest = URLRequest(url: crumbUrl)
//        crumbRequest.addValue(cookieString, forHTTPHeaderField: "Cookie")
        let (crumbData, _) = try! await urlSession.data(for: crumbRequest)

        // Parse crumb value
        let crumb = String(decoding: crumbData, as: UTF8.self)

        guard var urlComponents = URLComponents(string: "\(baseURL)/v7/finance/quote") else {
            throw APIError.invalidURL
        }
        urlComponents.queryItems = [
            .init(name: "symbols", value: symbols),
            .init(name: "crumb", value: crumb)
        ]
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        print("URL: \(url)")
        
        
        let request = URLRequest(url: url)
//        request.addValue(cookieString, forHTTPHeaderField: "Cookie")

        let (quoteData, quoteResponse) = try! await urlSession.data(for: request)

        guard let quoteHttpResponse = quoteResponse as? HTTPURLResponse else {
            throw APIError.httpStatusCodeFailed(statusCode: (quoteResponse as? HTTPURLResponse)?.statusCode ?? 0, error: nil)
        }

        if quoteHttpResponse.statusCode != 200 {
            throw APIError.httpStatusCodeFailed(statusCode: quoteHttpResponse.statusCode, error: nil)
        }

        // Decode the response
        let quoteResponseDecoded = try! JSONDecoder().decode(QuoteResponse.self, from: quoteData)

        if let error = quoteResponseDecoded.error {
            throw APIError.httpStatusCodeFailed(statusCode: quoteHttpResponse.statusCode, error: error)
            
        }

        return quoteResponseDecoded.data ?? [] 
    }

    
    
    private func fetch <D: Decodable> (url: URL) async throws -> (D, Int){
        let (data, reponse) = try await session.data(from: url)
        let statusCode = try validateHTTPResponse(reponse)
        return (try jsonDecoder.decode(D.self, from: data), statusCode)
    }

    public init() {
    }
    
    private func validateHTTPResponse(_ response: URLResponse) throws -> Int{
        guard let httpResponse = response as? HTTPURLResponse else{
            throw APIError.invalidResponseType
        }
        guard 200...299 ~= httpResponse.statusCode ||
                400...499 ~= httpResponse.statusCode
        else{
            throw APIError.httpStatusCodeFailed(statusCode: httpResponse.statusCode, error: nil)
        }
        return httpResponse.statusCode
    }
}
