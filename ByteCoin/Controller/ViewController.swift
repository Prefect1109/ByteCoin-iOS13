import UIKit

class ViewController: UIViewController{
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var cityPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        cityPicker.dataSource = self
        cityPicker.delegate = self
        // Do any additional setup after loading the view.
    }
}
//MARK: - UIPickerView DataSource & Delegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}
//MARK: - CoinManagerDelegete
extension ViewController: CoinManagerDelegate{
    func didupdatePrice(price: String, currency: String) {
        
        DispatchQueue.main.async {
            self.valueLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    func loudDidFailed(_ error: Error){
        print("Error")
    }
}


