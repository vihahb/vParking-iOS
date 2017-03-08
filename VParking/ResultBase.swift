//
//  ResultBase.swift
//  VParking
//
//  Created by TD on 2/17/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import EVReflection
class ResultBase: EVObject {
    var error:NIPError?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "error"{
            error = value as? NIPError
            return
        }
        super.setValue(value, forKey: key)
    }
}
