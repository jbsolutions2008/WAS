import UIKit

@IBDesignable class DiagonalLine: UIView {
    
    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var flip: Bool = false
    @IBInspectable var color: UIColor = UIColor.black
    
    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        aPath.lineWidth = self.lineWidth
        if self.flip {
            aPath.move(to: CGPoint(x: 0, y: 0))
            aPath.addLine(to: CGPoint(x: rect.width, y: rect.height))
        } else {
            aPath.move(to: CGPoint(x: 0, y: rect.height))
            aPath.addLine(to: CGPoint(x: rect.width, y: 0))
        }
        aPath.close()
        self.color.set()
        aPath.stroke()
    }
    
}
