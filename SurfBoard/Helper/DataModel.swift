//
//  FEDataModel.swift
//  FestEvents
//
//  Created by Kartum Infotech on 4/20/17.
//  Copyright © 2017 Sunil Zalavadiya. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Map JSON
class Map {
    
    init() {}
    
    var data: [String: AnyObject]?
    
    init(data: [String: AnyObject]) {
        self.data = data
    }
    
    func value<T>(_ forKey: String, transformDate: (format: String , timeZone: String)? = nil, isMilliseconds: Bool = false) -> T? {
        
        let strValue = data?[forKey] as? String ?? data?[forKey]?.stringValue ?? ""
        
        if T.self == String.self || T.self == Optional<String>.self || T.self == Optional<String>.self {
            return strValue as? T
        }
        
        if T.self == Int.self || T.self == Optional<Int>.self || T.self == Optional<Int>.self {
            if let value = data?[forKey] as? NSNumber { return value.intValue as? T }
            return (strValue as NSString).integerValue as? T
        }
        else if T.self == Date.self || T.self == Optional<Date>.self || T.self == Optional<Date>.self {
            if isNumber(str: strValue)
            {
                return convertDateFrom(timeInterval: (strValue as NSString).doubleValue, isMilliseconds: isMilliseconds) as? T
            }
            
            return getDateFromString(dateStr: strValue, formate: (transformDate?.format)!, timeZone: (transformDate?.timeZone)!) as? T
        }
        else if T.self == Double.self || T.self == Optional<Double>.self || T.self == Optional<Double>.self {
            return data?[forKey]?.doubleValue as? T
        }
        else if T.self == Float.self || T.self == Optional<Float>.self || T.self == Optional<Float>.self {
            return data?[forKey]?.floatValue as? T
        }
        else if T.self == Bool.self  || T.self == Optional<Bool>.self || T.self == Optional<Bool>.self {
            return data?[forKey]?.boolValue as? T
        }
        else if T.self == URL.self  || T.self == Optional<URL>.self || T.self == Optional<URL>.self {
            return URL(string: strValue) as? T
        }
        else if T.self == [AnyObject].self || T.self == Optional<[AnyObject]>.self || T.self == Optional<[AnyObject]>.self {
            return data?[forKey] as? T
        }
        else if T.self == [String: AnyObject].self || T.self == Optional<[String: AnyObject]>.self || T.self == Optional<[String: AnyObject]>.self {
            return data?[forKey] as? T
        }
        
        return nil
    }
    
    private func convertDateFrom(timeInterval: Double, isMilliseconds: Bool = false) -> Date {
        let seconds = isMilliseconds ? (timeInterval / 1000) : timeInterval
        return Date(timeIntervalSince1970: TimeInterval(seconds))
    }
    
    private func getDateFromString(dateStr: String, formate: String, timeZone: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        dateFormatter.dateFormat = formate
        
        return dateFormatter.date(from: dateStr)
    }
    
    private func getStringFromDate(date: Date,formate: String, timeZone: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        dateFormatter.dateFormat = formate
        
        return dateFormatter.string(from: date)
    }
    
    private func isNumber(str: String) -> Bool {
        let numberCharacters = NSCharacterSet.decimalDigits.inverted
        return !str.isEmpty && str.rangeOfCharacter(from: numberCharacters) == nil
    }
}

//MARK: - Response Data
class ResponseData1
{
    init() {}
    
    var status = 0
    var message = ""
    
    init(data: AnyObject)
    {
        status  = (data["status"] as? NSNumber)?.intValue ?? (data["status"] as? String)?.toInt() ?? 0
        message = data["message"] as? String ?? ""
        
        if message.isEmpty
        {
            let errors = data["errors"] as? [AnyObject] ?? [AnyObject]()
            
            if errors.count > 0
            {
                message = errors[0] as? String ?? ""
            }
        }
    }
}

//MARK: - Dictionary formate Data
class UserData
{
    init() {}
    
    var map: Map!
    
    var displayName = ""
    var email = ""
    var id = ""
    var image = ""
    var address = ""
    var token = ""
    var taxApply = Bool()
    var role = [String]()
    
    init(data: [String: AnyObject])
    {
        map = Map(data: data)
        displayName = map.value("display_name") ?? ""
        email = map.value("user_email") ?? ""
        id = map.value("sec_u") ?? ""
        image = map.value("profile_image") ?? ""
        address = map.value("address") ?? ""
        token = map.value("token") ?? ""
        //taxApply = map.value("tax_apply")!
        role = map.value("role") ?? [""]
    }
}

class MessageDataList {
    
    init() {}
    
    var map: Map!
    
    var arrMessage = [MessageData]()
    
    init(data: [[String: AnyObject]]) {
        
        for dictDishCategory in data {
            arrMessage.append(MessageData(data: dictDishCategory))
        }
    }
    
    class MessageData {
        
        init() {}
        
        var map: Map!
        
        var MsgID = ""
        var Name = ""
        var CompanyName = ""
        var DateStamp = ""
        var TimeStamp = ""
        var CallerFirstName = ""
        var CallerLastName = ""
        var Phone = ""
        var Notes = ""
        var MessageHistory = ""
        var isRead = ""
        var CallerFullName = ""
        var AltPhone = ""
        var ReceiveTextMessages = ""
        var DOD = ""
        var MessageConfirmed = ""
        var FacilityName = ""
        var IsDeathCall = ""
        var DID_OfficeCall = ""
        
        //var arrImage = Array<String>()
        
        init(data: [String: AnyObject]) {
            map = Map(data: data)
            MsgID = map.value("msgID") ?? ""
            CompanyName = map.value("CompanyName") ?? ""
            Name = map.value("ClientName") ?? ""
            DateStamp = map.value("DateStamp") ?? ""
            TimeStamp = map.value("TimeStamp") ?? ""
            CallerFirstName = map.value("CallerFirstName") ?? ""
            CallerLastName = map.value("CallerLastName") ?? ""
            CallerFullName = map.value("CallerFullName") ?? ""
            Phone = map.value("Phone") ?? ""
            Notes = map.value("Notes") ?? ""
            MessageHistory = map.value("MessageHistory") ?? ""
            isRead = map.value("IsRead") ?? ""
            AltPhone = map.value("AltPhone") ?? ""
            ReceiveTextMessages = map.value("ReceiveTextMessages") ?? ""
            DOD = map.value("DOD") ?? ""
            MessageConfirmed = map.value("MessageConfirmed") ?? ""
            FacilityName = map.value("FacilityName") ?? ""
            IsDeathCall = map.value("IsDeathCall") ?? ""
            DID_OfficeCall = map.value("") ?? ""
            
            //            for images in data["gallery"] as? [[String : AnyObject]] ?? [[:]] {
            //                arrImage.append(images["large"] as? String ?? "")
            //            }
            //            for img in data["image"] as? [[String : AnyObject]] ?? [[:]]{
            //                image_url = img["large"] as? String ?? ""
            //            }
        }
    }
}

class ServicesDataList {
    
    init() {}
    
    var map: Map!
    
    var arrService = [ServiceData]()
    
    init(data: [[String: AnyObject]]) {
        
        for dictDishCategory in data {
            arrService.append(ServiceData(data: dictDishCategory))
        }
    }
    
    class ServiceData {
        
        init() {}
        
        var map: Map!
        
        var Record_ID = ""
        var CastType = ""
        var DecName = ""
        var Age = ""
        var DOD = ""
        var Chapel = ""
        var LivedAt = ""
        var VisitationTime = ""
        var StampTime = ""
        var Flowers = ""
        //
        var VisitationDate = ""
        var VisitationLocation = ""
        var Rosary = ""
        var ServiceDate = ""
        var ServiceTime = ""
        var ServiceLocation = ""
        var Mass = ""
        var BurialLocation = ""
        var RoBurialAddresssary = ""
        var BurialDirections = ""
        var Shiva = ""
        var ShivaDirections = ""
        var BuMemorialsrialDirections = ""
        var PastService = ""
        var IsPurged = ""
        var NOK = ""
        var OtherInfo = ""
        var StampInitial = ""
        var CreatedBy = ""
        var CreateDate = ""
        var ModifiedBy = ""
        var ModifiedDate = ""
        var IsActive = ""
        var Trisagionservice = ""
        var SecondVisitationDate = ""
        var SecondVisitationTime = ""
        var SecondVisitationLocation = ""
        var OtherServices = ""
        var token = ""
        var BurialAddress = ""
        var Memorials = ""
        
        
        
        
        //var arrImage = Array<String>()
        
        init(data: [String: AnyObject]) {
            map = Map(data: data)
            Record_ID = map.value("RecordID") ?? ""
            CastType = map.value("CastType") ?? ""
            DecName = map.value("DecName") ?? ""
            Age = map.value("Age") ?? ""
            DOD = map.value("DOD") ?? ""
            Chapel = map.value("Chapel") ?? ""
            LivedAt = map.value("LivedAt") ?? ""
            VisitationTime = map.value("VisitationTime") ?? ""
            StampTime = map.value("StampTime") ?? ""
            Flowers = map.value("Flowers") ?? ""
            
            //
            VisitationDate = map.value("VisitationDate") ?? ""
            VisitationLocation = map.value("VisitationLocation") ?? ""
            Rosary = map.value("Rosary") ?? ""
            ServiceDate = map.value("ServiceDate") ?? ""
            ServiceTime = map.value("ServiceTime") ?? ""
            ServiceLocation = map.value("ServiceLocation") ?? ""
            Mass = map.value("Mass") ?? ""
            BurialLocation = map.value("BurialLocation") ?? ""
            RoBurialAddresssary = map.value("RoBurialAddresssary") ?? ""
            BurialDirections = map.value("BurialDirections") ?? ""
            Shiva = map.value("Shiva") ?? ""
            ShivaDirections = map.value("ShivaDirections") ?? ""
            BuMemorialsrialDirections = map.value("BuMemorialsrialDirections") ?? ""
            PastService = map.value("PastService") ?? ""
            IsPurged = map.value("IsPurged") ?? ""
            NOK = map.value("NOK") ?? ""
            OtherInfo = map.value("OtherInfo") ?? ""
            StampInitial = map.value("StampInitial") ?? ""
            CreatedBy = map.value("CreatedBy") ?? ""
            CreateDate = map.value("CreateDate") ?? ""
            ModifiedBy = map.value("ModifiedBy") ?? ""
            ModifiedDate = map.value("ModifiedDate") ?? ""
            IsActive = map.value("IsActive") ?? ""
            Trisagionservice = map.value("Trisagionservice") ?? ""
            SecondVisitationDate = map.value("SecondVisitationDate") ?? ""
            SecondVisitationTime = map.value("SecondVisitationTime") ?? ""
            SecondVisitationLocation = map.value("SecondVisitationLocation") ?? ""
            OtherServices = map.value("OtherServices") ?? ""
            token = map.value("token") ?? ""
            BurialAddress = map.value("BurialAddress") ?? ""
            Memorials = map.value("Memorials") ?? ""
            
            //            for images in data["gallery"] as? [[String : AnyObject]] ?? [[:]] {
            //                arrImage.append(images["large"] as? String ?? "")
            //            }
            //            for img in data["image"] as? [[String : AnyObject]] ?? [[:]]{
            //                image_url = img["large"] as? String ?? ""
            //            }
        }
    }
}

class OfficeDataList {
    
    init() {}
    
    var map: Map!
    
    var arrOffices = [OfficeData]()
    
    init(data: [[String: AnyObject]]) {
        
        for dictDishCategory in data {
            arrOffices.append(OfficeData(data: dictDishCategory))
        }
    }
    
    class OfficeData {
        
        init() {}
        
        var map: Map!
        
        var OfficeID = ""
        var AcctNum = ""
        var ClientName = ""
        var ContactPageClientName1 = ""
        var ContactPageFwdNumber1 = ""
        var ContactPageERFwdNumber1 = ""
        
        //var arrImage = Array<String>()
        
        init(data: [String: AnyObject]) {
            map = Map(data: data)
            OfficeID = map.value("OfficeID") ?? ""
            AcctNum = map.value("AcctNum") ?? ""
            ClientName = map.value("ClientName") ?? ""
            ContactPageClientName1 = map.value("ContactPageClientName1") ?? ""
            ContactPageFwdNumber1 = map.value("ContactPageFwdNumber1") ?? ""
            ContactPageERFwdNumber1 = map.value("ContactPageERFwdNumber1") ?? ""
            
            
            //            for images in data["gallery"] as? [[String : AnyObject]] ?? [[:]] {
            //                arrImage.append(images["large"] as? String ?? "")
            //            }
            //            for img in data["image"] as? [[String : AnyObject]] ?? [[:]]{
            //                image_url = img["large"] as? String ?? ""
            //            }
        }
    }
}

