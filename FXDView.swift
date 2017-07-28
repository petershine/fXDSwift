

import UIKit
import Foundation


extension UIView {
	//REFERENCE: https://spin.atomicobject.com/2017/07/18/swift-interface-builder/

	@IBInspectable
	var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
		}
	}

	@IBInspectable
	var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}

	@IBInspectable
	var borderColor: UIColor? {
		get {
			if let color = layer.borderColor {
				return UIColor(cgColor: color)
			}
			return nil
		}
		set {
			if let color = newValue {
				layer.borderColor = color.cgColor
			} else {
				layer.borderColor = nil
			}
		}
	}

	@IBInspectable
	var shadowRadius: CGFloat {
		get {
			return layer.shadowRadius
		}
		set {
			layer.shadowRadius = newValue
		}
	}

	@IBInspectable
	var shadowOpacity: Float {
		get {
			return layer.shadowOpacity
		}
		set {
			layer.shadowOpacity = newValue
		}
	}

	@IBInspectable
	var shadowOffset: CGSize {
		get {
			return layer.shadowOffset
		}
		set {
			layer.shadowOffset = newValue
		}
	}

	@IBInspectable
	var shadowColor: UIColor? {
		get {
			if let color = layer.shadowColor {
				return UIColor(cgColor: color)
			}
			return nil
		}
		set {
			if let color = newValue {
				layer.shadowColor = color.cgColor
			} else {
				layer.shadowColor = nil
			}
		}
	}
}

@objc extension UIView {

	class func view(fromNibName nibName: String, owner: Any? = nil) -> Any? {
		FXDLog_Func()

		//MARK: Customized initialization
		//FIXME: Should update this method to use Self class, for subclasses.
		//https://github.com/apple/swift-evolution/blob/master/proposals/0068-universal-self.md

		FXDLog("nibName: \(String(describing: nibName))")

		let nib: UINib? = UINib.init(nibName:nibName, bundle: nil)
		FXDLog("nib: \(String(describing: nib))")

		let viewArray = nib?.instantiate(withOwner: owner, options: nil)
		FXDLog("viewArray: \(String(describing: viewArray))")

		return viewArray?.first
	}
}


//FIXME: declare this as global variable
let durationAnimation = 0.3

@objc extension UIView {
	func fadeInFromHidden() {
		guard (self.isHidden || self.alpha != 1.0) else {
			return
		}

		self.alpha = 0.0;
		self.isHidden = false;

		UIView.animate(withDuration: durationAnimation) {
			self.alpha = 1.0
		}
	}

	func fadeOutThenHidden() {
		guard (self.isHidden == false) else {
			return
		}

		let previousAlpha = self.alpha

		UIView.animate(withDuration: durationAnimation,
		               animations: {
						self.alpha = 0.0
		}) { (didFinish: Bool) in
			self.isHidden = true
			self.alpha = previousAlpha
		}
	}

	func addAsFadeInSubview(_ subview: UIView?, afterAddedBlock: (() -> Swift.Void)? = nil) {

		guard subview != nil else {
			afterAddedBlock?()
			return
		}

		subview?.alpha = 0.0

		self.addSubview(subview!)
		self.bringSubview(toFront: subview!)

		UIView.animate(
			withDuration: durationAnimation,
			animations: {
				subview?.alpha = 0.0

		}) { (didFinish: Bool) in
			afterAddedBlock?()
		}
	}

	func removeAsFadeOutSubview(_ subview: UIView?, afterRemovedBlock: (() -> Swift.Void)? = nil) {

		guard subview != nil else {
			afterRemovedBlock?()
			return
		}

		UIView.animate(
			withDuration: durationAnimation,
			animations: {
			subview?.alpha = 0.0

		}) { (didFinish: Bool) in
			subview?.removeFromSuperview()
			subview?.alpha = 1.0

			afterRemovedBlock?()
		}
	}

	func modifyToCircular() {
		self.layer.masksToBounds = true
		self.layer.cornerRadius = self.bounds.size.width/2.0
	}

	func removeAllSubviews() {
		for subview in self.subviews {
			subview.removeFromSuperview()
		}
	}
}

extension UIView {

	func addGlowingSubview(view: FXDsubviewGlowing?) {

		var glowingSubview: FXDsubviewGlowing? = view

		if glowingSubview == nil {
			var subviewFrame = self.frame
			subviewFrame.origin = .zero

			glowingSubview = FXDsubviewGlowing.init(frame: subviewFrame, withGlowing: nil)
		}

		glowingSubview?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		glowingSubview?.isUserInteractionEnabled = false

		self.addSubview(glowingSubview!)
	}
}


//MARK: Sub-classes
typealias FXDcallbackHitIntercept = (_ hitView: UIView?, _ point: CGPoint?, _ event: UIEvent?) -> UIView?

class FXDpassthroughView: UIView {
	var hitIntercept: FXDcallbackHitIntercept?

	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

		var hitView: UIView = super.hitTest(point, with: event)!

		if self.hitIntercept != nil {
			hitView = self.hitIntercept!(hitView, point, event)!
		}

		return hitView
	}
}
