//
//  AppointmentsViewController.swift
//  Assignment
//
//  Created by Power on 07/05/2021.
//  Copyright © 2021 Abdullah Shahid. All rights reserved.
//

import UIKit

class AppointmentsViewController: UIViewController {
    
    var upcomingData : [UpcomingModel] = []
    var historyData : [HistoryModel] = []
    var allData : [AllModel] = []
    
    
    let upcomingUrl = URL(string: "http://staging.virtualmdcanada.com:8000/api/v1/app/appointments/upcoming?date=2020-06-14T00:00:00.000Z&offset=0&limit=10")
    let historyUrl = URL(string:"http://staging.virtualmdcanada.com:8000/api/v1/app/appointments/history?date=2020-06-11&offset=0&limit=10&from=&to=")
    let allUrl = URL(string: "http://staging.virtualmdcanada.com:8000/api/v1/app/appointments?status=&from=&to=&limit=10&offset=0")
    
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        segmentView.selectedSegmentIndex = 0
        upcomingData = [
            UpcomingModel(name: "Abdullah Shahid", image: #imageLiteral(resourceName: "avatar"), date: "10-10-2021", time: "11:00", status: "Schedueled"),
        UpcomingModel(name: "Adil Shafiq", image: #imageLiteral(resourceName: "avatar"), date: "20-7-2021", time: "08:00", status: "Schedueled"),
        UpcomingModel(name: "Asad Shafiq", image: #imageLiteral(resourceName: "avatar"), date: "29-8-2022", time: "16:00", status: "Schedueled"),
        UpcomingModel(name: "Ali Imran Shafiq Mushtaq", image: #imageLiteral(resourceName: "avatar"), date: "10-12-2021", time: "11:00", status: "Schedueled")
        ]
        historyData = [
        HistoryModel(name: "Abdullah Shahid", image: #imageLiteral(resourceName: "avatar"), date: "10-10-2020", time: "11:00", status: "Completed"),
        HistoryModel(name: "Adil Shafiq", image: #imageLiteral(resourceName: "avatar"), date: "20-7-2020", time: "08:00", status: "Cancelled"),
        HistoryModel(name: "Asad Shafiq", image: #imageLiteral(resourceName: "avatar"), date: "29-8-2020", time: "16:00", status: "Cancelled"),
        HistoryModel(name: "Ali Imran Shafiq Mushtaq", image: #imageLiteral(resourceName: "avatar"), date: "10-12-2020", time: "11:00", status: "Schedueled")
        ]
        allData = [
        AllModel(name: "Abdullah Shahid", image: #imageLiteral(resourceName: "avatar"), date: "10-10-2021", time: "11:00", status: "Completed"),
        AllModel(name: "Adil Shafiq", image: #imageLiteral(resourceName: "avatar"), date: "20-7-2021", time: "08:00", status: "Schedueled"),
        AllModel(name: "Asad Shafiq", image: #imageLiteral(resourceName: "avatar"), date: "29-8-2022", time: "16:00", status: "Schedueled"),
        AllModel(name: "Ali Imran Shafiq Mushtaq", image: #imageLiteral(resourceName: "avatar"), date: "10-12-2021", time: "11:00", status: "Schedueled"),
        AllModel(name: "Abdullah Shahid", image: #imageLiteral(resourceName: "avatar"), date: "10-10-2020", time: "11:00", status: "Completed"),
        AllModel(name: "Adil Shafiq", image: #imageLiteral(resourceName: "avatar"), date: "20-7-2020", time: "08:00", status: "Cancelled"),
        AllModel(name: "Asad Shafiq", image: #imageLiteral(resourceName: "avatar"), date: "29-8-2020", time: "16:00", status: "Cancelled"),
        AllModel(name: "Ali Imran Shafiq Mushtaq", image: #imageLiteral(resourceName: "avatar"), date: "10-12-2020", time: "11:00", status: "Schedueled")
        ]
        
//        print(savedToken!)
        getData(url: upcomingUrl!)
//        if UserDefaults.standard.object(forKey: "savedToken") != nil{
//            let savedToken = UserDefaults.standard.object(forKey: "savedToken")
//        print(savedToken!)
//        }
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
    }
    
    @IBAction func segmentButtonClicked(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
}
extension AppointmentsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var value = 0
        switch segmentView.selectedSegmentIndex {
        case 0:
            value = upcomingData.count
            break
        case 1:
            value = historyData.count
            break
        case 2:
            value = allData.count
            break
        default:
            
            break
        }
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //return
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        switch segmentView.selectedSegmentIndex {
        case 0:
            cell.nameLabel.text = upcomingData[indexPath.row].name
            cell.myImageView.image = upcomingData[indexPath.row].image
            cell.dateLabel.text = upcomingData[indexPath.row].date
            cell.timeLabel.text = upcomingData[indexPath.row].time
            cell.statusLabel.text = upcomingData[indexPath.row].status
        case 1:
            cell.nameLabel.text = historyData[indexPath.row].name
            cell.myImageView.image = historyData[indexPath.row].image
            cell.dateLabel.text = historyData[indexPath.row].date
            cell.timeLabel.text = historyData[indexPath.row].time
            cell.statusLabel.text = historyData[indexPath.row].status
        case 2:
            cell.nameLabel.text = allData[indexPath.row].name
            cell.myImageView.image = allData[indexPath.row].image
            cell.dateLabel.text = allData[indexPath.row].date
            cell.timeLabel.text = allData[indexPath.row].time
            cell.statusLabel.text = allData[indexPath.row].status
        default:
            break
        }
        
        return cell
    }

    func getData(url: URL){
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        var savedToken = UserDefaults.standard.object(forKey: "savedToken")
        savedToken = "Bearer " + "\(savedToken ?? "")"
        //print(savedToken!)
        request.setValue(savedToken as? String, forHTTPHeaderField: "Authorization")

        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }
            print(data)
            //print(response)
           do {
              //create json object from data
              if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                 print(json)
              }
           } catch let error {
             print(error.localizedDescription)
           }
        })

        task.resume()

    }
    
}

struct GetAppointments : Codable {
    var body : Appointments
    var staus : StatusBody
}

struct StatusBody : Codable{
    var code : Int
    var message : String
}

struct Appointments : Codable {
    var appointments : [AppointmentsBody]
    
}
struct AppointmentsBody: Codable {
    var image : URL
    var name : String
    var date : String
    var time : String
    var status : String
}
