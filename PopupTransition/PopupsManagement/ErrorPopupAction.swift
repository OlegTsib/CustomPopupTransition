//
//  ErrorPopupAction.swift
//  PopupTransition
//
//  Created by Oleg Tsibulevskiy on 10/05/2020.
//  Copyright © 2020 OTCode. All rights reserved.
//

import Foundation

struct ErrorPopupAction
{
    var configurations : ErrorPopupButtonConfigurator
    var handler      : ErrorPopupButtonHandler?
    
    init(configurator: ErrorPopupButtonConfigurator, handler: ErrorPopupButtonHandler? = nil )
    {
        self.configurations = configurator
        self.handler        = handler
    }
}
