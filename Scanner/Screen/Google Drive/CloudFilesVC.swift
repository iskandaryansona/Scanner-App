//
//  CloudFilesVC.swift
//  Scanner
//
//  Created by Sona on 18.01.24.
//

import UIKit
import GoogleAPIClientForREST
import SVPullToRefresh
import GTMSessionFetcher



class CloudFilesVC: UIViewController {

    @IBOutlet weak var tableViewFiles: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    //MARK:- VARIABLES
    
    internal var arrFiles = [GTLRDrive_File]()
    internal let service = GTLRDriveService()
    internal var token: String?

    //MARK:- PREDEFINED
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialise()
    }
    
    private func initialise() {
        let nib = UINib(nibName: "CloudFileTableCell", bundle: nil)
        tableViewFiles.register(nib, forCellReuseIdentifier: "CloudFileTableCell")
        tableViewFiles.addInfiniteScrolling {
            self.tableViewFiles.showsPullToRefresh = false
            self.fetchFromDrive()
        }
        fetchFromDrive()
    }
    
    func fetchFromDrive(_ strSearchText: String = "") {
        let drive = CloudFilesManager(service)
        drive.listAllFiles(strSearchText, token: token) { [weak self] (files, pageToken, error) in
            if let arrFiles = files {
                pageToken != nil ? (self?.arrFiles += arrFiles) :  (self?.arrFiles = arrFiles)
                self?.token = pageToken
                self?.tableViewFiles.reloadData()
            } else {
                Alert.show(message: error?.localizedDescription ?? "")
            }
            self?.tableViewFiles.showsInfiniteScrolling = self?.token == nil ? false : true // disable infinite scrolling if the limit has been reached
            self?.tableViewFiles.infiniteScrollingView.stopAnimating()
        }
    }

}

extension CloudFilesVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return arrFiles.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "CloudFileTableCell") as? CloudFileTableCell else { return UITableViewCell()}
         cell.configureCell(arrFiles[indexPath.row])
         return cell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
         let vc = EditViewController()
        
         if arrFiles[indexPath.row].hasThumbnail == true {
             vc.imgLink = arrFiles[indexPath.row].thumbnailLink
         } else {
             vc.imgLink = arrFiles[indexPath.row].iconLink
         }
         vc.name = arrFiles[indexPath.row].name ?? "File"
         self.navigationController?.popViewController(animated: true)
         self.navigationController?.pushViewController(vc, animated: true)

    }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
     }
     
     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         return 80
     }
    
    //MARK:- SEARCH BAR DELEGATE
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        token = nil
        fetchFromDrive(searchBar.text ?? "")
        searchBar.endEditing(true)
    }

}
