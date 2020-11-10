//
//  ToDoCell.swift
//  AmityTodoTechTask
//
//  Created by Kamran TNK on 10/11/20.
//  Copyright © 2020 Amity. All rights reserved.
//

import UIKit
import SDWebImage

class ToDoCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    
    //MARK:- View lifecycle method
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK:- Custome setup method to init with viewModel
    func setupTodoRecordWithData(todoVM : ToDoViewModel) {
        if let imageUrl = todoVM.todoRecord?.avatar {
            userImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "userPlaceHolder.png"))
        } else {
            userImageView.image = UIImage(named: "userPlaceHolder.png")
        }
        titleLabel.text = todoVM.todoRecord?.title
        dateLabel.text = todoVM.todoRecord?.createdAt
    }
}
