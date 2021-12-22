//
//  UIViewController+Context.swift
//  MoviesLib
//
//  Created by user195143 on 12/16/21.
//

import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
