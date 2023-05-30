//
//  File.swift
//  
//
//  Created by Oluwayomi M on 2023-05-27.
//

import Foundation

public struct QuoteResponse: Decodable{
    public let data: [Quotes]?
    public let error: Error?
    
    enum CodingKeys: CodingKey{
        case quoteResponse
        case finance
    }
    enum ResponseKeys: CodingKey{
        case result
        case error
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Use the container to decode values
        
        if let quoteResponseContainer = try? container.nestedContainer(keyedBy: ResponseKeys.self, forKey: .quoteResponse) {
            self.data = try? quoteResponseContainer.decodeIfPresent([Quotes].self, forKey: .result)
            self.error = try? quoteResponseContainer.decodeIfPresent(Error.self, forKey: .error)
        }else if let financeResponseContainer = try? container.nestedContainer(keyedBy: ResponseKeys.self, forKey: .finance){
            self.data = try? financeResponseContainer.decodeIfPresent([Quotes].self, forKey: .result)
            self.error = try? financeResponseContainer.decodeIfPresent(Error.self, forKey: .error)
        }else{
            self.data = nil
            self.error = nil
        }
    }

}
public struct Quotes: Codable, Identifiable, Hashable{
    
    public var id = UUID()
    public let currency: String?
    public let marketState: String?
    public let fullExchangeName: String?
    public let exchangeTimezoneName: String?
    public let displayName: String?
    public let symbol: String?
    public let regularMarketPrice: Double?
    public let regularMarketChange: Double?
    public let regularMarketChangePercent: Double?
    public let regularMarketPreviousClose: Double?
    
    public let postMarketPrice : Double?
    public let postMarketChange: Double?
    
    public let regularMarketDayHigh: Double?
    public let regularMarketOpen: Double?
    public let regularMarketDayLow: Double?
    
    public let regularMarketVolume: Double?
    public let trailingPE: Double?
    public let marketCap: Double?
    
    public let fiftyTwoWeekLow: Double?
    public let fiftyTwoWeekHigh: Double?
    public let averageDailyVolume3Month: Double?
    
    public let trailingAnnualDividendYield: Double?
    public let epsTrailingTwelveMonths: Double?
    
    public init(currency: String?, marketState: String?, fullExchangeName: String?, exchangeTimezoneName: String?, displayName: String?, symbol: String?, regularMarketPrice: Double?, regularMarketChange: Double?, regularMarketChangePercent: Double?, regularMarketPreviousClose: Double?, postMarketPrice: Double?, postMarketChange: Double?, regularMarketDayHigh: Double?, regularMarketOpen: Double?, regularMarketDayLow: Double?, regularMarketVolume: Double?, trailingPE: Double?, marketCap: Double?, fiftyTwoWeekLow: Double?, fiftyTwoWeekHigh: Double?, averageDailyVolume3Month: Double?, trailingAnnualDividendYield: Double?, epsTrailingTwelveMonths: Double?) {
        self.currency = currency
        self.marketState = marketState
        self.fullExchangeName = fullExchangeName
        self.exchangeTimezoneName = exchangeTimezoneName
        self.displayName = displayName
        self.symbol = symbol
        self.regularMarketPrice = regularMarketPrice
        self.regularMarketChange = regularMarketChange
        self.regularMarketChangePercent = regularMarketChangePercent
        self.regularMarketPreviousClose = regularMarketPreviousClose
        self.postMarketPrice = postMarketPrice
        self.postMarketChange = postMarketChange
        self.regularMarketDayHigh = regularMarketDayHigh
        self.regularMarketOpen = regularMarketOpen
        self.regularMarketDayLow = regularMarketDayLow
        self.regularMarketVolume = regularMarketVolume
        self.trailingPE = trailingPE
        self.marketCap = marketCap
        self.fiftyTwoWeekLow = fiftyTwoWeekLow
        self.fiftyTwoWeekHigh = fiftyTwoWeekHigh
        self.averageDailyVolume3Month = averageDailyVolume3Month
        self.trailingAnnualDividendYield = trailingAnnualDividendYield
        self.epsTrailingTwelveMonths = epsTrailingTwelveMonths
    }
    
}
