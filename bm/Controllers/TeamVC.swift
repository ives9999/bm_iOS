//
//  TeamVC.swift
//  bm
//
//  Created by ives on 2017/10/3.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import Device_swift

class TeamVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var teamCV: UICollectionView!
    var frameWidth: CGFloat!
    var frameHeight: CGFloat!
    var deviceType: DeviceType!
    private(set) public var teams: [Team] = [Team]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        frameWidth = view.bounds.size.width
        frameHeight = view.bounds.size.height
        
        deviceType = Global.instance.deviceType(frameWidth: frameWidth!)
        
        teamCV.delegate = self
        teamCV.dataSource = self
        
        DataService.instance.getTeam { (success) in
            if success {
                self.teams = DataService.instance.teams
                //print(self.teams)
                self.teamCV.reloadData()
            }
            Global.instance.removeSpinner()
            Global.instance.removeProgressLbl()
        }
        Global.instance.addSpinner(center: self.view.center, superView: teamCV)
        Global.instance.addProgressLbl(center: self.view.center, superView: teamCV)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //print(frameWidth)
        let cellCount: Int = deviceType == .iPhone7 ? IPHONE_CELL_ON_ROW : IPAD_CELL_ON_ROW
        let cellWidth: CGFloat = (frameWidth! / CGFloat(cellCount)) - CGFloat(CELL_EDGE_MARGIN*2)
        //let cellWidth: CGFloat = (frameWidth! / CGFloat(cellCount))
        //let cellHeight:CGFloat = CGFloat(deviceType == .iPhone7 ? (TITLE_HEIGHT+FEATURED_HEIGHT+CELL_EDGE_MARGIN) : (TITLE_HEIGHT+FEATURED_HEIGHT*2+CELL_EDGE_MARGIN))
        let cellHeight: CGFloat = cellWidth * 0.75
        let size = CGSize(width: cellWidth, height: cellHeight)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return teams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let team = teams[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as? TeamCell {
            cell.updateViews(team: team)
                
            return cell
        }
        return HomeImageCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let team: Team = teams[indexPath.row]
        performSegue(withIdentifier: "TeamShowSegue", sender: team)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let showVC: ShowVC = segue.destination as? ShowVC {
            assert(sender as? Team != nil)
            let team: Team = sender as! Team
            let show_in: Show_IN = Show_IN(type: "team", id: team.id, token: team.token)
            showVC.initShowVC(sin: show_in)
        }
    }
}
