//
//  IBResizeImage.swift
//  Inbrix
//
//  Created by Kavya on 28/03/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import Foundation

import UIKit

extension UIImage {
    
    func beginImageContextWithSize(size: CGSize) {
        if UIScreen.mainScreen().respondsToSelector(#selector(NSDecimalNumberBehaviors.scale)) {
            if UIScreen.mainScreen().scale == 2.0 {
                UIGraphicsBeginImageContextWithOptions(size, true, 2.0)
            }
            else {
                UIGraphicsBeginImageContext(size)
            }
        }
        else {
            UIGraphicsBeginImageContext(size)
        }
    }
    
    func endImageContext() {
        UIGraphicsEndImageContext()
    }
    
//    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
//        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
//        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage
//    }
    
    func imageFromView(view: UIView) -> UIImage {
        self.beginImageContextWithSize(view.bounds.size)
        let hidden: Bool = view.hidden
        view.hidden = false
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        self.endImageContext()
        view.hidden = hidden
        return image
    }
    
    func imageFromView(view: UIView, scaledToSize newSize: CGSize) -> UIImage {
        let image: UIImage = self.imageFromView(view)
        if view.bounds.size.width != newSize.width || view.bounds.size.height != newSize.height {
//            image = self.imageWithImage(image, scaledToSize: newSize)
        }
        return image
    }
    
    func makeRoundCornersWithRadius(RADIUS: CGFloat) -> UIImage {
        let imageName = "Screen"
        let image = UIImage(named: imageName)!
        // Begin a new image that will be the new image with the rounded corners
        // (here with the size of an UIImageView)
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let RECT: CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
        // Add a clip before drawing anything, in the shape of an rounded rect
        UIBezierPath(roundedRect: RECT, cornerRadius: RADIUS).addClip()
        // Draw your image
        image.drawInRect(RECT)
        // Get the image, here setting the UIImageView image
        //imageView.image
        let imageNew: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        // Lets forget about that we were drawing
        UIGraphicsEndImageContext()
        return imageNew
    }
    
//    func croppedImage() -> UIImage {
//        let imageName = "Logo"
//        let image = UIImage(named: imageName)!
//        let ret: UIImage = image.fixOrientation()
//        // This calculates the crop area.
//        let originalWidth: CGFloat = ret.size.width
//        let originalHeight: CGFloat = ret.size.height
//        let edge: CGFloat = fminf(originalWidth, originalHeight)
//        let posX: CGFloat = (originalWidth - edge) / 2.0
//        let posY: CGFloat = (originalHeight - edge) / 2.0
//        let cropSquare: CGRect = CGRectMake(posX, posY, edge, edge)
        // This performs the image cropping.
//        let imageRef: CGImageRef = CGImageCreateWithImageInRect(ret.CGImage, cropSquare)!
//        ret = UIImage.imageWithCGImage(imageRef, scale: ret.scale, orientation: ret.imageOrientation)
//        CGImageRelease(imageRef)
//        return ret
//    }
    
}
