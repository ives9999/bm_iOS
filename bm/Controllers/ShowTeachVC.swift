//
//  ShowTeachVC.swift
//  bm
//
//  Created by ives sun on 2021/7/1.
//  Copyright © 2021 bm. All rights reserved.
//

import WebKit
//import youtube_ios_player_helper
import YouTubePlayer

class ShowTeachVC: ShowVC {
    
    //@IBOutlet weak var webViewContainer: UIView!
    //@IBOutlet weak var youtube: YTPlayerView!
    @IBOutlet weak var youtube: YouTubePlayerView!
    @IBOutlet weak var playVideo: SubmitButton!
    
    var myTable: TeachTable?
    //var webView: WKWebView!
    
    override func viewDidLoad() {
        
        dataService = TeachService.instance
        
        super.viewDidLoad()
        
        youtube.delegate = self
        //youtube.cueVideo(byId: "uTYodversoM", startSeconds: 0)
        //youtube.load(withVideoId: "uTYodversoM", playerVars: ["playsinline": "1" as AnyObject])
        //youtube.playVideo()
        //youtube.loadVideoID("uTYodversoM")
        //youtube.play()
        youtube.playerVars = [
            "controls": "1" as AnyObject,
            "playsinline": "1" as AnyObject
        ] as YouTubePlayerView.YouTubePlayerParameters
        
        playVideo.setTitle("播放影片")
        
        if (token != nil) {

//            let webConfiguation = WKWebViewConfiguration()
//            webView = WKWebView(frame: webViewContainer.frame, configuration: webConfiguation)
//            webView.uiDelegate = self
//            webViewContainer.addSubview(webView)

            tableRowKeys = ["pv","created_at_show"]
            tableRows = [
                "pv":["icon":"pv","title":"瀏覽數","content":""],
                "created_at_show":["icon":"calendar","title":"建立日期","content":""]
            ]

            refresh(TeachTable.self)
        }
    }
    
    override func viewWillLayoutSubviews() {
        mainDataLbl.text = "主要資料"
        contentDataLbl.text = "詳細介紹"

        mainDataLbl.setTextTitle()
        contentDataLbl.setTextTitle()
    }
    
    override func setData() {

        if (table != nil) {
            myTable = table as? TeachTable
            if (myTable != nil) {
                myTable!.filterRow()

                setMainData(myTable!)
                tableView.reloadData()
            }
        }
    }

    override func setFeatured() {

        if (myTable != nil && myTable!.youtube.count > 0) {
            youtube.loadVideoID(myTable!.youtube)
            //youtube.delegate = self
//            youtube.load(withVideoId: "lRW6CYfhei0", playerVars: ["playsinline": "1"])
//            youtube.playVideo()
            //let url = "https://www.youtube.com/embed/" + myTable!.youtube
            //let myRequest = URLRequest(url: URL(string: url)!)
            //webView.load(myRequest)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return tableRowKeys.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == self.tableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell

            //填入資料
            let key = tableRowKeys[indexPath.row]
            if tableRows[key] != nil {
                let row = tableRows[key]!
                let icon = row["icon"] ?? ""
                let title = row["title"] ?? ""
                let content = row["content"] ?? ""
                cell.update(icon: icon, title: title, content: content)
            }

            //計算高度
            if indexPath.row == tableRowKeys.count - 1 {
                UIView.animate(withDuration: 0, animations: {self.tableView.layoutIfNeeded()}) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    let cells = self.tableView.visibleCells
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    //print(heightOfTableView)
                    self.tableViewConstraintHeight.constant = heightOfTableView
                    self.changeScrollViewContentSize()
                }
            }
            return cell
        }
        return UITableViewCell()
    }

    override func changeScrollViewContentSize() {

        let h1 = youtube.bounds.size.height
        let h2 = mainDataLbl.bounds.size.height
        let h3 = tableViewConstraintHeight.constant
        let h6 = contentDataLbl.bounds.size.height
        let h7 = contentViewConstraintHeight!.constant

        //print(contentViewConstraintHeight)

        //let h: CGFloat = h1 + h2 + h3 + h4 + h5
        let h: CGFloat = h1 + h2 + h3 + h6 + h7 + 300
        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
        ContainerViewConstraintHeight.constant = h
        //print(h1)
    }
    
    @IBAction func playVideo(_ sender: Any) {
        toYoutubePlayer(token: myTable!.youtube)
    }
}

extension ShowTeachVC: YouTubePlayerDelegate {
    
//    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
//        switch (state) {
//        case .unstarted:
//              print("Started playback")
//              break;
//        case .paused:
//              print("Paused playback")
//              break;
//            default:
//              break;
//          }
//    }
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        //print("Player Ready!")
        //videoPlayer.loadVideoID("uTYodversoM")
        videoPlayer.play()
    }

    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        //print("Player state changed!")
    }
}

