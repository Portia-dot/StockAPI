//
//  File.swift
//  
//
//  Created by Oluwayomi M on 2023-05-26.
//

import Foundation
import StockAPI

@main
struct StockAPIExec{
    
    static func main() async{
        var stocksAPI = StockAPI()
        do {
            let quotes = try await stocksAPI.fetchQuotes(symbols: "AAPL")
            print(quotes)
            
           // Tickers
            let tickers = try await stocksAPI.searchTickers(query: "tesla")
            print(tickers)
            
            //Chart
            
            let chart = try await stocksAPI.fetchChartData(symbol: "AAPL", range: .oneDay)
            
                print(chart)
        } catch {
            print(error.localizedDescription)
        }
    }
}
