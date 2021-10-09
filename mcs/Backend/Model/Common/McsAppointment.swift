/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/22.
 */

import UIKit
import ObjectMapper
import QDCore

public class McsAppointment: McsBase {
    
    public var begin: Date!
    public var specialtyCode: String!
    public var type: McsPackageType!
    public var price: McsPrice!
    public var visitTime: Int!
    public var symptoms: [McsSymptom]!
    public var allergies: [McsAllergy]?
    public var surgeries: [McsSurgery]?
    public var medications: [McsMedication]?
    public var packageId: Int!
    public var status: McsAptStatus?
    public var order: Int?
    public var doctorInfo: McsDoctor?
    public var clinicInfo: McsClinic?
    public var patientInfo: McsPatient?

    override public func mapping(map: Map) {
        super.mapping(map: map)
        begin               <- (map["begin"], DateTimeTransform())
        specialtyCode       <- map["specialty"]
        type                <- map["type"]
        price               <- map["price"]
        visitTime           <- map["visitTime"]
        symptoms            <- map["symptoms"]
        allergies           <- map["allergies"]
        surgeries           <- map["surgeries"]
        medications         <- map["medications"]
        packageId           <- map["packageId"]
        status              <- map["status"]
        order               <- map["order"]
        doctorInfo          <- map["doctorInfo"]
        clinicInfo          <- map["clinicInfo"]
        patientInfo         <- map["patientInfo"]
    }
    
    private init(begin: Date, specialtyCode: String, type: McsPackageType, price: McsPrice, visitTime: Int, symptoms: [McsSymptom], allergies: [McsAllergy]?, surgeries: [McsSurgery]?, medications: [McsMedication]?, packageId: Int) {
        super.init()
        self.begin = begin
        self.specialtyCode = specialtyCode
        self.type = type
        self.price = price
        self.visitTime = visitTime
        self.symptoms = symptoms
        self.allergies = allergies
        self.surgeries = surgeries
        self.medications = medications
        self.packageId = packageId
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public static func create(begin: Date, specialtyCode: String, type: McsPackageType, price: McsPrice, visitTime: Int, symptoms: [McsSymptom], allergies: [McsAllergy]?, surgeries: [McsSurgery]?, medications: [McsMedication]?, packageId: Int) -> McsAppointment {
        return McsAppointment.init(begin: begin, specialtyCode: specialtyCode, type: type, price: price, visitTime: visitTime, symptoms: symptoms, allergies: allergies, surgeries: surgeries, medications: medications, packageId: packageId)
    }
    
}
