//
//  JDropDownAlert.swift



import UIKit

public enum AlertPosition {
    case top
    case bottom
}

public enum AnimationDirection {
    case toLeft
    case toRight
    case normal
}

public class JDropDownAlert: UIButton {
    
    // default values
    // You can change this values to customize
//    public var height: CGFloat = 70
//    public var duration = 0.3
//    public var delay: Double = 2.0
    public var height: CGFloat = 100
    public var duration = 0.3
    public var delay: Double = 6.0
    
    private var titleFrame: CGRect!
    private var topLabel = UILabel()
    private var messageLabel = UILabel()
    
    public var position = AlertPosition.top
    public var direction = AnimationDirection.normal
    
    private let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    
    public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 16) {
        didSet{
            topLabel.font = titleFont
        }
    }
    
    public var messageFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet{
            messageLabel.font = messageFont
        }
    }
    
    public var didTapBlock: (() -> ())?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(position: AlertPosition = .top, direction: AnimationDirection = .normal) {
        super.init(frame: CGRect.zero)
        
        self.frame = getFrameBy(position, direction: direction)
        self.direction = direction
        self.position = position
        setDefaults()
    }
    
    private func setDefaults() {
        setTitleDefaults()
        setMessageDefaults()
        self.backgroundColor = UIColor.lightRed
        self.addTarget(self, action: #selector(viewDidTap), for: .touchUpInside)
    }
    
    private func setTitleDefaults() {
        
        titleFrame = CGRect(x: 10,
                            y: position == .top ? statusBarHeight : 15,
                            width: frame.size.width - 10,
                            height: 25)
        
        topLabel = UILabel(frame: titleFrame)
        topLabel.textAlignment = .center
        topLabel.numberOfLines = 10
        topLabel.textColor = UIColor.white
        topLabel.font = self.titleFont
        addSubview(topLabel)
    }
    
    private func setMessageDefaults() {
        let messageFrame:CGRect
        
        if self.position == .top {
            messageFrame = CGRect(x: 10, y: statusBarHeight + titleFrame.height + 5, width: frame.size.width - 10, height: 20)
        }else {
            messageFrame = CGRect(x: 10, y: titleFrame.size.height + titleFrame.height, width: frame.size.width - 10, height: 20)
        }
        messageLabel = UILabel(frame: messageFrame)
        messageLabel.textAlignment = .center
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.numberOfLines = 10
        messageLabel.textColor = UIColor.white
        messageLabel.font = self.messageFont
        addSubview(messageLabel)
    }
    
    
    
    private func getFrameBy(_ position: AlertPosition, direction: AnimationDirection) -> CGRect {
        let frame: CGRect
        
        switch position {
        case .top:
            frame = getFrameOfTopPositionBy(direction)
        case .bottom:
            frame = getFrameOfBottomPositionBy(direction)
        }
        
        return frame
    }
    
    private func getFrameOfTopPositionBy(_ direction: AnimationDirection) -> CGRect {
        let frame: CGRect
        switch direction {
        case .toRight:
            frame = CGRect(x: -screenWidth, y: 0.0, width: screenWidth, height: height)
        case .toLeft:
            frame = CGRect(x: screenWidth, y: 0.0, width: screenWidth, height: height)
        case .normal:
            frame = CGRect(x: 0.0, y: -height, width: screenWidth, height: height)
        }
        return frame
    }
    
    private func getFrameOfBottomPositionBy(_ direction: AnimationDirection) -> CGRect {
        let frame: CGRect
        switch direction {
        case .toRight:
            frame = CGRect(x: -screenWidth, y: screenHeight - height, width: screenWidth, height: height)
        case .toLeft:
            frame = CGRect(x: screenWidth, y: screenHeight - height, width: screenWidth, height: height)
        case .normal:
            frame = CGRect(x: 0.0, y: screenHeight + height, width: screenWidth, height: height)
        }
        return frame
    }
    
    
    
    @objc func viewDidTap() {
        if let didTapBlock = didTapBlock {
            didTapBlock()
            hide(self)
        }
    }
    
    
    
    // MARK: - Hub methods
    @objc private func show(_ title: String, message: String?, topLabelColor: UIColor, messageLabelColor: UIColor, backgroundColor: UIColor?) {
        
        addWindowSubview(self)
        configureProperties(title, message: message, topLabelColor: topLabelColor, messageLabelColor: messageLabelColor, backgroundColor: backgroundColor)
        
        UIView.animate(withDuration: self.duration, animations: {
            
            switch self.direction {
            case .toRight:
                self.frame.origin.x = 0
            case .toLeft:
                self.frame.origin.x = 0
            case .normal:
                self.frame.origin.y = self.position == .top ? 0 : self.screenHeight-self.height
            }
        })
        perform(#selector(hide), with: self, afterDelay: self.delay)
    }
    
    @objc private func hide(_ alertView: UIButton) {
        
        UIView.animate(withDuration: duration, animations: {
            
            switch self.direction {
            case .toRight:
                self.frame.origin.x = -self.screenWidth
            case .toLeft:
                self.frame.origin.x = self.screenWidth
            case .normal:
                (self.position == .top) ? (alertView.frame.origin.y = -self.height) : (alertView.frame.origin.y = self.screenHeight)
            }
        })
        
        perform(#selector(remove), with: alertView, afterDelay: delay)
    }
    
    
    
    @objc private func addWindowSubview(_ view: UIView) {
        if self.superview == nil {
            let frontToBackWindows = UIApplication.shared.windows.reversed()
            for window in frontToBackWindows {
                if window.windowLevel == UIWindowLevelNormal
                    && !window.isHidden
                    && window.frame != CGRect.zero {
                    window.addSubview(view)
                    return
                }
            }
        }
    }
    
    @objc private func remove(_ alertView: UIButton) {
        alertView.removeFromSuperview()
    }
    
    
    
    @objc private func configureProperties(_ title: String, message: String?, topLabelColor: UIColor?, messageLabelColor: UIColor?, backgroundColor: UIColor?) {
        topLabel.text = title
        
        if let message = message {
            messageLabel.text = message
        }else {
            messageLabel.isHidden = true
            topLabel.frame.origin.y = height/2
            
            if self.position == .bottom {
                topLabel.frame.origin.y = height/2 - topLabel.frame.height/2
            }
        }
        
        if let topLabelColor = topLabelColor {
            topLabel.textColor = topLabelColor
        }
        
        if let messageLabelColor = messageLabelColor {
            messageLabel.textColor = messageLabelColor
        }
        
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
    }
    
    // MARK: Interface
    public func alertWith(_ title: String,
                        message: String? = nil,
                        topLabelColor: UIColor = UIColor.white,
                        messageLabelColor: UIColor = UIColor.white,
                        backgroundColor: UIColor = UIColor.lightRed) {
        self.delay = 2.0
        show(title, message: message, topLabelColor: topLabelColor, messageLabelColor: messageLabelColor, backgroundColor: backgroundColor)
    }
    
    public func alertWith(_ title: String,
                        message: String? = nil,
                        topLabelColor: UIColor = UIColor.white,
                        messageLabelColor: UIColor = UIColor.white,
                        backgroundColor: UIColor = UIColor.lightRed,
                        delay: Double) {
        self.delay = delay
        show(title, message: message, topLabelColor: topLabelColor, messageLabelColor: messageLabelColor, backgroundColor: backgroundColor)
    }
}

extension UIColor {
    public static var lightRed: UIColor {
        return UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 0.9)
    }
}
