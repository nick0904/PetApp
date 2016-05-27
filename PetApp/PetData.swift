
/*
 
 資料來源: Taipei OpenData
 http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f4a75ba9-7721-4363-884d-c3820b0b917c
 
 ==========  JSON 相關 key值  =============
 Name:              寵物小名
 Sex:               雌雄
 Age:               年齡
 AcceptNum:         寵物編號
 IsSterilization:   是否絕育(結紮)
 HairType:          毛色
 Note:              相關備註
 Bodyweight:        體重
 ImageName:         照片連結
 
*/


import UIKit

class PetData: NSObject {
    
    var name:String = ""
    var sex:String = ""
    var age:String = ""
    var acceptNum:String = ""
    var hairType:String = ""
    var note:String = ""
    var bodyWeight:String = ""
    var isSterilization:String = ""
    var imageName:String = ""

}
