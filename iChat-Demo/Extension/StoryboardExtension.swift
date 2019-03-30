//
//  StoryboardExtension.swift
//  iChat-Demo
//
//  Created by Genies on 3/23/19.
//  Copyright © 2019 Genies. All rights reserved.
//

import UIKit

private  extension UIStoryboard {
    static func mainStoryboard()->UIStoryboard{
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    static func registerVC ()->RegisterVC?{
        return mainStoryboard().instantiateViewController(withIdentifier: REGISTER_VC) as? RegisterVC
    }
}
