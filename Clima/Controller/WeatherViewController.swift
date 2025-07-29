//
//  ViewController.swift
//  Clima
//  Created by Akash Yadav on 25/07/25.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    // this line of code written to import the properties of the weathermanager
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        weatherManager.delegate = self
        // text Field should report the controller and self refer to currnt view controller
        searchTextField.delegate = self
    }
    @IBAction func searchPressed(_ sender: UIButton) {
        // this will help to dismiss the keyboard from screen
        searchTextField.endEditing(true)
        // this print the text the user wrote in the search field
        print(searchTextField.text!)
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation( )
    }
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    // this func is for when user typed the word in search field and pressed go button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // endEditing will help to dismiss the keyboard from screen
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    // this function will make user know that they have write something before the click on search button
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Write Something"
            return false
        }
    }
    //Tells the delegate when editing stops for the specified text field
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        // use seachTextField.text to get the weather for that city
        searchTextField.text = ""
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManager ,weather: WeatherModel){
        print(weather.temperature)
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.CityName
        }
    }
    
    func didFailWithError(error: any Error) {
        //print("Failed to fetch weather: \(error)")
        print(error)
    }
    
}
// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("We got your location")
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
