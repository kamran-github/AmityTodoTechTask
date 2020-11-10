//
//  ToDoViewModel.swift
//  AmityTodoTechTask
//
//  Created by Kamran TNK on 10/11/20.
//  Copyright © 2020 Amity. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper


class ToDoViewModel : NSObject {
    //MARK:- Variables and constants
    var todoList = [Todo]()
    var filteredTodoList = [Todo]()
    var todoRecord : Todo?
    weak var todoVC : ToDoViewController?
    var finalString = ""
    
    //MARK:- Custom methods to check, create, read and write jsonfile
    //Check json file existence
    func checkFileExistance(_ fileName : String) -> Bool {
        let documentDirectory = getDocumentDirectoryPath()
        let originPath = documentDirectory.appendingPathComponent(fileName)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: originPath.path) {
            return true
        } else {
            return false
        }
    }
    
    //Save jsonfile after writing data from webURL
    func saveJSONFile() -> Void {
        if checkFileExistance("Todo.json") {
            readJsonFromFile(self.getDocumentDirectoryPath().appendingPathComponent("Todo.json"))
        } else {
            webRequestForUser()
        }
    }
    
    //Get document directory and where the file is saved
    func getDocumentDirectoryPath() -> URL {
        let fileManager = FileManager.default
        var documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        documentDirectoryURL = documentDirectoryURL.appendingPathComponent("JSONFile", isDirectory: true)
        if !fileManager.fileExists(atPath: documentDirectoryURL.path) {
            do {
                try fileManager.createDirectory(atPath: documentDirectoryURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error")
            }
        }
        return documentDirectoryURL
    }

    
    //Read Json from the save json file and map to the model
    func readJsonFromFile(_ filePath : URL) {
        var todoList : TodoModel?
        let string = try! String(contentsOf: filePath, encoding: .utf8)
        let data = string.data(using: .utf8)!
        do {
            let jsonValue = try? JSONSerialization.jsonObject(with: data, options: [])
            todoList = Mapper<TodoModel>().map(JSONObject: jsonValue)
            guard let todoList = todoList else{ return }
            createTodoSortedModelWithUserAvatar(todoModel: todoList)
        } catch  {
            debugPrint("Error in reading json file")
        }
    }
    
   
    //MARK:- Sort model array by date, add user avatar according to the user todo
    private func createTodoSortedModelWithUserAvatar(todoModel :TodoModel) {
        todoList = todoModel.todo!
        for index in 0..<todoModel.user!.count {
            for subIndex in 0..<todoModel.todo!.count {
                if todoModel.user![index].id == todoModel.todo![subIndex].userId {
                    todoList[subIndex].avatar = todoModel.user![index].avatar
                }
            }
        }
        var convertedArray = [Todo]()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let labelDF = DateFormatter()
        labelDF.dateFormat = "yyyy-MM-dd hh:mm a"
        for object in todoList {
            let date = formatter.date(from: object.createdAt!)
            let formattedDateStr = labelDF.string(from: date ?? Date())
            if let date = date {
                let obj = Todo(JSON: ["title" : object.title ?? "N/A", "description" : object.description ?? "N/A", "createdAt" : formattedDateStr, "c_date" : date, "avatar" : object.avatar ?? "N/A",])!
                convertedArray.append(obj)
            }
        }
        todoList = convertedArray.sorted(by: { $0.c_date!.compare($1.c_date!) == .orderedDescending })
        filteredTodoList = todoList
        DispatchQueue.main.async {
            self.todoVC?.todoTableView.isHidden = false
            self.todoVC?.mesaageLabel.isHidden = true
            self.todoVC?.todoTableView.reloadData()
        }
    }
    
    //MARK:- Navigate to detail view of selected todo
    func didTapItemToNavigateDetails(selectedIndex : Int) {
        let mainStoryBorad = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = mainStoryBorad.instantiateViewController(identifier: "DetailViewController") as DetailViewController
        detailVC.todoDetailsVM.todoRecord = filteredTodoList[selectedIndex]
        todoVC?.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK:- Search operation by title in todo list
    func serachTodoItemByTitle(searchBar : UISearchBar, searchText :String) {
        guard !searchText.isEmpty  else {
            filteredTodoList = todoList
            DispatchQueue.main.async {
                self.todoVC?.todoTableView.reloadData()
            }
            return
        }
        filteredTodoList = todoList.filter({ todoItem -> Bool in
            guard let searchString = searchBar.text else {
                return false
            }
            return todoItem.title!.lowercased().contains(searchString.lowercased())
        })
        DispatchQueue.main.async{
            self.todoVC?.todoTableView.reloadData()
        }
    }
}

extension ToDoViewModel {
    //MARK:- Hit web URL to get json and write to the file
    fileprivate func webRequestForUser()  {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let stateURL = Endpoint.jsonURL
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: [:], url: stateURL, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json else {
                    return
                }
                if jsonValue.count<Const.sizeLimit  {
                    let json = String(data: jsonValue, encoding: String.Encoding.utf8)
                    self.finalString = json ?? ""
                    let DocumentDirURL = self.getDocumentDirectoryPath()
                    let fileURL = DocumentDirURL.appendingPathComponent("Todo").appendingPathExtension("json")
                    do {
                        try self.finalString.write(to: fileURL, atomically: true, encoding: .utf8)
                        self.saveJSONFile()
                    }
                    catch {
                        print("Error in save the file")
                    }
                } else {
                    self.todoVC?.mesaageLabel.text = Const.limitMsg
                }
            })
        }else{
        }
    }
}
