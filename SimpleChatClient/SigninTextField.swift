//
//  SigninTextField.swift
//  FSC
//
//  Created by Ryan on 2015/4/27.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit

@IBDesignable
class SigninTextField: UITextField {
  
  @IBInspectable var masksToBounds: Bool    = false                {didSet{updateLayerProperties()}}
  @IBInspectable var cornerRadius : CGFloat = 0                    {didSet{updateLayerProperties()}}
  @IBInspectable var borderWidth  : CGFloat = 0                    {didSet{updateLayerProperties()}}
  @IBInspectable var borderColor  : UIColor = UIColor.clearColor() {didSet{updateLayerProperties()}}
  @IBInspectable var shadowColor  : UIColor = UIColor.clearColor() {didSet{updateLayerProperties()}}
  @IBInspectable var shadowOpacity: CGFloat = 0                    {didSet{updateLayerProperties()}}
  @IBInspectable var shadowRadius : CGFloat = 0                    {didSet{updateLayerProperties()}}
  @IBInspectable var shadowOffset : CGSize  = CGSizeMake(0, 0)     {didSet{updateLayerProperties()}}
  
  
  
  override func awakeFromNib() {
    
//    var bottomBorder = CALayer()
//    bottomBorder.frame = CGRectMake(0.0, self.frame.size.height - 1, self.frame.size.width, 1.0);
//    bottomBorder.backgroundColor = UIColor.blackColor().CGColor
//    self.layer.addSublayer(bottomBorder)
  }
  
  private func updateLayerProperties() {
    self.layer.masksToBounds = masksToBounds
    self.layer.cornerRadius = cornerRadius
    self.layer.borderWidth = borderWidth
    self.layer.borderColor = borderColor.CGColor
    self.layer.shadowColor = shadowColor.CGColor
    self.layer.shadowOpacity = CFloat(shadowOpacity)
    self.layer.shadowRadius = shadowRadius
    self.layer.shadowOffset = shadowOffset
    
  }
  
}

