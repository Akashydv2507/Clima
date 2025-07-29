//
//  WeatherManager.swift
//  Clima
//  Created by Akash Yadav on 25/07/25.
//

import Foundation
import CoreLocation


protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager ,weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=8e40a4c8b6ba99454a2215b7ac60514c&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees , longitude: CLLocationDegrees ){
       let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        // step 1: Create URL
        if let url = URL(string: urlString){
            
            //step 2: Create a URL section
            let session = URLSession(configuration: .default)
            
            //step 3: Give URL session a task
            // let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))
            // we comment out pervious line because to implement the session task with trailing closures properties
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    // this down two lines used before JSON format
                    /* let dataString = String(data: safeData, encoding: .utf8)
                     print(dataString) */
                    // Noew we using JSON format for datastring
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //step 4: start the task
            task.resume()
            
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
       let decoder = JSONDecoder()
        do {
          let decodedData =  try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.name) // to print the user entered value
            print(decodedData.main.temp) // temp
            print(decodedData.weather[0].description) // description
            print(decodedData.weather[0].id) // weather id for type
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, CityName: name, temperature: temp)
            print(weather.conditionName) // type of image we gonna use to display the type
            print(weather.temperatureString)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
