//
//  MenuTableVC.swift
//  bm
//
//  Created by ives on 2017/11/5.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class MenuTableVC: UITableViewController {

    @IBOutlet weak var accountCell: UITableViewCell!
    @IBOutlet weak var accountIcon: UIImageView!
    @IBOutlet weak var accountLbl: UILabel!
    @IBOutlet weak var passwordCell: UITableViewCell!
    @IBOutlet weak var passwordIcon: UIImageView!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var mobileValidateCell: UITableViewCell!
    @IBOutlet weak var mobileValidateIcon: UIImageView!
    @IBOutlet weak var mobileValidateLbl: UILabel!
    @IBOutlet weak var teamSubmitCell: UITableViewCell!
    @IBOutlet weak var teamSubmitIcon: UIImageView!
    @IBOutlet weak var teamSubmitLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupCell(cell: accountCell, icon: accountIcon, text: accountLbl)
        _setupCell(cell: passwordCell, icon: passwordIcon, text: passwordLbl)
        _setupCell(cell: mobileValidateCell, icon: mobileValidateIcon, text: mobileValidateLbl)
        _setupCell(cell: teamSubmitCell, icon: teamSubmitIcon, text: teamSubmitLbl)
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //view.tintColor = UIColor.red
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        let titleLbl: UILabel = header.textLabel!
        titleLbl.textColor = UIColor.white
        titleLbl.font = UIFont(name: FONT_NAME, size: FONT_SIZE_TITLE)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                print("account")
            default:
                print("default row")
            }
        default:
            print("default section")
        }
    }
    
    private func _setupCell(cell: UITableViewCell, icon: UIImageView, text: UILabel) {
        let staticCell = STATICCELL()
        let cellheight: CGFloat = cell.bounds.height
        let accountIconHeight: CGFloat = cellheight - staticCell.padding * 2
        
        icon.frame = CGRect(x: staticCell.xMargin, y: staticCell.padding, width: accountIconHeight, height: accountIconHeight)
        text.frame.origin = CGPoint(x: icon.frame.origin.x+accountIconHeight+staticCell.padding, y: staticCell.padding)
    }


    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        let n: Int = tableView.numberOfSections
        return n
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cellForRow(at: indexPath)
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell

        let height = cell?.bounds.height
        print(height)

        return cell!
    }
 */
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
