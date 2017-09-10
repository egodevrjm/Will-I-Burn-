//
//  ViewController.swift
//  Will I Burn?
//
//  Created by Ryan Morrison on 09/09/2017.
//  Copyright © 2017 egoDev. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {

    // Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var skinToneLabel: UILabel!
    @IBOutlet weak var skinButton: UIButton!
   
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var currentUVLabel: UILabel!
    
    // Variables
    let locationManager = CLLocationManager()
    var coords: CLLocationCoordinate2D?
    
    var skinType: String = Utils().getSkinType() {
        didSet {
            updateSkinTypeLabel()
            Utils().setSkinType(value: skinType)
        }
    }
    
    var uvIndex = 10
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Loading Views
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        getLocation()
        updateSkinTypeLabel()
        
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        getLocation()
        updateSkinTypeLabel()
    }
    
    // MARK: - Action Buttons
    @IBAction func skinButton(_sender: UIButton) {
        let alert = UIAlertController(title: "Select your skin colour", message: "Please choose the colour description that is closest to your skin type.", preferredStyle: .actionSheet)
        for var st in SkinType().allSkinTypes() {
            alert.addAction(UIAlertAction(title: st, style: .default, handler: { (action) in
                alert.view.tintColor = UIColor.black
                self.skinType = action.title!
                self.getLocation()
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    

    // MARK: - My functions
    
    func showActivityIndicator(dataSuccess: Bool) {
        DispatchQueue.main.async {
            
        if !dataSuccess {
            self.loadingLabel.isHidden = false
            self.activityIndicator.isHidden = false
            self.loadingLabel.text = "Failed. Retrying."
            self.getWeatherData()
            return
        }
            self.loadingLabel.isHidden = false
            self.activityIndicator.isHidden = false
            self.activityIndicator.stopAnimating()
            self.loadingLabel.text = "Got UV Data"
            let burnTime = self.calculateBurnTime()
            self.timeLabel.text = """
            Burn Time
            \(burnTime) mins
            """
            
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getLocation() {
        if let location = locationManager.location {
            coords = location.coordinate
            
            DispatchQueue.main.async {
                self.getWeatherData()
            }
        }
    }
    
    func updateSkinTypeLabel() {
        skinToneLabel.text = "Skin Type: \(skinType)"
    }
    
    func getWeatherData() {
        
        if let cds = coords {
            let url = WeatherAPI(lat: String(cds.latitude), lon: String(cds.longitude)).getFullWeatherUrl()
             Alamofire.request(url).responseJSON { response in
                if let JSON = response.result.value {
                    self.getUVIndex(json: JSON)
                    
                } else {
                    //only get here if we don't get UV Index from API
                    self.showActivityIndicator(dataSuccess: false)
                }
            }
        }
    }
    
    func getUVIndex(json: Any) {
        if let data = json as? Dictionary<String, AnyObject> {
            if let dt = data["data"]  as? Dictionary<String, AnyObject> {
                if let weather = dt["weather"] as? [Dictionary<String, AnyObject>] {
                    if let uvIndex = weather[0]["uvIndex"] as? String {
                        self.uvIndex = Int(uvIndex)!
                        self.currentUVLabel.text = "Current UV:  \(Int(uvIndex)!)"
                        print("UV: " + String(uvIndex))
                        self.showActivityIndicator(dataSuccess: true)
                        let when = DispatchTime.now() + 1
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            self.loadingLabel.isHidden = true
                            self.activityIndicator.isHidden = true
                        }
                        return
                    }
                }
            }
        }
        //only get here if we don't get UV Index from API
        self.showActivityIndicator(dataSuccess: false)
    }
    
    func calculateBurnTime() -> Int {
        let burnTime = BurnTimes().calcBurnTime(skinType: skinType, uvIndex: Int(uvIndex))
        return burnTime
    }
    
    // MARK: - Built in functions
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedWhenInUse) {
            print("Authorised")
        } else if (status == .denied) {
            print("Denied")
            
            let alert = UIAlertController(title: "Error", message: "Please allow app to access your location in your settings then return to try again.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            alert.view.tintColor = UIColor.black
            present(alert, animated: true, completion: nil)
            
        } else if (status == .notDetermined) {
            print("Not Determined")
        } else {
            print("No idea what's going on")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        DispatchQueue.main.async {
            self.getWeatherData()
        }
        
    }
    

}

