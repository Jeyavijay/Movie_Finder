//
//  ViewController.swift
//  MovieFinder
//
//  Created by Jeyavijay on 19/04/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit
import AFNetworking


class ViewController: UIViewController,UITextFieldDelegate
{
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var labelBottomTitle: UILabel!
    @IBOutlet var textFieldSearchBar: UITextField!
    @IBOutlet var viewTextField: UIView!
    @IBOutlet var labelOMDB: UILabel!
    var arrayMovieList = NSMutableArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        UIProperties()

    }
    
    func UIProperties()
    {
        self.view.backgroundColor = UIColor(hexString: "#f5ab35ff")
        labelOMDB.backgroundColor = UIColor(hexString: "#00000011")
        labelOMDB.frame = CGRect(x: labelOMDB.frame.origin.x, y: labelOMDB.frame.origin.y, width: labelOMDB.frame.size.width, height: labelOMDB.frame.size.width)
        labelOMDB.layer.cornerRadius = labelOMDB.layer.frame.width/2
        labelOMDB.layer.masksToBounds = true
        labelOMDB.layer.borderWidth = 1
        labelOMDB.layer.borderColor = UIColor.white.cgColor
        viewTextField.layer.borderColor = UIColor.white.cgColor
        labelBottomTitle.text = "THE LARGEST\n ONLINE MOVIE DATABASE"
        activityIndicator.isHidden = true
        activityIndicator.center = self.view.center
        addToolBar()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // Mark :- Textfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldSearchBar{
            dismissKeyboard()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && (string == " ") {
            return false
        }
        return true
    }
    
    func addToolBar()
    {
        let toolBar = UIToolbar(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(44)))
        toolBar.tintColor = UIColor.gray
        let doneBtn = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [space, doneBtn]
        textFieldSearchBar.inputAccessoryView = toolBar
        
    }
    func dismissKeyboard()
    {
        textFieldSearchBar.resignFirstResponder()
        passApiParameter()
    }
    
    func passApiParameter()
    {
        if (textFieldSearchBar.text?.characters.count)! <= 1
        {
            showAlert(sMessage: "Search Title Should Not be Empty")
            textFieldSearchBar.becomeFirstResponder()
        }
        else
        {
            let parameter = NSMutableDictionary()
            parameter.setObject(textFieldSearchBar.text as Any, forKey: "s" as NSCopying)
            parameter.setObject("short", forKey: "plot" as NSCopying)
            parameter.setObject("json", forKey: "r" as NSCopying)
            activityIndicator.isHidden = false
            CallApi(parameter: parameter, url: "http://www.omdbapi.com/?")
            
        }
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
                    self.arrayMovieList.removeAllObjects()
                    let arrayResponse:NSArray = (responseDictionary.value(forKey: "Search") as? NSArray)!

                    self.arrayMovieList.addObjects(from: arrayResponse as! [Any])
                    let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"MovieListViewController") as! MovieListViewController
                    nextViewController.arrayMovieList = self.arrayMovieList
                    nextViewController.stringSearchContent = self.textFieldSearchBar.text!
                    self.textFieldSearchBar.text = ""

                

                    self.navigationController?.pushViewController(nextViewController, animated: true)

                }
                else
                {
                    let ErrorResponse:String = responseDictionary.value(forKey: "Error") as! String
                    self.showAlert(sMessage: ErrorResponse)
                    self.textFieldSearchBar.text = ""

                }
            }
            self.activityIndicator.isHidden = true
        }, failure: {
            (operation, error) in
            print(error)
            self.textFieldSearchBar.text = ""

            self.activityIndicator.isHidden = true
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
}

