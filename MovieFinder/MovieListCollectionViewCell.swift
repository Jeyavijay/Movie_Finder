//
//  MovieListCollectionViewCell.swift
//  MovieFinder
//
//  Created by Jeyavijay on 19/04/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageViewPosterImage: UIImageView!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageViewPosterImage.transform = CGAffineTransform.init(scaleX: 2.0, y: 2.0)
        UIView.animate(withDuration: 0.4){
            self.imageViewPosterImage.transform = CGAffineTransform.identity
        }


    }

}
