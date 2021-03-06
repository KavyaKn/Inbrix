//
//  SMSegment.swift
//
//  Created by Si MA on 03/01/2015.
//  Copyright (c) 2015 Si Ma. All rights reserved.
//

import UIKit

public class SMSegment: SMBasicSegment {
    
    // UI Elements
    override public var frame: CGRect {
        didSet {
            self.resetContentFrame()
        }
    }
    
    public var verticalMargin: CGFloat = 5.0 {
        didSet {
            self.resetContentFrame()
        }
    }
        
    // Segment Colour
    public var onSelectionColour: UIColor = UIColor.darkGrayColor() {
        didSet {
            if self.isSelected == true {
                self.backgroundColor = self.onSelectionColour
            }
        }
    }
    public var offSelectionColour: UIColor = UIColor.whiteColor() {
        didSet {
            if self.isSelected == false {
                self.backgroundColor = self.offSelectionColour
            }
        }
    }
    private var willOnSelectionColour: UIColor! {
        get {
            var hue: CGFloat = 0.0
            var saturation: CGFloat = 0.0
            var brightness: CGFloat = 0.0
            var alpha: CGFloat = 0.0
            self.onSelectionColour.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            return UIColor(hue: hue, saturation: saturation*0.5, brightness: min(brightness*1.5, 1.0), alpha: alpha)
        }
    }
    
    // Segment Title Text & Colour & Font
    public var title: String? {
        didSet {
            self.label.text = self.title
            
            if let titleText = self.label.text as NSString? {
                self.labelWidth = titleText.boundingRectWithSize(CGSize(width: self.frame.size.width, height: self.frame.size.height), options:NSStringDrawingOptions.UsesLineFragmentOrigin , attributes: [NSFontAttributeName: self.label.font], context: nil).size.width
            }
            else {
                self.labelWidth = 0.0
            }
            
            self.resetContentFrame()
        }
    }
    public var onSelectionTextColour: UIColor = UIColor.whiteColor() {
        didSet {
            if self.isSelected == true {
                self.label.textColor = self.onSelectionTextColour
            }
        }
    }
    public var offSelectionTextColour: UIColor = UIColor.darkGrayColor() {
        didSet {
            if self.isSelected == false {
                self.label.textColor = self.offSelectionTextColour
            }
        }
    }
    public var titleFont: UIFont = UIFont.systemFontOfSize(17.0) {
        didSet {
            self.label.font = self.titleFont
            
            if let titleText = self.label.text as NSString? {
                self.labelWidth = titleText.boundingRectWithSize(CGSize(width: self.frame.size.width + 1.0, height: self.frame.size.height), options:NSStringDrawingOptions.UsesLineFragmentOrigin , attributes: [NSFontAttributeName: self.label.font], context: nil).size.width
            }
            else {
                self.labelWidth = 0.0
            }
            
            self.resetContentFrame()
        }
    }
    
    // Segment Image
    public var onSelectionImage: UIImage? {
        didSet {
            if self.onSelectionImage != nil {
                self.resetContentFrame()
            }
            if self.isSelected == true {
                self.imageView.image = self.onSelectionImage
            }
        }
    }
    public var offSelectionImage: UIImage? {
        didSet {
            if self.offSelectionImage != nil {
                self.resetContentFrame()
            }
            if self.isSelected == false {
                self.imageView.image = self.offSelectionImage
            }
        }
    }
    
   
    private var imageView: UIImageView = UIImageView()
    private var label: UILabel = UILabel()
    private var labelWidth: CGFloat = 0.0
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(verticalMargin: CGFloat, onSelectionColour: UIColor, offSelectionColour: UIColor, onSelectionTextColour: UIColor, offSelectionTextColour: UIColor, titleFont: UIFont) {
        
        self.verticalMargin = verticalMargin
        self.onSelectionColour = onSelectionColour
        self.offSelectionColour = offSelectionColour
        self.onSelectionTextColour = onSelectionTextColour
        self.offSelectionTextColour = offSelectionTextColour
        self.titleFont = titleFont
        
        super.init(frame: CGRectZero)
        self.setupUIElements()
    }
    
    
    
    func setupUIElements() {
        
        self.backgroundColor = self.offSelectionColour
        
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(self.imageView)
        
        self.label.textAlignment = NSTextAlignment.Center
        self.label.font = UIFont.segmentLabelFont()
        self.label.textColor = self.offSelectionTextColour
        self.addSubview(self.label)
    }
    
    
    // MARK: Update Frame
    private func resetContentFrame() {
        var imageViewFrame = CGRectMake(self.frame.size.width / 2  , 5.0 , self.frame.size.width / 2 , self.frame.size.height / 2)

        imageView.contentMode = UIViewContentMode.ScaleAspectFill

        if self.onSelectionImage != nil || self.offSelectionImage != nil {
            // Set imageView as a square
            imageViewFrame.size.width = self.frame.size.height - self.verticalMargin * 6
        }     
        self.imageView.frame = imageViewFrame

        self.label.frame = CGRectMake(imageViewFrame.origin.y + imageViewFrame.size.height / 1.5 ,imageViewFrame.size.height , self.labelWidth, self.frame.size.height - imageViewFrame.size.height)

    }
    
    // MARK: Selections
    override public func setSelected(selected: Bool, inView view: SMBasicSegmentView) {
        super.setSelected(selected, inView: view)
        if selected {
            self.backgroundColor = self.onSelectionColour
            self.label.textColor = self.onSelectionTextColour
            self.imageView.image = self.onSelectionImage
        }
        else {
            self.backgroundColor = self.offSelectionColour
            self.label.textColor = self.offSelectionTextColour
            self.imageView.image = self.offSelectionImage
        }
    }
    
    // MARK: Handle touch
    override public  func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if self.isSelected == false {
            self.backgroundColor = self.willOnSelectionColour
        }
    }
    
}