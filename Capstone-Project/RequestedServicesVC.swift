//
//  RequestedServicesVC.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 8/9/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class RequestedServicesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, RequestServiceCellDelegate, ServicesVCDelegate{
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var requestNumberLabel: UILabel!
    
    //MARK: Variables
    let defaults = UserDefaults.standard
    var isFirstTimeTransform = true
    var cellWidth: CGFloat!
    var cellHeight: CGFloat!
    let ANIMATION_SPEED = 0.25
    let TRANSFORM_CELL_VALUE = CGAffineTransform(scaleX: 0.8, y: 0.8)
    let CellID = "RequestedServiceCell"
    var data = [0,1,2,3,4,5,6,7,8,9]
    var noRequestLabel: UILabel!
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        //TODO: make this related to the backend request. do this after populating the array with objects from the backend
        if data.isEmpty {
            noRequestsSetup()
        }else {
            requestNumberLabel.isHidden = false
            requestNumberLabel.text = "\(1) of \(data.count)"
        }
        myRequests()
        
    }
    //MARK: Functions
    func setup() {
        if let vc = parent as? ServicesVC {
            vc.delegate = self
        }
        setupCollectionView()
    }
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: "RequestedServiceCell", bundle: nil), forCellWithReuseIdentifier: CellID)
    }
    //MARK: UICollectionView delegate funciton
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath) as! RequestedServiceCell
        cell.delegate = self
        cell.requestNumberLabel.text = "Request #\(data[indexPath.row])"

        if indexPath.row == 0 && isFirstTimeTransform { //prevent to load scaling transform on the first cell for the first time only
            isFirstTimeTransform = false
        }else {
            cell.transform = TRANSFORM_CELL_VALUE
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        //setting cell width and height
        cellWidth = collectionView.frame.size.width-100
        //cellHeight = collectionView.frame.size.height - collectionView.frame.size.height/4
        cellHeight = collectionView.frame.size.height - 100
        return CGSize(width: cellWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth: Float = Float(cellWidth+30) //pageWidth = cellWidth + spacing(spacing set in the storyboard)
        let currentOffset: Float = Float(scrollView.contentOffset.x)
        print(currentOffset)
        let targetOffset:Float = Float(targetContentOffset.pointee.x)
        var newTargetOffset: Float = 0
        
        if targetOffset > currentOffset {
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth + 10 //10 is the min spacing
        }else {
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth + 10 //10 is the min spacing
        }
        
        if newTargetOffset < 0 {
            newTargetOffset = Float(0) //to keep first cell in place and not to scroll beyond it
        }else if newTargetOffset > Float(scrollView.contentSize.width) {
            newTargetOffset = Float(scrollView.contentSize.width) //to keep last cell in place and not to scroll beyond it
        }
        
        targetContentOffset.pointee.x = CGFloat(currentOffset)
        scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: 0), animated: true)
        
        var index = Int(newTargetOffset/pageWidth)
        requestNumberLabel.text = "\(index+1) of \(data.count)"
        if index == 0{
            var cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? RequestedServiceCell
            //TODO: subclass UIButton to add index property instead of using tag property
            cell?.acceptButton.tag = index
            cell?.declineButton.tag = index
            UIView.animate(withDuration: ANIMATION_SPEED, animations: {
                cell?.transform = CGAffineTransform.identity
            })
            
            cell = collectionView.cellForItem(at: IndexPath(item: index+1, section: 0)) as? RequestedServiceCell
            UIView.animate(withDuration: ANIMATION_SPEED, animations: {
                cell?.transform = self.TRANSFORM_CELL_VALUE
            })
        }else {
            var cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? RequestedServiceCell
            cell?.acceptButton.tag = index
            cell?.declineButton.tag = index
            UIView.animate(withDuration: ANIMATION_SPEED, animations: {
                cell?.transform = CGAffineTransform.identity
            })
            
            index = index - 1
            cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? RequestedServiceCell
            UIView.animate(withDuration: ANIMATION_SPEED, animations: {
                cell?.transform = self.TRANSFORM_CELL_VALUE
            })
            
            index = index + 2
            cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? RequestedServiceCell
            UIView.animate(withDuration: ANIMATION_SPEED, animations: {
                cell?.transform = self.TRANSFORM_CELL_VALUE
            })
        }
        
    }
    
    //MARK: RequestedServiceCell Delegate
    func acceptButtonTapped(_ cell: RequestedServiceCell) {
        
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want to accept this request?", preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Accept", style: .destructive) { (UIAlertAction) in
            guard let indexPath = self.collectionView.indexPath(for: cell) else {
                // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
                return
            }
            self.data.remove(at: indexPath.row)
            self.collectionView.deleteItems(at: [indexPath])
            
            self.collectionView.reloadData()
            
            print("Accept Button tapped on row \(indexPath.row)")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlerAction) in
            print("do nothing")
        }
        alertController.addAction(acceptAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    func declineButtonTapped(_ cell: RequestedServiceCell) {
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want to decline this service?", preferredStyle: .alert)
        let declineAction = UIAlertAction(title: "Decline", style: .destructive) { (UIAlertAction) in
            guard let indexPath = self.collectionView.indexPath(for: cell) else {
                // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
                return
            }
            self.data.remove(at: indexPath.row)
            self.collectionView.deleteItems(at: [indexPath])
            
            self.collectionView.reloadData()
            
            print("Accept Button tapped on row \(indexPath.row)")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            print("do nothing")
        }
        
        alertController.addAction(declineAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    func noRequestsSetup() {
        requestNumberLabel.isHidden = true
        noRequestLabel = UILabel()
        noRequestLabel.translatesAutoresizingMaskIntoConstraints = false
        noRequestLabel.text = "Currently you don't have any requests"
        noRequestLabel.textColor = UIColor.darkText
        self.view.addSubview(noRequestLabel)
        noRequestLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noRequestLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    //MARK: ServiceVC Delegate
    func didRefresh() {
        //TODO: backend request
        data = [11,1111,111,11,11]
        collectionView.reloadData()
        if !data.isEmpty {
            isFirstTimeTransform = true
            requestNumberLabel.isHidden = false
            noRequestLabel.isHidden = true
            requestNumberLabel.text = "\(1) of \(data.count)"
        }
    }
    func alertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    //MARK: BACKEND
    func myRequests() {
        //TODO: add loading animation only for the first time.
        let URL = "\(AppDelegate.URL)/provider/requests/"
        if let myToken = defaults.object(forKey: "userToken") as? String{
            let headers = [
                "Authorization": myToken
            ]
            print(myToken)
            Alamofire.request(URL, method: .get, parameters: nil, headers: headers).responseJSON(completionHandler: { (response) in
                print("request")
                print(response.request!)  // original URL request
                print("response")
                print(response.response!) // URL response
                print("data")
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print(json!)
                }
                print("result")
                print(response.result)   // result of response serialization
                if let myResponse = response.response {
                    if myResponse.statusCode == 200 {
                        if let json = response.result.value {
                            print(json)
//                            self.offeredServices = JSON(json)
//                            self.jsonIntoArrayOfObjects()
//                            self.refreshControl.endRefreshing()
//                            self.tableView.reloadData()
                        }
                    }else {
                        self.alertWithMessage("There was a problem getting offered services\n please try again")
                        //self.refreshControl.endRefreshing()
                    }
                }else {
                    self.alertWithMessage("There was a problem getting offered services\n please try again")
                    //self.refreshControl.endRefreshing()
                }
            
            })
        }
        
    }
    
}
