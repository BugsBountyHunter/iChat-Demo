//
//  ChatCell.swift
//  iChat-Demo
//
//  Created by Genies on 3/28/19.
//  Copyright © 2019 Genies. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    //MARK:- outlets
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    //MARK:- properties
    var indexPath:IndexPath!
    let tap = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tap.addTarget(self, action: #selector(avatarTap))
        avatarImage.isUserInteractionEnabled = true
        avatarImage.addGestureRecognizer(tap)
    }
    //MARK:-  function
    @objc func avatarTap(){
        print("avatar at \(indexPath)")
    }
    func setupCell(withUser user:User ,andIndexPath indexPath:IndexPath){
        self.indexPath = indexPath
        self.userName.text = user.fullName
        if user.avatar != "" {
            dataImage(fromString: user.avatar) { (dataImage) in
                if dataImage != nil {
                    self.avatarImage.image = UIImage(data: dataImage!)?.circleMasked
                }
                
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
