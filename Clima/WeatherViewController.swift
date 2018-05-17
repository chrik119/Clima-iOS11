//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate{
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "5dd0c661e3e229f0d57566ecf6908c6c"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url : String, parameters : [String : String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                print("Success")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherInfo(weatherJSON)
            }
            else{
                print("ERROR: \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
            
        }
    }

    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherInfo(_ wj : JSON) {
        if let temp : Double = wj["main"]["temp"].double {
            weatherDataModel.temp = Int( ((9 / 5) * (temp - 273.15)) + 32)
            weatherDataModel.city = wj["name"].stringValue
            weatherDataModel.cond = wj["weather"][0]["id"].intValue
            weatherDataModel.wIcon = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.cond)
            updateUIWithWeatherData()
        }
        else{
            cityLabel.text = "Unavailable"
        }
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temp)"
        weatherIcon.image = UIImage(named: weatherDataModel.wIcon)
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            let long = String(location.coordinate.longitude)
            let lat = String(location.coordinate.latitude)
            
            let params : [String : String] = ["lat" : lat, "lon" : long, "appid" : APP_ID]
            getWeatherData(url : WEATHER_URL, parameters : params)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


