//
//  MovieListViewController.swift
//  MovieFinder
//
//  Created by Jeyavijay on 19/04/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource
{
    @IBOutlet var collectionViewMovieList: UICollectionView!
    var arrayMovieList = NSMutableArray()
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    var stringSearchContent = String()

    @IBOutlet var labelSearchContent: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelSearchContent.text = stringSearchContent
        self.collectionViewMovieList.register(UINib(nibName: "MovieListCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ListCell")
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.itemSize = CGSize(width: CGFloat(collectionViewMovieList.frame.size.width / 2.02), height: CGFloat(collectionViewMovieList.frame.size.width / 1.75))
        collectionViewMovieList.collectionViewLayout = layout
        collectionViewMovieList.reloadData()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - CollectionView Delegate -
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrayMovieList.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath as IndexPath) as! MovieListCollectionViewCell
        if let stringImageUrl:String = (arrayMovieList.object(at: indexPath.row) as AnyObject).value(forKey: "Poster") as? String
        {
            
            if stringImageUrl != "N/A"
            {
                let imageUrl = NSURL(string: stringImageUrl)
                getDataFromUrl(url: imageUrl! as URL) { (data, response, error)  in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() { () -> Void in
                        cell.imageViewPosterImage.image = UIImage(data: data)
                    }
                }
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionViewMovieList.deselectItem(at: indexPath, animated: false)
        let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"SingleMovieViewController") as! SingleMovieViewController
        let dictionaryDetails:NSDictionary = arrayMovieList[indexPath.row] as! NSDictionary
        nextViewController.distionayDetails = dictionaryDetails
        
        self.navigationController?.pushViewController(nextViewController, animated: true)

    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void)
    {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
        
    }
    

    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }


}
