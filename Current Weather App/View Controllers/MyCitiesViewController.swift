//
//  MyCitiesViewController.swift
//  Current Weather App
//
//  Created by Ruslan Ismayilov on 2/25/22.
//

import UIKit
import GooglePlaces
import CoreData

class MyCitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    Properties
    let userDefaults = UserDefaults()
    var dataController : DataController!
    var networkWeatherClient = NetworkWeatherClient()
    var myCities : MyCities!
    var fetchedResultsController : NSFetchedResultsController<MyCities>!
    
//    Outlets
    @IBOutlet weak var myCitiesTableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addCityBarButton: UIBarButtonItem!
    
//    Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        myCitiesTableView.delegate = self
        myCitiesTableView.dataSource = self
        if let indexPath = myCitiesTableView.indexPathForSelectedRow {
            myCitiesTableView.deselectRow(at: indexPath, animated: false)
            myCitiesTableView.reloadRows(at: [indexPath], with: .fade)
            
        }
        
       setUpFetchResultController()
        myCitiesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        setUpFetchResultController()
        myCitiesTableView.reloadData()
    }
    @IBAction func addCityPressed(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
           autocompleteController.delegate = self
        
            // Specify the place data types to return.
           let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                        UInt(GMSPlaceField.placeID.rawValue))
            autocompleteController.placeFields = fields

            // Specify a filter.
            let filter = GMSAutocompleteFilter()
            filter.type = .city
            autocompleteController.autocompleteFilter = filter
        
        


        let appDelegate = UIApplication.shared.delegate as! AppDelegate
           // Display the autocomplete view controller.
           present(autocompleteController, animated: true, completion: nil)
        self.networkWeatherClient.onCompletion = {[weak self]currentWeather in
            print(currentWeather.cityName)
            guard let self = self else {return}
            try? appDelegate.dataController.viewContext.save()
          
            
        
        }
        
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if myCitiesTableView.isEditing{
            myCitiesTableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addCityBarButton.isEnabled = true
        } else {
            myCitiesTableView.setEditing(true, animated: true)
            sender.title = "Done"
            addCityBarButton.isEnabled = false
        }
    }
    
    
  
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = fetchedResultsController.sections {
            return sections.count
        } else {
            return 1
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

         return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let aCity = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCitiesCell", for: indexPath) as! MyCitiesCell
        cell.textLabel?.text = aCity.cityName
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        try? appDelegate.dataController.viewContext.save()
        
        return cell
        
    }
    
    /// Deletes the notebook at the specified index path
    func deleteCities(at indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let cityToDelete = fetchedResultsController.object(at: indexPath)
        appDelegate.dataController.viewContext.delete(cityToDelete)
        try? appDelegate.dataController.viewContext.save()
    
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        myCitiesTableView.setEditing(editing, animated: animated)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteCities(at: indexPath)
        default: () // Unsupported
        }
    }
    
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let itemToMove = fetchedResultsController.object(at: sourceIndexPath)
//        guard var items = fetchedResultsController.fetchedObjects else {return}
//        items.remove(at: sourceIndexPath.row)
//        items.insert(itemToMove, at: destinationIndexPath.row)
//
//
//        try? appDelegate.dataController.viewContext.save()
//
//

//
//    }

    
    func setUpFetchResultController(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest : NSFetchRequest<MyCities> = MyCities.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch  {
            fatalError("The fetch could not be performed\(error.localizedDescription)")
        }
        fetchedResultsController.delegate = self

    }

    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? LocationDetailViewController{
            if let indexPath = myCitiesTableView.indexPathForSelectedRow{
                vc.myCities = fetchedResultsController.object(at: indexPath)
                vc.dataController = dataController

            }
        }
    }
}

extension MyCitiesViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        myCitiesTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        myCitiesTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            myCitiesTableView.insertRows(at: [newIndexPath!], with: .fade)
           
        case .delete:
            myCitiesTableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
               myCitiesTableView.reloadRows(at: [indexPath!], with: .fade)
           case .move:
               myCitiesTableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: myCitiesTableView.insertSections(indexSet, with: .fade)
        case .delete: myCitiesTableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        @unknown default:
            fatalError()
        }
    }
}
