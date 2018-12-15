import UIKit

class DrawLine: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw( _ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(3.0)
        context!.setStrokeColor(UIColor.purple.cgColor)
        
        //make and invisible path first then we fill it in
        context!.move(to: CGPoint(x: 50, y: 60))
        context!.addLine(to: CGPoint(x: 250, y:320))
        context!.strokePath()
    }
}
