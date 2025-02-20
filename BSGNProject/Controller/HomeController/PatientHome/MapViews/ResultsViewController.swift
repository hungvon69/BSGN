//
//  ResultsViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 4/11/24.
//

import UIKit
import CoreLocation
protocol ResultsViewControllerDelegate: AnyObject {
    func didSelectPlace(with coordinates: CLLocationCoordinate2D)
}

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: ResultsViewControllerDelegate?
    
    let resultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    private var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(resultsTableView)
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resultsTableView.frame = view.bounds
    }
    
    public func update(with places: [Place]) {
        self.places = places
        self.resultsTableView.isHidden = false
        resultsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        resultsTableView.deselectRow(at: indexPath, animated: true)
        
        resultsTableView.isHidden = true
        
        let place = places[indexPath.row]
        GooglePlacesManager.shared.resolveLocation(for: place) { results in
            switch results {
            case .success(let location):
                DispatchQueue.main.async {
                    self.delegate?.didSelectPlace(with: location)
                }
            
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    


}
