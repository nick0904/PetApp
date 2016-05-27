
import UIKit

class MyTableViewCell: UITableViewCell {
    
    var cell_imgView:UIImageView?
    var name_label:UILabel?
    var acceptNum_label:UILabel?
    
    func refreshWithFrame(frame:CGRect) {
        
        self.frame = frame
        self.backgroundColor = UIColor.clearColor()
        let metric = ["space":10,"width":frame.size.width/2.5]
        
        //=================  cell_imgView  =================
        cell_imgView = UIImageView()
        cell_imgView?.translatesAutoresizingMaskIntoConstraints = false
        cell_imgView?.contentMode = .ScaleAspectFill
        cell_imgView?.clipsToBounds = true
        self.addSubview(cell_imgView!)
        
        //cell_imgView size
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-space-[cell_imgView(==width)]", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: metric, views: ["cell_imgView" : cell_imgView!]))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-space-[cell_imgView]-space-|", options: NSLayoutFormatOptions.AlignAllTrailing, metrics: metric, views: ["cell_imgView" : cell_imgView!]))
        
        //=================  name_label  =================
        let labeW = frame.size.width - frame.size.width/2.5 - 10
        name_label = UILabel(frame: CGRect(x:frame.size.width/2.5 + 10, y: frame.size.height/2 - frame.size.height/8, width: labeW, height: frame.size.height/4))
        name_label?.font = UIFont.boldSystemFontOfSize(name_label!.frame.size.height/2)
        name_label?.adjustsFontSizeToFitWidth = true
        name_label?.textColor = UIColor.blackColor()
        name_label?.textAlignment = .Center
        self.addSubview(name_label!)
        
        //=================  acceptNum_label  =================
        acceptNum_label = UILabel(frame: CGRect(x: frame.size.width/2.5 + 10, y: frame.size.height/2 - frame.size.height/8 + name_label!.frame.size.height, width: labeW, height: frame.size.height/5))
        acceptNum_label?.textColor = UIColor.darkGrayColor()
        acceptNum_label?.textAlignment = .Center
        self.addSubview(acceptNum_label!)
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
