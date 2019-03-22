//
//  ExhibitorImageCollectionViewCell.swift
//  CodeChallenge
//

import Foundation
import UIKit

import LazyImage

class ExhibitorImageCollectionViewCell : UICollectionViewCell
{
    @IBOutlet weak var imageView: LazyImageView!

    /**
     Set the image to one downloaded from a website.

     - Parameter urlString: String form of url.
     */
    @objc
    public func downloadImageFromURL(urlString: String) -> Void
    {
        imageView.imageURL = urlString
    }
}
