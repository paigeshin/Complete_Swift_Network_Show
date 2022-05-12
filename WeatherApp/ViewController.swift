//
//  ViewController.swift
//  WeatherApp
//
//  Created by paige shin on 2022/05/12.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftyJSON

/// Privacy - Location When In Use Usage Description
class ViewController: UIViewController {

    private lazy var cityLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 16)
        label.textColor = UIColor.white
        label.text = "--"
        label.textAlignment = .center
        return label
    }()
    
    
    private lazy var temperatureLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont(name: "Helvetica Neue-UltraThin", size: 75)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "--"
        return label
    }()
    
    private let humidityLabel: UILabel = UILabel()
    private let windSpeedLabel: UILabel = UILabel()
    
    override func loadView() {
        super.loadView()
        view.addSubview(cityLabel)
        view.addSubview(temperatureLabel)
        let temperatureGuideLabel: UILabel = UILabel()
        temperatureGuideLabel.text = "TEMPEATURE"
        temperatureGuideLabel.textColor = UIColor.init(white: 1, alpha: 0.5)
        temperatureGuideLabel.font = UIFont(name: "Helvetica Neue-Medium", size: 14)
        view.addSubview(temperatureGuideLabel)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 60).isActive = true
        temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        temperatureGuideLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 15).isActive = true
        temperatureGuideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.topAnchor.constraint(equalTo: temperatureGuideLabel.bottomAnchor, constant: 60).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        let humidityView: UIView = UIView()
        let humidityGuideLabel: UILabel = UILabel()
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        humidityGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        humidityLabel.text = "--"
        humidityLabel.font = UIFont(name: "Helvetica Neue-Thin", size: 50)
        humidityGuideLabel.text = "HUMIDITY"
        humidityGuideLabel.textColor = UIColor.init(white: 1, alpha: 0.7)
        humidityLabel.textColor = .white
        
        humidityView.addSubview(humidityLabel)
        humidityView.addSubview(humidityGuideLabel)
        humidityLabel.topAnchor.constraint(equalTo: humidityView.topAnchor).isActive = true
        humidityLabel.centerXAnchor.constraint(equalTo: humidityView.centerXAnchor).isActive = true
        humidityGuideLabel.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 15).isActive = true
        humidityGuideLabel.centerXAnchor.constraint(equalTo: humidityView.centerXAnchor).isActive = true
        humidityGuideLabel.bottomAnchor.constraint(equalTo: humidityView.bottomAnchor).isActive = true
        
        let windSpeedView: UIView = UIView()
        let windSpeedGuideLabel: UILabel = UILabel()
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        windSpeedLabel.text = "--"
        windSpeedLabel.font = UIFont(name: "Helvetica Neue-Thin", size: 50)
        windSpeedGuideLabel.text = "WIND SPEED"
        windSpeedGuideLabel.textColor = UIColor.init(white: 1, alpha: 0.7)
        windSpeedLabel.textColor = .white
        
        windSpeedView.addSubview(windSpeedLabel)
        windSpeedView.addSubview(windSpeedGuideLabel)
        windSpeedLabel.topAnchor.constraint(equalTo: windSpeedView.topAnchor).isActive = true
        windSpeedLabel.centerXAnchor.constraint(equalTo: windSpeedView.centerXAnchor).isActive = true
        windSpeedGuideLabel.topAnchor.constraint(equalTo: windSpeedLabel.bottomAnchor, constant: 15).isActive = true
        windSpeedGuideLabel.centerXAnchor.constraint(equalTo: windSpeedView.centerXAnchor).isActive = true
        windSpeedGuideLabel.bottomAnchor.constraint(equalTo: windSpeedView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(humidityView)
        stackView.addArrangedSubview(windSpeedView)
    }
    
    private var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 15/255, green: 24/255, blue: 46/255, alpha: 1)
        initializeLocationManager()

        
    }


}

extension ViewController: CLLocationManagerDelegate {
    
    private func initializeLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        #if DEBUG
        print(error.localizedDescription)
        #endif
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude: String = String(location.coordinate.latitude)
            let longitude: String = String(location.coordinate.longitude)
            print(latitude)
            print(longitude)
            getWeatherWithURLSession(lat: latitude, long: longitude)
        }
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied, .restricted:
            let alertController: UIAlertController = UIAlertController(title: "Location Access Disabled", message: "Weahter App needs your location to give a weather forecast", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alertController.dismiss(animated: true)
            }
            alertController.addAction(cancelAction)
            
            let openAction: UIAlertAction = UIAlertAction(title: "Open", style: .default) { _ in
                if let url: URL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            alertController.addAction(openAction)
            
            present(alertController, animated: true)
        default:
            break
        }
    }

}

// API REQUESTS
extension ViewController {
    
    enum APIRequestMethods {
        case alamofire
        case alamofireWithHeaderAndBody
        case customURLSession
        case urlSession
    }
    
    private func getWeatherWithURLSession(lat: String, long: String, method: APIRequestMethods = .customURLSession) {
        /// ALAMOFIRE with header and body
        if method == .alamofireWithHeaderAndBody {
            
            let urlString: String = "\(APIClient.shared.getWeatherData(lat: lat, lon: long))&appId=\(APIClient.shared.apiKey)"
            
            guard let url: URL = URL(string: urlString) else {
                print("Could not form URL")
                return
            }
            let headers: HTTPHeaders = [
                "Accept": "application/json"
            ]
            let parameters: Parameters = [:]
            AF.request(url, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let jsonData: [String: Any] = data as? [String: Any] {
                        print(jsonData)
                        DispatchQueue.main.async { [weak self] in
                            self?.parseJSONWithSwifty(data: jsonData)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
        }

    
        /// ALAMOFIRE
        if method == .alamofire {
            
            let urlString: String = "\(APIClient.shared.getWeatherData(lat: lat, lon: long))&appId=\(APIClient.shared.apiKey)"
            
            guard let url: URL = URL(string: urlString) else {
                print("Could not form URL")
                return
            }
            AF.request(url).responseJSON { [weak self] response in
                switch response.result {
                case .success(let data):
                    if let jsonData: [String: Any] = data as? [String: Any] {
                        print(jsonData)
                        DispatchQueue.main.async {
                            self?.parseJSONManually(data: jsonData)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        
        /// CUSTOM REQUEST
        if method == .customURLSession {
            
            let apiKey: String = APIClient.shared.apiKey
            if var urlCompoents: URLComponents = URLComponents(string: APIClient.shared.baseURL) {
                urlCompoents.query = "lat=\(lat)&lon=\(long)&appId=\(apiKey)"
                guard let url: URL = urlCompoents.url else { return }
                var request: URLRequest = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
                let config: URLSessionConfiguration = URLSessionConfiguration.default
                let session: URLSession = URLSession(configuration: config)
                let task: URLSessionDataTask = session.dataTask(with: request) { data, response, error in
                    if let error: Error = error {
                        #if DEBUG
                        print(error.localizedDescription)
                        #endif
                        return
                    }
                    
                    guard let data: Data = data else {
                        return
                    }
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.parseJSONWithCodable(data: data)
                    }

                }
                task.resume()
            }
            
        }

        /// COMMON
        if method == .urlSession {
            let apiKey: String = APIClient.shared.apiKey
            guard let weatherURL: URL = URL(string: "\(APIClient.shared.getWeatherData(lat: lat, lon: long))&appId=\(apiKey)") else { return }
            URLSession.shared.dataTask(with: weatherURL) { data, _, error in
                
                if let error: Error = error {
                    #if DEBUG
                    print(error.localizedDescription)
                    #endif
                    return
                }
                
                guard let data: Data = data else {
                    return
                }
                
                do {
                    guard let weatherData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        print("There was an error converting data into JSON")
                        return
                    }
                    print(weatherData)
                    self.parseJSONWithSwifty(data: weatherData)
                } catch {
                    print("Error converting data into JSON")
                }
                
            }
            .resume()
             
        }
    }
    
    private func parseJSONManually(data: [String: Any]) {
        if let main: [String: Any] = data["main"] as? [String: Any] {
            if let humidity: Int = main["humidity"] as? Int {
                humidityLabel.text = "\(humidity)"
            }
            if let temp: Double = main["temp"] as? Double {
                temperatureLabel.text = "\(temp)"
            }
        }
        if let wind: [String: Any] = data["wind"] as? [String: Any] {
            if let windSpeed: Double = wind["speed"] as? Double {
                windSpeedLabel.text = "\(windSpeed)"
            }
        }
        if let name: String = data["name"] as? String {
            cityLabel.text = name
        }
    }

    private func parseJSONWithSwifty(data: [String: Any]) {
        let jsonData: JSON = JSON(data)
        if let humidity: Int = jsonData["main"]["humidity"].int {
            humidityLabel.text = "\(humidity)"
        }
        if let temp: Double = jsonData["main"]["temp"].double {
            temperatureLabel.text = "\(temp)"
        }
        if let speed: Double = jsonData["wind"]["speed"].double {
            windSpeedLabel.text = "\(speed)"
        }
        if let name: String = jsonData["name"].string {
            cityLabel.text = name
        }
    }
    
    private func parseJSONWithCodable(data: Data) {
        do {
            let weatherObject = try JSONDecoder().decode(WeatherModel.self, from: data)
            print(weatherObject)
            humidityLabel.text = "\(weatherObject.humidity)"
            temperatureLabel.text = "\(weatherObject.temp)"
            windSpeedLabel.text = "\(weatherObject.windSpeed)"
            cityLabel.text = weatherObject.name
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}

class WeatherModel: NSObject, Codable {
    
    var name: String = ""
    var temp: Double = 0.0
    var humidity: Int = 0
    var windSpeed: Double = 0.0
    
    // Key name from json
    enum CodingKeys: String, CodingKey {
        case name
        case main
        case wind
        case humidity
        case temp
        case speed
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    override init() {
        
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let main = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .main)
        let wind = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .wind)
        name = try container.decode(String.self, forKey: .name)
        temp = try main.decode(Double.self, forKey: .temp)
        humidity = try main.decode(Int.self, forKey: .humidity)
        windSpeed = try wind.decode(Double.self, forKey: .speed)
    }
    
}
