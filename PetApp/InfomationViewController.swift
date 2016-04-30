

import UIKit

class InfomationViewController: UIViewController,UITableViewDataSource {
    
    var detail_imgView:UIImageView?
    var detail_tableView:UITableView?
    var note_textView:UITextView?
    var ary_data = [(name:String,num:String,age:String,sex:String,hairType:String,bodyweight:String,isSterilization:String,note:String)]()
    

    func refreshWithFrame(frame:CGRect,navH:CGFloat) {
        
        self.view.frame = frame
        self.view.backgroundColor = UIColor.blackColor()
        self.title = "寶貝資料"
        
        let currentViewHeight = frame.size.height - navH
        
        //================  backGroundView  ===================
        let backGroundView = UIView(frame: CGRect(x: 0, y: navH, width: frame.size.width, height: currentViewHeight/2))
        backGroundView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(backGroundView)
        
        //================  backGroundView  ===================
        detail_imgView = UIImageView()
        detail_imgView?.translatesAutoresizingMaskIntoConstraints = false
        detail_imgView?.contentMode = .ScaleAspectFill
        detail_imgView?.clipsToBounds = true
        self.view.addSubview(detail_imgView!)
        
        let metric = ["spacec":10,"navH":navH+40,"imgViewH":backGroundView.frame.size.height - 40]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-spacec-[detail_imgView]-spacec-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: metric, views: ["detail_imgView":detail_imgView!]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-navH-[detail_imgView(==imgViewH)]", options: NSLayoutFormatOptions.AlignAllTrailing, metrics: metric, views: ["detail_imgView":detail_imgView!]))
        
        //================  detail_tableView  ===================
        detail_tableView = UITableView(frame: CGRect(x: 0, y: navH + backGroundView.frame.size.height, width: frame.size.width, height: currentViewHeight/2/3*2))
        detail_tableView?.dataSource = self
        detail_tableView?.backgroundColor = UIColor.blackColor()
        detail_tableView?.separatorColor = UIColor.redColor()
        self.view.addSubview(detail_tableView!)
        
        //================  note_label  ===================
        let noteH = currentViewHeight/2/3/3
        let note_label = UILabel(frame: CGRect(x: 0, y:  navH + backGroundView.frame.size.height + detail_tableView!.frame.size.height + 10, width: self.view.frame.size.width/4, height: noteH))
        note_label.text = " 備註:"
        note_label.textAlignment = .Center
        note_label.textColor = UIColor.whiteColor()
        note_label.font = UIFont.systemFontOfSize(note_label.frame.size.width/4.5)
        note_label.adjustsFontSizeToFitWidth = true
        self.view.addSubview(note_label)
        
        //================  note_textView  ===================
        note_textView = UITextView(frame: CGRect(x: note_label.frame.size.width - 14, y: navH + backGroundView.frame.size.height + detail_tableView!.frame.size.height + 10, width: self.view.frame.size.width - note_label.frame.size.width, height: noteH*3))
        note_textView?.textColor = UIColor.whiteColor()
        note_textView?.backgroundColor = UIColor.blackColor()
        note_textView?.editable = false
        note_textView?.textAlignment = .Left
        note_textView?.font = UIFont.systemFontOfSize(note_textView!.frame.size.height/5)
        note_textView?.clipsToBounds = true
        self.view.addSubview(note_textView!)
        
    }
    
//MARK: - UITableView DataSource
//-------------------------------------
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell_id = "cell_id"
        var cell = tableView.dequeueReusableCellWithIdentifier(cell_id) as UITableViewCell!
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: cell_id)
            cell.backgroundColor = UIColor.blackColor()
            cell.selectionStyle = .None
        }
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.textColor = UIColor.whiteColor()
            let name = "  名字:  "
            cell.textLabel?.text = ary_data[0].name == "" ? "\(name)"+"暫無資料" : "\(name)"+"\(ary_data[0].name)"
        case 1:
            cell.textLabel?.textColor = UIColor.lightGrayColor()
            let num = "  編號:  "
            cell.textLabel?.text = ary_data[0].num == "" ? "\(num)"+"暫無編號" : "\(num)"+"\(ary_data[0].num)"
        case 2:
            cell.textLabel?.textColor = UIColor.whiteColor()
            let age = "  年齡:  "
            cell.textLabel?.text = ary_data[0].age == "" ? "\(age)"+"暫無資料" : "\(age)"+"\(ary_data[0].age)"
        case 3:
            cell.textLabel?.textColor = UIColor.lightGrayColor()
            let sex = "  性別:  "
            cell.textLabel?.text = ary_data[0].age == "" ? "\(sex)"+"暫無資料" : "\(sex)"+"\(ary_data[0].sex)"
        case 4:
            cell.textLabel?.textColor = UIColor.whiteColor()
            let hairType = "  毛色:  "
            cell.textLabel?.text = ary_data[0].hairType == "" ? "\(hairType)"+"暫無資料" : "\(hairType)"+"\(ary_data[0].hairType)"
        case 5:
            cell.textLabel?.textColor = UIColor.lightGrayColor()
            let bodyweight = "  體重:  "
            cell.textLabel?.text = ary_data[0].bodyweight == "" ? "\(bodyweight)"+"暫無資料" : "\(bodyweight)"+"\(ary_data[0].bodyweight)"
        case 6:
            cell.textLabel?.textColor = UIColor.whiteColor()
            let isSterilization = "  絕育:  "
            cell.textLabel?.text = ary_data[0].isSterilization == "" ? "\(isSterilization)"+"暫無資料" : "\(isSterilization)"+"\(ary_data[0].isSterilization)"
        default:
            break
        }
        
        return cell
    }
    
    
//MARK: - gradientBackground 背景漸層顏色
//-------------------------------------
    func gradientBackground(_view:UIView,_frame:CGRect) {
        
        let color1 = UIColor(red: 1.0, green:1.0, blue: 1.0, alpha: 1.0)
        let color2 = UIColor(red: 0.0, green: 0.95, blue: 0.8, alpha: 1.0)
        let gradient = CAGradientLayer()
        gradient.frame = _frame
        gradient.colors = [color1.CGColor,color2.CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
//MARK: - Override Function
//-------------------------
    override func viewWillAppear(animated: Bool) {
        
        self.detail_tableView?.setContentOffset(CGPointMake(0, 0), animated: false)
        self.note_textView?.text = ary_data[0].note == "" ? "暫無資料":ary_data[0].note
    }


}
