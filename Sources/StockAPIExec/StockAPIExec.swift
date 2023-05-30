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
    
    static var stocksAPI = StockAPI()
    static func main() async{
        
        
        do {
            let quotes = try await stocksAPI.fetchQuotes(symbols: "AAPL, MSFT, GOOG, TSLA")
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

        
        // Define a URLSession object
        //        let urlSession = URLSession.shared
        //
        ////        // Make HTTP GET call to URL https://fc.yahoo.com
        ////        let cookieUrl = URL(string: "https://fc.yahoo.com")!
        ////        let (cookieData, cookieResponse) = try! await urlSession.data(from: cookieUrl)
        ////        guard let cookieHttpResponse = cookieResponse as? HTTPURLResponse else {
        ////            print("Failed to get HTTP response")
        ////            return
        ////        }
        ////
        ////        // Extract set-cookie from response headers
        ////        guard let cookieString = cookieHttpResponse.allHeaderFields["Set-Cookie"] as? String else {
        ////            print("Failed to get cookie")
        ////            return
        ////        }
        //
        //        // Make an HTTP GET call to the URL https://query2.finance.yahoo.com/v1/test/getcrumb
        //        let crumbUrl = URL(string: "https://query2.finance.yahoo.com/v1/test/getcrumb")!
        //        var crumbRequest = URLRequest(url: crumbUrl)
        ////        crumbRequest.addValue(cookieString, forHTTPHeaderField: "Cookie")
        //        let (crumbData, _) = try! await urlSession.data(for: crumbRequest)
        //
        //        // Parse crumb value
        //        let crumb = String(decoding: crumbData, as: UTF8.self)
        //        print(crumb)
        //
        //        // Replace [crumb-value] in the following URL and make a HTTP GET call with cookie
        //        let quoteUrl = URL(string: "https://query2.finance.yahoo.com/v7/finance/quote?symbols=TSLA&crumb=\(crumb)")!
        //        var quoteRequest = URLRequest(url: quoteUrl)
        ////
        //
        //        let (quoteData, _) = try! await urlSession.data(for: quoteRequest)
        //
        //        // Decode the response
        //        let quoteResponse = try! JSONDecoder().decode(QuoteResponse.self, from: quoteData)
        ////        print(quoteResponse)
        
        
        //SEARCH QUERY
        //        do {
        //            let url = URL(string: "https://query1.finance.yahoo.com/v1/finance/search?q=TESLA")!
        //            let (searchData, _) = try await URLSession.shared.data(from: url)
        //            // Process searchData
        //
        //            let decoder = JSONDecoder()
        //            if let searchResponse = try? decoder.decode(searchQueryResponse.self , from: searchData) {
        //                print(searchResponse)
        //            } else {
        //                print("Failed to decode JSON.")
        //            }
        //        } catch {
        //            print("Failed to fetch data: \(error)")
        //        }
        //
        //    }
        
        //        do {
        //            let url = URL(string: "https://query1.finance.yahoo.com/v8/finance/chart/AAPL?range=1d&interval=1m&indicators=quote&includeTimestamps=true")!
        //            let (chartData, _) = try await URLSession.shared.data(from: url)
        //
        //            let decoder = JSONDecoder()
        //            if let chartResponse = try? decoder.decode(ChartResponse.self , from: chartData) {
        //                print(chartResponse)
        //            } else {
        //                print("Failed to decode JSON.")
        //            }
        //        } catch {
        //            print("Failed to fetch data: \(error)")
        //        }
        //    }
    }
}
