//
//  DetailViewController.swift
//  AmityTodoTechTask
//
//  Created by Kamran TNK on 10/11/20.
//  Copyright © 2020 Amity. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var detailTextView: UITextView!
    
    //MARK:- Variables and constants
    var todoDetailsVM = ToDoDetailViewModel()
    
    //MARK:- Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeBasicView(todoDetailVM: todoDetailsVM)
    }
    
    //MARK:- Custom methods
    private func initializeBasicView(todoDetailVM : ToDoDetailViewModel) {
        if let imageUrl = todoDetailsVM.todoRecord?.avatar {
            userImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "userPlaceHolder.png"))
        } else {
            userImageView.image = UIImage(named: "userPlaceHolder.png")
        }
        
        titleLabel.text = todoDetailsVM.todoRecord?.title
        dateLabel.text = todoDetailsVM.todoRecord?.createdAt
        detailTextView.text = todoDetailsVM.todoRecord?.title?.description
    }
}
