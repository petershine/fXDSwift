

import UIKit
import Foundation


//REFERENCE: https://spin.atomicobject.com/2017/07/18/swift-interface-builder/
extension UIView {

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

