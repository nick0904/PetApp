

import UIKit
import MessageUI
import AVFoundation

class ConnectUSViewController: UIViewController,MFMailComposeViewControllerDelegate {
    
    var ary_bts = [UIButton]()
    var mapVC:MapViewController?
    private var soundPlayer:AVAudioPlayer?

    func refreshWithFrame(frame:CGRect,navH:CGFloat) {
        
        self.view.frame = frame
        self.view.backgroundColor = UIColor.whiteColor()
        
        //===================  mark  =================
        let mark = UILabel(frame: CGRect(x: frame.size.width/2 - (frame.size.width * 0.4)/2, y: navH + 20 + 20, width: frame.size.width * 0.4, height: frame.size.width * 0.4))
        mark.layer.cornerRadius = mark.frame.size.width/2
        mark.backgroundColor = UIColor.orangeColor()
        mark.clipsToBounds = true
        mark.textAlignment = .Center
        mark.textColor = UIColor.whiteColor()
        mark.text = "臺北市動物保護處"
        self.view.addSubview(mark)
        
        //==================  bts  ===================
        
        for num in 0 ... 3 {
            
            let bt = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width * 0.68, height: frame.size.width/6))
            bt.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2 + (bt.frame.size.height + 20) * CGFloat(num))
            bt.layer.shadowColor = UIColor.blackColor().CGColor
            bt.layer.shadowOpacity = 0.8
            bt.layer.shadowOffset = CGSizeMake(6.0, 6.0)
            bt.showsTouchWhenHighlighted = true
            bt.addTarget(self, action: #selector(ConnectUSViewController.onBtAction(_:)), forControlEvents: .TouchUpInside)
            self.view.addSubview(bt)
            self.ary_bts.append(bt)
        }
        
        ary_bts[0].backgroundColor = UIColor.blueColor()
        ary_bts[1].backgroundColor = UIColor.redColor()
        ary_bts[2].backgroundColor = UIColor.brownColor()
        ary_bts[3].backgroundColor = UIColor(red: 0.0, green: 0.7, blue: 0.0, alpha: 1.0)
        
        ary_bts[0].setTitle("北市動保處網站", forState: .Normal)
        ary_bts[1].setTitle("電話聯絡", forState: .Normal)
        ary_bts[2].setTitle("電子信箱", forState: .Normal)
        ary_bts[3].setTitle("動物之家位置", forState: .Normal)
        
        //==============  soundPlayer  ===============
        
        do {
            
            soundPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: NSBundle.mainBundle().pathForResource("button", ofType: "mp3")!)!)
            
        } catch {
            
            let _error = error as NSError
            print("audioPlayer failed:\(_error.localizedDescription)")
        }
    }
    
    func onBtAction(sender:UIButton) {
        
        self.soundPlayer?.play()
        
        var theTitle:String = ""
        var ary_actionTitle = [String]()
        switch sender {
            
        case ary_bts[0]:
            theTitle = "選擇您想前往的網站"
            ary_actionTitle = ["動保處網站","動物之家網站"]
        case ary_bts[1]:
            theTitle = "選擇您想聯絡的單位"
            ary_actionTitle = ["聯繫動保處","聯繫動物之家"]
        case ary_bts[2]:
            theTitle = "電子郵件寄送單位"
            ary_actionTitle = ["寄信給動保處","寄信給動物之家"]
        case ary_bts[3]:
            theTitle = "開啟地圖"
            ary_actionTitle = ["動保處位置","動物之家位置"]
        default:
            break
        }
        
        self.choeseActionSheet(theTitle, ary_actionTitle: ary_actionTitle)
        
    }
    
//MARK: - choeseAlertShow
//-----------------------
    func choeseActionSheet(_title:String,ary_actionTitle:[String]) {
        
        var theTitle:String = ""
    
        let actionSheet = UIAlertController(title: _title, message: "", preferredStyle: .ActionSheet)
        
        for num in 0 ... ary_actionTitle.count - 1 {
            
            actionSheet.addAction(UIAlertAction(title: ary_actionTitle[num], style: .Default, handler: { (action) in
                
                switch _title {
                    
                case "選擇您想前往的網站":
                    if ary_actionTitle[num] == "動保處網站" {
                        theTitle = "前往動保處網站 ?"
                    }else {
                        theTitle = "前往動物之家網站 ?"
                    }
                    self.actionAlertShow(theTitle)
                case "選擇您想聯絡的單位":
                    if ary_actionTitle[num] == "聯繫動保處" {
                        theTitle = "聯絡動保處 ?"
                    }else {
                        theTitle = "聯絡動物之家 ?"
                    }
                    self.actionAlertShow(theTitle)
                case "電子郵件寄送單位":
                    if ary_actionTitle[num] == "寄信給動保處" {
                         theTitle = "寫信給動保處 ?"
                    }else {
                        theTitle = "寫信給動物之家 ?"
                    }
                    self.actionAlertShow(theTitle)
                case "開啟地圖":
                    if ary_actionTitle[num] == "動保處位置" {
                        theTitle = "查詢動保處位置 ?"
                    }else {
                        theTitle = "查詢動物之家位置 ?"
                    }
                    self.actionAlertShow(theTitle)
                default:
                    break
                }
                
            }))
            
        }
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: .Destructive, handler: nil))
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
//MARK: - alertShow
//-----------------
   func actionAlertShow(theTitle:String) {
    
        let alert = UIAlertController(title: theTitle, message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "確定", style: .Default, handler: { (action) in
            
            switch theTitle {
                
            case "前往動保處網站 ?":
                UIApplication.sharedApplication().openURL(NSURL(string: "http://www.tcapo.gov.taipei")!)
            case "前往動物之家網站 ?":
                 UIApplication.sharedApplication().openURL(NSURL(string: "http://www.tcapo.gov.taipei/np.asp?ctNode=69749&mp=105033")!)
            case "聯絡動保處 ?":
               UIApplication.sharedApplication().openURL(NSURL(string: "tel://02-87897158")!)
            case "聯絡動物之家 ?":
                UIApplication.sharedApplication().openURL(NSURL(string: "tel://02-87913254")!)
            case "寫信給動保處 ?":
                self.sendEmail(["tcapoa8@mail.taipei.gov.tw"])
            case "寫信給動物之家 ?":
                self.sendEmail(["tcapo077@mail.gov.taipei"])
            case "查詢動保處位置 ?":
                self.showMeMap("臺北市信義區吳興街600巷109號", annotationSubtitle: "北市動保處",_imgName:"animalPO.png")
            case "查詢動物之家位置 ?":
                self.showMeMap("臺北市內湖區潭美街852號", annotationSubtitle: "北市動物之家",_imgName: "animalHome.jpeg")
            default:
                break
            }
            
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .Destructive, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
//MARK: - showMeMap
//-----------------
    func showMeMap(address:String,annotationSubtitle:String,_imgName:String) {
        
        if mapVC == nil {
            
            mapVC = MapViewController()
            mapVC?.refreshWithFrame(self.view.frame)
        }
        mapVC?.addressStr = address
        mapVC?.annotationSubtitle = annotationSubtitle
        mapVC?.imgName = _imgName
        self.navigationController?.pushViewController(mapVC!, animated: true)
        
    }
    
//MARK: - MFMailComposeViewController Delegate
//--------------------------------------------
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        var message:String = ""
        switch result {
            
        case MFMailComposeResultCancelled:
            message = "郵件已取消"
        case MFMailComposeResultSaved:
            message = "郵件已儲存"
        case MFMailComposeResultSent:
            message = "郵件已寄送"
        case MFMailComposeResultFailed:
            message = "郵件寄送失敗"
        default:
            break
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)

        let alert = UIAlertController(title: "電子郵件", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "確定", style: .Destructive, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func sendEmail(recipient:[String]) {
        
        let mailCompseVC = MFMailComposeViewController()
        
        if !MFMailComposeViewController.canSendMail() {//判斷有無mail的功能
            return
        }
        
        mailCompseVC.mailComposeDelegate = self
        mailCompseVC.setToRecipients(recipient) //設定收件者
        self.presentViewController(mailCompseVC, animated: true, completion: nil)

    }

}
