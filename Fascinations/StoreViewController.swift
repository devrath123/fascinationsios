//
//  MainViewController.swift
//  Fascinations
//
//  Created by Devrath Rathee on 24/01/2017 A.
//  Copyright © 2019 Fascinations. All rights reserved.
//

import UIKit
import WebKit


class StoreViewControllder : UIViewController{
//,MKMapViewDelegate

    @IBOutlet weak var storesWebView: WKWebView!
   // @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.mapView.delegate = self
       // mapView.mapType = .standard
       // mapView.isZoomEnabled = true
       // mapView.isScrollEnabled = true

      //  plotStoresOnMap()
       getUrlList()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    
    func getUrlList() -> Void {
        let url = NSURL(string: "http://www.storiesforgames.com/fascinations/api/url")!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let bearer = "Bearer " + UserDefaults.standard.string(forKey: Constants.Login.TOKEN)!
        request.addValue(bearer, forHTTPHeaderField:"Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data,response,error in
            if error != nil{
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                let firstKey =  json?.allKeys[0] as! String
                if firstKey == "error"{
                    self.showAlert(message: "Server Error")
                    return
                }
                
                if let parseJSON = json {
                    
                    let urlList:Array<Dictionary<String,Any>> = parseJSON["urls"] as! Array<Dictionary<String,Any>>;
                    
                    DispatchQueue.main.async {
                        
                        for i in 0..<urlList.count {
                            
                            let urlObject = urlList[i] as [String : AnyObject]
                            let urlName = urlObject["name"] as! String
                            if urlName == "store locator"{
                                let url = URL(string:urlObject["url"] as! String)
                                self.storesWebView.load(URLRequest(url:url!))
                            }
                        }
                        
                    }
                }
                
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
    }
    
    func showAlert(message : String) -> Void {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        OperationQueue.main.addOperation{
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    
//    func plotStoresOnMap() {
//
//        let scottsDale=Location(title: "Fascinations - Scottsdale Road - Scottsdale, AZ", coordinate: CLLocationCoordinate2D(latitude: 33.4732716, longitude:88.556531))
//        let elliotRoad = Location(title: "Fascinations - Elliot Road - Tempe, AZ", coordinate: CLLocationCoordinate2D(latitude: 33.349781, longitude: -111.950801))
//        let mcDowellRoad = Location(title: "Fascinations - W McDowell Road - Tolleson, AZ", coordinate: CLLocationCoordinate2D(latitude: 33.4646166, longitude: -112.2402109))
//        let greenWayRoad = Location(title: "Fascinations - W Greenway Road - Glendale, AZ", coordinate: CLLocationCoordinate2D(latitude: 33.6266868, longitude: -112.1862878))
//        let ninetenAvenue = Location(title: "Fascinations - 19th Avenue - Phoenix, AZ", coordinate: CLLocationCoordinate2D(latitude: 33.5798362, longitude:-112.0999716))
//        let cactusRoad = Location(title: "Fascinations - E. Cactus Road - Phoenix, AZ", coordinate: CLLocationCoordinate2D(latitude: 33.6000446, longitude:-111.9895489))
//        let sheaRoad = Location(title: "Fascinations - Scottsdale & Shea - Scottsdale, AZ", coordinate: CLLocationCoordinate2D(latitude: 33.5839009, longitude:-111.9264871))
//        let bellRoad = Location(title: "Fascinations - 32nd Street & Bell Road - Phoenix, AZ", coordinate: CLLocationCoordinate2D(latitude: 33.6363232, longitude:-112.0140966))
//        let speedWay = Location(title: "Fascinations - Speedway & Alvernon - Tucson, AZ", coordinate: CLLocationCoordinate2D(latitude: 32.2357498, longitude:-110.9143712))
//        let acedemy = Location(title: "Fascinations - Academy & Dublin - Colorado Springs, CO", coordinate: CLLocationCoordinate2D(latitude: 38.9265888, longitude:-104.7943977))
//        let havana = Location(title: "Fascinations - Havana & Yale - Denver, CO", coordinate: CLLocationCoordinate2D(latitude: 39.6679794, longitude:-104.8646503))
//        let virginia = Location(title: "Fascinations - Virginia Ave & Colorado Blvd - Glendale, CO", coordinate: CLLocationCoordinate2D(latitude: 39.7079807, longitude:-104.9393437))
//        let colfax = Location(title: "Fascinations - Colfax & Kipling - Lakewood, CO", coordinate: CLLocationCoordinate2D(latitude: 39.7397421, longitude:-105.1156612))
//        let ave = Location(title: "Fascinations - 64th Ave & Sheridan", coordinate: CLLocationCoordinate2D(latitude: 39.8138873, longitude:-105.0518985))
//        let mayBe = Location(title: "May-Bee's by Fascinations - 28th Street & Glenwood - Boulder, CO", coordinate: CLLocationCoordinate2D(latitude: 40.0317001, longitude:-105.2592104))
//
//        let location = CLLocationCoordinate2D(latitude: 33.5798362, longitude: -112.0999716)
//        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 4.0, longitudeDelta: 4.0))
//        mapView.setRegion(region, animated: true)
//
//        mapView.addAnnotation(scottsDale)
//        mapView.addAnnotation(elliotRoad)
//        mapView.addAnnotation(mcDowellRoad)
//        mapView.addAnnotation(greenWayRoad)
//        mapView.addAnnotation(ninetenAvenue)
//        mapView.addAnnotation(cactusRoad)
//        mapView.addAnnotation(sheaRoad)
//        mapView.addAnnotation(bellRoad)
//        mapView.addAnnotation(speedWay)
//        mapView.addAnnotation(acedemy)
//        mapView.addAnnotation(havana)
//        mapView.addAnnotation(virginia)
//        mapView.addAnnotation(colfax)
//        mapView.addAnnotation(ave)
//        mapView.addAnnotation(mayBe)
//
//        mapView.addAnnotations([scottsDale, elliotRoad, mcDowellRoad, greenWayRoad, ninetenAvenue,cactusRoad,sheaRoad,bellRoad,
//            speedWay, acedemy,havana, virginia, colfax,ave,mayBe])
//
//    }
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
//        annotationView.image = UIImage(named:"icon")
//        annotationView.canShowCallout = true
//        return annotationView
//    }
//
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
