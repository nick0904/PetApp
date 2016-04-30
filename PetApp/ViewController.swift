
import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var startBt:UIButton!
    var listVC:ListViewController?
    private var soundPlayer:AVAudioPlayer?

    func refreshWithFrame(frame:CGRect) {
        
        self.view.frame = frame
        self.view.backgroundColor = UIColor.whiteColor()
        
        let size01 = frame.size.width/3
        let size02 = frame.size.width/5
        let size03 = frame.size.width/7
        let size = ["size01":size01,"size02":size02,"size03":size03]
        
        //=====================  startBt  =========================
        startBt = UIButton()
        startBt.translatesAutoresizingMaskIntoConstraints = false
        startBt.setImage(UIImage(named:"foot.png"), forState: .Normal)
        startBt.addTarget(self, action: #selector(ViewController.onstartBtAction(_:)), forControlEvents: .TouchUpInside)
        startBt.showsTouchWhenHighlighted = true
        self.view.addSubview(startBt)
        //startBt 的 寬度
        startBt.addConstraint(NSLayoutConstraint(item: startBt, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: size01))
        //startBt 的 x 位置
        self.view.addConstraint(NSLayoutConstraint(item: startBt, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        //startBt 的 高度及 y 的位置
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[startBt(==size01)]-50-|", options: NSLayoutFormatOptions.AlignAllTrailing, metrics: size, views: ["startBt":startBt]))
        
        
        //audioPlayer
        do {
            
            soundPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: NSBundle.mainBundle().pathForResource("enter", ofType: "wav")!)!)
            
        } catch {
            
            let _error = error as NSError
            print("\(_error.localizedDescription)")
        }
        
        
    }
    
    func onstartBtAction(sender:UIButton) -> Void {
        
        self.soundPlayer?.play()
        
        self.startBt.userInteractionEnabled = false
        self.startBt.layer.shadowColor = UIColor.cyanColor().CGColor
        self.startBt.layer.shadowOffset = CGSizeMake(2.0, 6.0)
        self.startBt.layer.shadowOpacity = 0.85
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/5))
        label.center = CGPoint(x: 0 - self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        label.text = "請以認養代替購買"
        label.layer.shadowColor = UIColor.purpleColor().CGColor
        label.layer.shadowOffset = CGSizeMake(1.0, 5.0)
        label.layer.shadowOpacity = 0.8
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont.boldSystemFontOfSize(label.frame.size.height/3)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .Center
        self.view.addSubview(label)
        
        UIView.animateWithDuration(1.58, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
             label.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
            
            }, completion: nil)
        
        self.performSelector(#selector(ViewController.pushListViewController), withObject: nil, afterDelay: 2.0)

    }
    
    func pushListViewController() {
        
        if listVC == nil {
            
            listVC = ListViewController()
            listVC?.refreshWithFrame(self.view.frame)
        }
        
        let nav = UINavigationController(rootViewController: listVC!)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    
}//end class

