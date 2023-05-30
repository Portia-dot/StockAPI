import Foundation

public struct StockAPI {
    private let session = URLSession.shared
    private let jsonDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    
    //Chart
    public func fetchChartData(symbol: String, range: ChartRange) async throws -> ChartData? {
        guard var urlComponents = URLComponents(string: "\(baseURL)/v8/finance/chart/\(symbol)")else{
            throw APIError.invalidURL
        }
        urlComponents.queryItems = [
            .init(name: "range", value: range.rawValue),
            .init(name: "interval", value: range.interval),
            .init(name: "indicator", value: "quote"),
            .init(name: "includeTimeStamps", value: "true")
        
        ]
        guard let url = urlComponents.url else{
            throw APIError.invalidURL
        }
        let (response, statusCode): (ChartResponse, Int) = try await fetch(url: url)
        if let error =  response.error {
            throw APIError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }
        return response.data?.first
    }

    
    //Search Query
    public func searchTickers(query: String, isEquityTypeOnly: Bool = true) async throws -> [SearchQuery]{
        guard var urlComponents = URLComponents(string: "\(baseURL)/v1/finance/search")else{
            throw APIError.invalidURL
        }
        urlComponents.queryItems = [
            .init(name: "q", value: query),
            .init(name: "quotesCount", value: "20"),
            .init(name: "lang", value: "en-US")
        
        ]
        guard let url = urlComponents.url else{
            throw APIError.invalidURL
        }
        
        let (response, statusCode): (searchQueryResponse, Int) = try await fetch(url: url)
        if let error = response.error {
            throw APIError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }
        if isEquityTypeOnly{
            return (response.data ?? [])
                .filter{ ($0.quoteType ?? "").localizedCaseInsensitiveCompare("equity") == .orderedSame}
        }else{
            return response.data ?? []
        }
        
    }
    
    
    private let baseURL = "https://query1.finance.yahoo.com"
    
        // ...
        private var cookieString: String?
        private var crumb: String?

        public init() {}

    public mutating func fetchQuotes(symbols: String) async throws -> [Quotes] {
        // If crumb is nil, fetch it
        if crumb == nil {
            let crumbUrl = URL(string: "https://query2.finance.yahoo.com/v1/test/getcrumb")!
            let (crumbData, _) = try! await URLSession.shared.data(from: crumbUrl)
            let crumbValue = String(decoding: crumbData, as: UTF8.self)
            
            // Store crumb for later use
            self.crumb = crumbValue
            
            // Print crumb
            print("Crumb: \(crumbValue)")
        }

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

        let (quoteData, quoteResponse) = try! await URLSession.shared.data(from: url)
        
        guard let quoteHttpResponse = quoteResponse as? HTTPURLResponse else {
            throw APIError.httpStatusCodeFailed(statusCode: (quoteResponse as? HTTPURLResponse)?.statusCode ?? 0, error: nil)
        }

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
