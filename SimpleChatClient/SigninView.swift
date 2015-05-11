//
//  SigninView.swift
//  FSC
//
//  Created by Ryan on 2015/4/27.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit

@IBDesignable
class SigninView: UIView {

  @IBInspectable var masksToBounds: Bool    = false                {didSet{updateLayerProperties()}}
  @IBInspectable var cornerRadius : CGFloat = 0                    {didSet{updateLayerProperties()}}
  @IBInspectable var borderWidth  : CGFloat = 0                    {didSet{updateLayerProperties()}}
  @IBInspectable var borderColor  : UIColor = UIColor.clearColor() {didSet{updateLayerProperties()}}
  @IBInspectable var shadowColor  : UIColor = UIColor.clearColor() {didSet{updateLayerProperties()}}
  @IBInspectable var shadowOpacity: CGFloat = 0                    {didSet{updateLayerProperties()}}
  @IBInspectable var shadowRadius : CGFloat = 0                    {didSet{updateLayerProperties()}}
  @IBInspectable var shadowOffset : CGSize  = CGSizeMake(0, 0)     {didSet{updateLayerProperties()}}
  
  
  
  override func awakeFromNib() {
    //self.layer.borderWidth = 2
    //self.layer.borderColor = (UIColor.blackColor()).CGColor
    //self.layer.cornerRadius = 0.8
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
