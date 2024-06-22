//
//  AFModel.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import Foundation

struct DefaultResponseModel: Decodable {
    let result: Int?         //
    let message: String?    //
    let data: String?       //
    
    enum CodingKeys: String, CodingKey {
        case result, message, data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
//        result = try container.decode(Int?.self, forKey: .result)!
        if let newResult = try? container.decode(Int.self, forKey: .result){
            result = newResult
        }
        else{
            if let newResult = try? container.decode(String.self, forKey: .result) {
                result = Int(newResult)
            } else {
                result = nil
            }
        }
        if let newMsg = try? container.decode(String.self, forKey: .message){
            message = newMsg
        }
        else{
            if let newMsg = try? container.decode(Int.self, forKey: .message) {
                message = String(newMsg)
            } else {
                message = nil
            }
        }
        if let newdata = try? container.decode(String.self, forKey: .data){
            data = newdata
        }
        else{
            if let newdata = try? container.decode(Int.self, forKey: .data) {
                data = String(newdata)
            } else {
                data = nil
            }
        }
    }
}

struct OnlyResultModel: Decodable {
    let result: Int         //
    let data: String?       //
    
    enum CodingKeys: String, CodingKey {
        case result, data
    }
}
