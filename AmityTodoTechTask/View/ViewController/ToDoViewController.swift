//
//  ToDoViewController.swift
//  AmityTodoTechTask
//
//  Created by Kamran TNK on 10/11/20.
//  Copyright © 2020 Amity. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet var todoTableView: UITableView!
    @IBOutlet var mesaageLabel: UILabel!
    
    //MARK:- Variables and constants
    lazy var searchBar = UISearchBar(frame: CGRect(x: 10, y: 5, width: 0, height: 30))
    var todoVM = ToDoViewModel()
    
    //MARK:- Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeBasicView()
    }
    
    //MARK:- Custom methods
    private func initializeBasicView() {
        //Initialise delegate and datasource
        todoTableView.delegate = self
        todoTableView.dataSource = self
        
        //Initialise tableview cell
        todoTableView.register(UINib(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "ToDoCell")
        
        //Manage seperator height
        todoTableView.sectionHeaderHeight = 2.0
        
        //Add search box in navigation bar
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        //Read jsaon file from viewmodel
        todoVM.saveJSONFile()
        
        //Loose coupling from view to view model
        todoVM.todoVC = self
    }
}

//MARK:- UitableView delegate and datasource methods
extension ToDoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return todoVM.filteredTodoList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let seperatorView = UIView()
        seperatorView.backgroundColor = .black
        return seperatorView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell") as? ToDoCell
        
        if cell == nil {
         todoTableView.register(UINib(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "ToDoCell")
        }
        todoVM.todoRecord = todoVM.filteredTodoList[indexPath.section]
        cell?.setupTodoRecordWithData(todoVM: todoVM)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todoVM.didTapItemToNavigateDetails(selectedIndex: indexPath.section)
    }
}


//MARK:- UitableView delegate and datasource methods
extension ToDoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        todoVM.serachTodoItemByTitle(searchBar: searchBar, searchText: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.searchBar.endEditing(true)
    }
}
