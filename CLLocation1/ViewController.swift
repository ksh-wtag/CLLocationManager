import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self

    }
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async{
            if CLLocationManager.locationServicesEnabled() {
                print("Location working")
                self.locationManager.startUpdatingLocation()
            }
            else {
                print("not working")
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        DispatchQueue.main.async {
            self.latitudeLabel.text = "\(latitude)"
            self.longitudeLabel.text = "\(longitude)"
            print(latitude)
        }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if error != nil {
                print("Error")
            }
            
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
                let locality = placemark.locality ?? ""
                let administrativeArea = placemark.administrativeArea ?? ""
                let country = placemark.country ?? ""
                
                self.addressLabel.text = "Address: \(locality), \(administrativeArea), \(country)"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
