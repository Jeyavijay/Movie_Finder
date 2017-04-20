//
//  SingleMovieViewController.swift
//  MovieFinder
//
//  Created by Jeyavijay on 19/04/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit
import AFNetworking

class SingleMovieViewController: UIViewController {

    @IBOutlet var labelDescription: UILabel!
    @IBOutlet var labelReleaseYear: UILabel!
    @IBOutlet var labelMovieTitle: UILabel!
    @IBOutlet var imageViewPoster: UIImageView!
    var distionayDetails = NSDictionary()
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let stringTitle:String = distionayDetails.value(forKey: "Title") as? String
        {
            activityIndicator.isHidden = false
            activityIndicator.center = self.view.center
            let parameter = NSMutableDictionary()
            parameter.setObject(stringTitle as String, forKey: "t" as NSCopying)
            parameter.setObject("short", forKey: "plot" as NSCopying)
            parameter.setObject("json", forKey: "r" as NSCopying)
            CallApi(parameter: parameter, url: "http://www.omdbapi.com/?")

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void)
    {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
        
    }
    
    func CallApi(parameter : NSMutableDictionary,url : String)
    {
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: parameter, progress: nil, success: {
            (operation, responseObject) in
            let responseDictionary:NSDictionary = responseObject as! NSDictionary
            if let stringResponse:String = responseDictionary.value(forKey: "Response") as? String
            {
                if stringResponse == "True"
                {
                    
                    self.labelMovieTitle.text = responseDictionary.value(forKey: "Title") as? String
                    self.labelReleaseYear.text = String(format: "Released Year :%@", (responseDictionary.value(forKey: "Released") as? String)!)
                    self.labelDescription.text = responseDictionary.value(forKey: "Plot") as? String
                    self.labelDescription.sizeToFit()
                    if let stringImageUrl:String = responseDictionary.value(forKey: "Poster") as? String
                    {
                        
                        if stringImageUrl != "N/A"
                        {
                            let imageUrl = NSURL(string: stringImageUrl)
                            self.getDataFromUrl(url: imageUrl! as URL) { (data, response, error)  in
                                guard let data = data, error == nil else { return }
                                DispatchQueue.main.async() { () -> Void in
                                    self.imageViewPoster.image = UIImage(data: data)
                                    self.activityIndicator.isHidden = true

                                }
                            }
                        }
                    }

                    

                }
                else
                {
                    let ErrorResponse:String = responseDictionary.value(forKey: "Error") as! String
                    self.showAlert(sMessage: ErrorResponse)
                    
                }
            }
        }, failure: {
            (operation, error) in
            print(error)
        })
    }
    
    
    func showAlert(sMessage:String){
        let alertController = UIAlertController(title: "Alert!", message: sMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    


}
