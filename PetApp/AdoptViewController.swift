

import UIKit

class AdoptViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var m_tableView:UITableView!
    var ary_img = [UIImage]()
    var ary_stepTitle = [String]()
    var ary_stepDetail = [String]()
    var ary_knowhow = [String]()
    var ary_section = [String]()

//MARK: - Normal Function
//-----------------------
    func refresh(frame:CGRect,nav:CGFloat) {
        
        self.view.frame = frame
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "領養須知"
        
        //***************  m_tableView  **************
        m_tableView = UITableView(frame: CGRect(x: 0, y:0, width: frame.size.width, height: frame.size.height))
        m_tableView.dataSource = self
        m_tableView.delegate = self
        m_tableView.separatorColor = UIColor.blackColor()
        m_tableView.bounces = false
        m_tableView.estimatedRowHeight = self.view.frame.size.height/8
        self.view.addSubview(m_tableView)
        
        //***************  ary_stepTitle  **************
        ary_stepTitle.insert("第 1 步: 與狗狗第一次接觸", atIndex: 0)
        ary_stepTitle.insert("第 2 步: 填寫申請書", atIndex: 1)
        ary_stepTitle.insert("第 3 步: 核對相關證件", atIndex: 2)
        ary_stepTitle.insert("第 4 步: 狗狗健康檢查", atIndex: 3)
        ary_stepTitle.insert("第 5 步: 諮詢協助服務", atIndex: 4)
        ary_stepTitle.insert("第 6 步: 帶著寶貝一起回家", atIndex: 5)
        
        //***************  ary_stepDetail  **************
        ary_stepDetail.insert("參訪犬舍，從候選狗卡中挑選速配的狗狗，與候選狗狗初次相遇。", atIndex: 0)
        ary_stepDetail.insert("詢問櫃台服務人員，並填寫認養申請書。", atIndex: 0)
        ary_stepDetail.insert("核對申請書及身份證件，並繳交費用。", atIndex: 0)
        ary_stepDetail.insert("獸醫師進行健康檢查，並實施晶片植入、狂犬病預防注射及辦理寵物登記。", atIndex: 0)
        ary_stepDetail.insert("接受櫃台服務人員認養前諮詢及提供協助管道，必要時派員實施家庭訪問。", atIndex: 0)
        ary_stepDetail.insert("戴上新項圈及牽繩，您現在就可以帶寶貝回家。", atIndex: 0)
        
        //***************  ary_img  **************
        for num in 0 ... 5 {
            
            let img = UIImage(named: "adopt_\(num).png")
            ary_img.append(img!)
        }
        
        //***************  ary_knowhow  **************
        ary_knowhow.insert("1.  申請人:年滿20歲之民眾。未滿20歲者，以其法定代理人或法定監護人為飼主。", atIndex: 0)
        ary_knowhow.insert("2.  申請人應攜身分證明文件，填具申請書", atIndex: 1)
        ary_knowhow.insert("3.  承辦人員應就認養人核對身分證明文件，必要時得親自實地勘察。", atIndex: 2)
        ary_knowhow.insert("4.  待認養動物條件：於本處留置已逾7日尚無飼主認領或無身分標識者，且經本處健康行為評估適於認養者。", atIndex: 3)
        ary_knowhow.insert("5.  符合認養人資格者，得由管理人員協助，由可認養犬隻中，自行挑選合意犬隻。", atIndex: 4)
        ary_knowhow.insert("6.  繳交相關規費：晶片植入手續費250元、狂犬病預防注射費200元。", atIndex: 5)
        ary_knowhow.insert("7.  未實施晶片植入、狂犬病預防注射及寵物登記之動物，應於完成晶片植入、狂犬病預防注射及寵物登記後始得放行。唯8週齡以下幼犬暫免施打狂犬病疫苗。", atIndex: 6)
        ary_knowhow.insert("8.  認養之犬隻自領出日起1個月內，若因任何原因無法續養，可將該犬交還本所，填寫「不擬續養動物申請切結書」放棄該犬之所有權，並繳回寵物登記證及狂犬病預防注射證明辦理註銷。認養時所繳之費用概不退還。", atIndex: 7)
        
        //***************  ary_section  **************
        ary_section.insert("領養程序", atIndex: 0)
        ary_section.insert("其它領養相關需知", atIndex: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: - UITableView DataSource & Delegate
//-----------------------------------------
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return ary_section.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let theView = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/12))
        theView.text = ary_section[section]
        theView.textColor = UIColor.whiteColor()
        theView.textAlignment = .Center
        if section == 0 {
            
            theView.backgroundColor = UIColor.blueColor()
        }
        else if section == 1 {
            
            theView.backgroundColor = UIColor.redColor()
        }
        
        return theView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return self.view.frame.size.height/12
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var num:Int = 1
        
        if section == 0 {
            
            num = ary_stepTitle.count
        }
        else if section == 1 {
            
            num = ary_knowhow.count
        }
        
        return num
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let adopt_cell_id:String = "ADOPT_CELL_ID"
        var cell = tableView.dequeueReusableCellWithIdentifier(adopt_cell_id) as UITableViewCell!
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: adopt_cell_id)
            cell.selectionStyle = .None
        }
        
        if indexPath.section == 0 {
            
            cell.textLabel?.text = ary_stepTitle[indexPath.row]
            cell.textLabel?.textColor = UIColor.blueColor()
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            
            cell.detailTextLabel?.text = ary_stepDetail[indexPath.row]
            cell.detailTextLabel?.textColor = UIColor.darkGrayColor()
            cell.detailTextLabel?.numberOfLines = 0
            
            cell.imageView?.image = ary_img[indexPath.row]
            cell.imageView?.contentMode = .ScaleAspectFit
            cell.clipsToBounds = true
        }
        else if indexPath.section == 1 {
            
            cell.detailTextLabel?.text = ary_knowhow[indexPath.row]
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            
            cell.textLabel?.text = ""
            cell.imageView?.image = nil
        }
        
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var theHeight:CGFloat = self.view.frame.size.height/8
        
        if indexPath.section == 1 {
            
            if indexPath.row == 6 || indexPath.row == 7 {
                
                theHeight = self.view.frame.size.height/5
            }
        }
        
        return theHeight
    }

}
