
//資料來源: Taipei OpenData
//http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f4a75ba9-7721-4363-884d-c3820b0b917c

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var ary_json = [AnyObject]()
    
    var _tableView:UITableView?
    
    var _indicator:UIActivityIndicatorView? //下載指示器
    
    var _infoVC:InfomationViewController?
    
    var _connectVC:ConnectUSViewController?


    func refreshWithFrame(frame:CGRect) {
        
        self.view.frame = frame
        self.gradientBackground(self.view)
        self.title = "臺北市動物之家"
        
        //==================  _tableView  ====================
        _tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        _tableView?.dataSource = self
        _tableView?.delegate = self
        _tableView?.backgroundColor = UIColor.clearColor()
        _tableView?.separatorColor = UIColor.orangeColor()
        self.view.addSubview(_tableView!)
            
        self.showIndicator()
        self._indicator?.startAnimating()

        let urlStr = NSURL(string: "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f4a75ba9-7721-4363-884d-c3820b0b917c")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(urlStr!) { (_data, _response, _error) in
            
            if _error != nil {
                
                print("loadDataError:\(_error?.localizedDescription)")
            }
            
             self.ary_json = self.parseJson(_data!)
        }

        task.resume()
    }
    
//MARK: - UITableView DataSource
//------------------------------
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.ary_json.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell_id = "CELL_ID"
        var cell = tableView.dequeueReusableCellWithIdentifier(cell_id) as! MyTableViewCell!
        if cell == nil {
            
            cell = MyTableViewCell()
            cell.refreshWithFrame(CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/4))
            cell.selectionStyle = .None
        }
        
        let dic = self.ary_json[indexPath.row] as! NSDictionary
        
        cell.name_label?.text = dic.objectForKey("Name") as? String == "" ? "寶貝名字:  " + "暫無資料" : "寶貝名字:  " + "\(dic.objectForKey("Name")!)"
        
        cell.acceptNum_label?.text = dic.objectForKey("AcceptNum") as? String == "" ? "收容編號:  " + "暫無編號" : "收容編號:  " + "\(dic.objectForKey("AcceptNum")!)"
        
        let url = NSURL(string: dic.objectForKey("ImageName") as! String)
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
        
        let dic = self.ary_json[indexPath.row] as! NSDictionary
        
        let tuples = (
            
            dic.objectForKey("Name") as! String,
            dic.objectForKey("AcceptNum") as! String,
            dic.objectForKey("Age") as! String,
            dic.objectForKey("Sex") as! String,
            dic.objectForKey("HairType") as! String,
            dic.objectForKey("Bodyweight") as! String,
            dic.objectForKey("IsSterilization") as! String,
            dic.objectForKey("Note") as! String
        )
        _infoVC?.ary_data = [tuples]
        
        //image
        let url = NSURL(string: dic.objectForKey("ImageName") as! String)
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
    
//MARK: - paseJson
//----------------
    func parseJson(data:NSData) -> [AnyObject] {
        
        var jsonDataArray = [AnyObject]()
        
            do {
                    
                let originJSONData = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let jsonDic = originJSONData.objectForKey("result") as! NSDictionary
                jsonDataArray = jsonDic.objectForKey("results") as! [AnyObject]
                //self.ary_json = jsonDataArray
                    
                NSOperationQueue.mainQueue().addOperationWithBlock({ 
                    
                    self._tableView?.reloadData()
                    self._indicator?.stopAnimating()
                })
                
            }
            catch {
                    
                let parseError = error as NSError
                print("parseError:\(parseError.localizedDescription)")
            }
    
        return jsonDataArray
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
