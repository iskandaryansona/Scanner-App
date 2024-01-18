//
//  HistoryVC.swift
//  Scanner
//
//  Created by Sona on 25.12.23.
//

import UIKit
import CoreData

class HistoryVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchField: UITextField!
    
    var currentData = [SavedFiles]()
    
    private var models = [SavedFiles]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: HistoryCell.nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: HistoryCell.id)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = UIColor(red: 123/255, green: 155/255, blue: 190/255, alpha: 1).cgColor
        searchView.layer.cornerRadius = 14
        
//        getAllFolders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllFolders()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        if searchField.text == "" {
            currentData = models
        } else {
            currentData = searchInCoreData(for: searchField.text!)!
        }
        collectionView.reloadData()
    }
    
    func searchInCoreData(for searchText: String) -> [SavedFiles]? {
        let fetchRequest: NSFetchRequest<SavedFiles> = SavedFiles.fetchRequest()

        // Create a predicate to filter entities that contain the search text
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        fetchRequest.predicate = predicate

        do {
            // Perform the fetch request
            let searchResults = try context.fetch(fetchRequest)
            return searchResults
        } catch {
            print("Error fetching from Core Data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getAllFolders() {
        do {
            models = try context.fetch(SavedFiles.fetchRequest())
            currentData = models
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            if models.count > 0 {
//                addFirstImageView.isHidden = true
            } else {
//                addFirstImageView.isHidden = false
            }
        }
        catch {
            
        }
    }
    
}

extension HistoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCell.id, for: indexPath) as! HistoryCell
        cell.nameLabel.text = currentData[currentData.count - 1 - indexPath.row].name ?? "Untitled"
        cell.dateLabel.text = currentData[currentData.count - 1 - indexPath.row].date
        cell.thumb.image = UIImage(data: currentData[currentData.count - 1 - indexPath.row].thumb!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HistoryCell
        let vc = EditViewController()
        let a = cell.thumb.image
        vc.img = a
        vc.name = cell.nameLabel.text!
        vc.isFromHistory = true
        vc.currentItem = currentData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
