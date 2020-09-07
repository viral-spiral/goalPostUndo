//
//  GoalType.swift
//  goalpost
//
//  Created by Penny on 31/8/20.
//  Copyright © 2020 Penny. All rights reserved.
//

import Foundation

enum GoalType : String {
    case longTerm = "Long Term"
    case shortTerm = "Short Term"
}

enum LastAction {
    case noAction
    case goalAdded
    case progressUpdated
    case goalDeleted
    case undo
}
