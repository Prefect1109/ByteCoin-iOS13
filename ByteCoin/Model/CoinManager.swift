import Foundation

protocol CoinManagerDelegate{
    func didupdatePrice(price: String, currency: String)
    func loudDidFailed(_ error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        
        let urlString = baseURL + currency
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, responce, error) in
                if error != nil{
                    self.delegate?.loudDidFailed(error!)
                    print(error!)
                    return
                }
                if let safeData = data{
                    if let bitcoinPrice = self.parceJSON(safeData){
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didupdatePrice(price: priceString, currency: currency)
                        //   Task 1 look into the Clima code, and check out what going on here
                    }
                }
            }
            task.resume()
        }
    }
    
    func parceJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(CoinData.self, from: data)
            let id = decoderData.last
            
            return id
        }catch{
            self.delegate?.loudDidFailed(error)
            return nil
        }
    }
}
