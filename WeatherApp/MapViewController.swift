//
//  ViewController.swift
//  WeatherApp
//
//  Created by Roger Villarreal on 2/23/18.
//  Copyright © 2018 Roger Alexander. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "56d468b60eaea6d040954f019dc873a8"
    
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var weatherData = WeatherData()
    var selectedAreaWeather = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    // MARK: - Networking
    /*********************************************/
    func getWeatherData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success, got the Weather Data!")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print("Error \(response.result.error)")
                self.currentWeatherLabel.text = "Connection Issues..."
            }
        }
    }
    
    // MARK: - JSON Parsing
    /*********************************************/
    
    func updateWeatherData(json: JSON) {
        
                if let tempResult = json["main"]["temp"].double {
                    weatherData.temperature = Int(tempResult - 273.15) // kelving to Celsius
                    currentWeatherLabel.text = "Current Weather: " + String((weatherData.temperature * 9) / 5 + 32 ) + "℉"
                }
                else {
                    currentWeatherLabel.text = "Weather Unavailable"
                }
    }
    
    // MARK: - Location Manager Delegate Methods
    /*********************************************/
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.05, 0.05)
        let currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(currentLocation, span)
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true
        
        if !locations.isEmpty {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil // stops from printing multiple times
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lon": longitude, "lat": latitude, "appid": APP_ID]
            print(params)
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }

    
    @IBAction func mapDoubleTapped(_ sender: UITapGestureRecognizer) {

            let touchLocation = sender.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        
        let latitude = String(locationCoordinate.latitude)
        let longitude = String(locationCoordinate.longitude)
        
        let params : [String : String] = ["lon": longitude, "lat": latitude, "appid": APP_ID]
        print(params)
        
        getWeatherData(url: WEATHER_URL, parameters: params)
        
        // pass current weather.text
        performSegue(withIdentifier: "segue", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var nextVC = segue.destination as! SelectedAreaViewController
        nextVC.temperaturePassed = currentWeatherLabel.text!
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

