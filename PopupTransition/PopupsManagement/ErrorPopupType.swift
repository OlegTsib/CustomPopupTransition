//
//  ErrorPopupType.swift
//  PopupTransition
//
//  Created by Oleg Tsibulevskiy on 10/05/2020.
//  Copyright © 2020 OTCode. All rights reserved.
//

import UIKit

typealias ErrorPopupButtonHandler = ((_ button: UIButton, _ sender: Any?) -> Void?)?

enum ErrorPopupType
{
    case regularError(error: CustomError?, defaultAction: ErrorPopupButtonHandler?)
    case contactUs(data: ErrorPopupContentData, okAction: ErrorPopupButtonHandler?, cotanctUsAction: ErrorPopupButtonHandler?)
}
