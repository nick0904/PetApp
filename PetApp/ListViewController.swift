

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var _tableView:UITableView?
    var m_petData = [PetData]() //儲存下載資料
    var _indicator:UIActivityIndicatorView? //下載指示器
    var _infoVC:InfomationViewController? //動物詳細料
    var _connectVC:ConnectUSViewController? //連結動保處相關訊息頁面
    private let m_refresh = UIRefreshControl() //資料重載
    
    private let urlStr:String = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f4a75ba9-7721-4363-884d-c3820b0b917c" //動保處 jsonData 連結
    
//MARK: - Normal Function
//-----------------------
    func refreshWithFrame(frame:CGRect) {
        
        self.view.frame = frame
        self.gradientBackground(self.view)
        self.title = "臺北市動物之家"
        
        //****************  _tableView  ****************
        _tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        _tableView?.dataSource = self
        _tableView?.delegate = self
        _tableView?.backgroundColor = UIColor.clearColor()
        _tableView?.separatorColor = UIColor.orangeColor()
        self.view.addSubview(_tableView!)
        
        //***************  jsonData 下載  ****************
        self.loadData()
        
        //***************  顯示下載指示器   ***************
        self.showIndicator()
        self._indicator?.startAnimating()
        
        //*************  下拉更新  **************
        m_refresh.tintColor = UIColor.redColor()
        let tableVC = UITableViewController()
        tableVC.tableView = self._tableView
        tableVC.refreshControl = self.m_refresh
        m_refresh.addTarget(self, action: #selector(ListViewController.refreshData), forControlEvents: .ValueChanged)

    }
    
//MARK: - refreshData
//-------------------
    func  refreshData() {
        
        self.loadData()
        self.m_refresh.endRefreshing()
    }

//MARK: -  loadData
//-----------------
    func loadData() {
        
        self._indicator?.startAnimating()
        let urlRequest = NSURLRequest(URL: NSURL(string: urlStr)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) { (_data, _response, _error) in
            
            if _error != nil {
                
                print("loadError:\(_error!.localizedDescription)")
                return
            }
            
            self.m_petData = self.parseJson(_data!)
            
            dispatch_async(dispatch_get_main_queue(), { 
                
                self._indicator?.stopAnimating()
                self._tableView?.reloadData()
            })
            
        }
        
        task.resume()
        
    }
    
//MARK: - parseJson
//----------------
    func parseJson(data:NSData) -> [PetData] {
        
        var petData = [PetData]()
        var jsonDataArray = [AnyObject]()
        
            do {
                
                //parseFirst
                let originJSONData = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                //parseSecond
                let jsonDic = originJSONData.objectForKey("result") as! NSDictionary
                //parseThird
                jsonDataArray = jsonDic.objectForKey("results") as! [AnyObject]
                
            }
            catch {
                    
                let parseError = error as NSError
                print("parseError:\(parseError.localizedDescription)")
            }
        
        for index in 0 ..< jsonDataArray.count {
            
            let dic = jsonDataArray[index]
            let pet = PetData()
            pet.name = dic.objectForKey("Name") as! String
            pet.acceptNum = dic.objectForKey("AcceptNum") as! String
            pet.sex = dic.objectForKey("Sex") as! String
            pet.age = dic.objectForKey("Age") as! String
            pet.bodyWeight = dic.objectForKey("Bodyweight") as! String
            pet.hairType = dic.objectForKey("HairType") as! String
            pet.note = dic.objectForKey("Note") as! String
            pet.isSterilization = dic.objectForKey("IsSterilization") as! String
            pet.imageName = dic.objectForKey("ImageName") as! String
            
            petData.append(pet)
        }
    
        return petData
    }
    
    
//MARK: - showIndicator
//---------------------
    func showIndicator() {
        
        if self._indicator == nil {
            
            self._indicator = UIActivityIndicatorView(frame: CGRectZero)
            self._indicator?.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
            self._indicator?.hidesWhenStopped = true
            self._indicator?.activityIndicatorViewStyle = .WhiteLarge
            self._indicator?.color = UIColor.redColor()
            self.view.addSubview(self._indicator!)
        }
        
    }
    
//MARK: - UITableView DataSource & Delegate
//-----------------------------------------
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.m_petData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell_id = "CELL_ID"
        var cell = tableView.dequeueReusableCellWithIdentifier(cell_id) as! MyTableViewCell!
        if cell == nil {
            
            cell = MyTableViewCell()
            cell.refreshWithFrame(CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/4))
            cell.selectionStyle = .None
        }
        
        cell.name_label?.text = m_petData[indexPath.row].name == "" ? "寶貝名字:  " + "暫無資料" : "寶貝名字:  " + "\(m_petData[indexPath.row].name)"
        cell.acceptNum_label?.text = m_petData[indexPath.row] == "" ? "收容編號:  " + "暫無編號" : "收容編號:  " + "\(m_petData[indexPath.row].acceptNum)"
        
        let url = NSURL(string: m_petData[indexPath.row].imageName)
        let session = NSURLSession.sharedSession()
        
        let imgTask = session.dataTaskWithURL(url!) { (data, responce, error) in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                
                cell.cell_imgView?.image = UIImage(data: data!)
            })
            
        }
        imgTask.resume()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if _infoVC == nil {
            
            _infoVC = InfomationViewController()
            _infoVC?.refreshWithFrame(self.view.frame, navH: self.navigationController!.navigationBar.frame.size.height)
        }
        
        _infoVC?.info_data = self.m_petData[indexPath.row]
        
        //image
        let url = NSURL(string: m_petData[indexPath.row].imageName)
        let session = NSURLSession.sharedSession()
        
        let imgTask = session.dataTaskWithURL(url!) { (data, responce, error) in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                
                self._infoVC?.detail_imgView!.image = UIImage(data: data!)
            })
        }
        imgTask.resume()
        
        _infoVC?.detail_tableView?.reloadData()
        
        self.navigationController?.pushViewController(_infoVC!, animated: true)
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.view.frame.size.height/4
    }
    

//MARK: - gradientBackground 背景漸層顏色
//-------------------------------------
    func gradientBackground(view:UIView) {
        
        let color1 = UIColor(red: 1.0, green:1.0, blue: 1.0, alpha: 1.0)
        let color2 = UIColor(red: 0.0, green: 0.95, blue: 0.8, alpha: 1.0)
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = [color1.CGColor,color2.CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
    }

//MARK: - onBarBtItemAction
//-------------------------
    func onBarBtItemAction(sender:UIBarButtonItem) {
        
        if _connectVC == nil {
            
            _connectVC = ConnectUSViewController()
            _connectVC?.refreshWithFrame(self.view.frame, navH: self.navigationController!.navigationBar.frame.height)
        }
        
        self.navigationController?.pushViewController(_connectVC!, animated: true)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "聯絡我們", style: .Plain, target: self, action: #selector(ListViewController.onBarBtItemAction(_:)))
    }
    
    
}//end class
