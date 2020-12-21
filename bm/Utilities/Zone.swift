//
//  Zone.swift
//  bm
//
//  Created by ives on 2020/12/21.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class Zone {
    
    static let instance = Zone()
    
    let zones: [[String: Any]] = [
        ["id": 1, "parent": 0, "name": "台北市", "zip": 100],
        ["id": 2, "parent": 1, "name": "中正區", "zip": 100],
        ["id": 3, "parent": 1, "name": "大同區", "zip": 103],
        ["id": 4, "parent": 1, "name": "中山區", "zip": 104],
        ["id": 5, "parent": 1, "name": "松山區", "zip": 105],
        ["id": 6, "parent": 1, "name": "大安區", "zip": 106],
        ["id": 7, "parent": 1, "name": "萬華區", "zip": 108],
        ["id": 8, "parent": 1, "name": "信義區", "zip": 110],
        ["id": 9, "parent": 1, "name": "士林區", "zip": 111],
        ["id": 10, "parent": 1, "name": "北投區", "zip": 112],
        ["id": 11, "parent": 1, "name": "內湖區", "zip": 114],
        ["id": 12, "parent": 1, "name": "南港區", "zip": 115],
        ["id": 13, "parent": 1, "name": "文山區", "zip": 116],
        ["id": 14, "parent": 0, "name": "新北市", "zip": 207],
        ["id": 15, "parent": 14, "name": "萬里區", "zip": 207],
        ["id": 16, "parent": 14, "name": "金山區", "zip": 208],
        ["id": 17, "parent": 14, "name": "板橋區", "zip": 220],
        ["id": 18, "parent": 14, "name": "汐止區", "zip": 221],
        ["id": 19, "parent": 14, "name": "深坑區", "zip": 222],
        ["id": 20, "parent": 14, "name": "石碇區", "zip": 223],
        ["id": 21, "parent": 14, "name": "瑞芳區", "zip": 224],
        ["id": 22, "parent": 14, "name": "平溪區", "zip": 226],
        ["id": 23, "parent": 14, "name": "雙溪區", "zip": 227],
        ["id": 24, "parent": 14, "name": "貢寮區", "zip": 228],
        ["id": 25, "parent": 14, "name": "新店區", "zip": 231],
        ["id": 26, "parent": 14, "name": "坪林區", "zip": 232],
        ["id": 27, "parent": 14, "name": "烏來區", "zip": 233],
        ["id": 28, "parent": 14, "name": "永和區", "zip": 234],
        ["id": 29, "parent": 14, "name": "中和區", "zip": 235],
        ["id": 30, "parent": 14, "name": "土城區", "zip": 236],
        ["id": 31, "parent": 14, "name": "三峽區", "zip": 237],
        ["id": 32, "parent": 14, "name": "樹林區", "zip": 238],
        ["id": 33, "parent": 14, "name": "鶯歌區", "zip": 239],
        ["id": 34, "parent": 14, "name": "三重區", "zip": 241],
        ["id": 35, "parent": 14, "name": "新莊區", "zip": 242],
        ["id": 36, "parent": 14, "name": "泰山區", "zip": 243],
        ["id": 37, "parent": 14, "name": "林口區", "zip": 244],
        ["id": 38, "parent": 14, "name": "蘆洲區", "zip": 247],
        ["id": 39, "parent": 14, "name": "五股區", "zip": 248],
        ["id": 40, "parent": 14, "name": "八里區", "zip": 249],
        ["id": 41, "parent": 14, "name": "淡水區", "zip": 251],
        ["id": 42, "parent": 14, "name": "三芝區", "zip": 252],
        ["id": 43, "parent": 14, "name": "石門區", "zip": 253],
        ["id": 44, "parent": 0, "name": "基隆市", "zip": 200],
        ["id": 45, "parent": 44, "name": "仁愛區", "zip": 200],
        ["id": 46, "parent": 44, "name": "信義區", "zip": 201],
        ["id": 47, "parent": 44, "name": "中正區", "zip": 202],
        ["id": 48, "parent": 44, "name": "中山區", "zip": 203],
        ["id": 49, "parent": 44, "name": "安樂區", "zip": 204],
        ["id": 50, "parent": 44, "name": "暖暖區", "zip": 205],
        ["id": 51, "parent": 44, "name": "七堵區", "zip": 206],
        ["id": 52, "parent": 0, "name": "桃園市", "zip": 320],
        ["id": 53, "parent": 52, "name": "中壢區", "zip": 320],
        ["id": 54, "parent": 52, "name": "平鎮區", "zip": 324],
        ["id": 55, "parent": 52, "name": "龍潭區", "zip": 325],
        ["id": 56, "parent": 52, "name": "楊梅區", "zip": 326],
        ["id": 57, "parent": 52, "name": "新屋區", "zip": 327],
        ["id": 58, "parent": 52, "name": "觀音區", "zip": 328],
        ["id": 59, "parent": 52, "name": "桃園區", "zip": 330],
        ["id": 60, "parent": 52, "name": "龜山區", "zip": 333],
        ["id": 61, "parent": 52, "name": "八德區", "zip": 334],
        ["id": 62, "parent": 52, "name": "大溪區", "zip": 335],
        ["id": 63, "parent": 52, "name": "復興區", "zip": 336],
        ["id": 64, "parent": 52, "name": "大園區", "zip": 337],
        ["id": 65, "parent": 52, "name": "蘆竹區", "zip": 338],
        ["id": 66, "parent": 0, "name": "新竹市", "zip": 300],
        ["id": 67, "parent": 66, "name": "東區", "zip": 300],
        ["id": 68, "parent": 66, "name": "北區", "zip": 300],
        ["id": 69, "parent": 66, "name": "香山區", "zip": 300],
        ["id": 70, "parent": 0, "name": "新竹縣", "zip": 302],
        ["id": 71, "parent": 70, "name": "竹北市", "zip": 302],
        ["id": 72, "parent": 70, "name": "湖口鄉", "zip": 303],
        ["id": 73, "parent": 70, "name": "新豐鄉", "zip": 304],
        ["id": 74, "parent": 70, "name": "新埔鎮", "zip": 305],
        ["id": 75, "parent": 70, "name": "關西鎮", "zip": 306],
        ["id": 76, "parent": 70, "name": "芎林鄉", "zip": 307],
        ["id": 77, "parent": 70, "name": "寶山鄉", "zip": 308],
        ["id": 78, "parent": 70, "name": "竹東鎮", "zip": 310],
        ["id": 79, "parent": 70, "name": "五峰鄉", "zip": 311],
        ["id": 80, "parent": 70, "name": "橫山鄉", "zip": 312],
        ["id": 81, "parent": 70, "name": "尖石鄉", "zip": 313],
        ["id": 82, "parent": 70, "name": "北埔鄉", "zip": 314],
        ["id": 83, "parent": 70, "name": "峨眉鄉", "zip": 315],
        ["id": 84, "parent": 0, "name": "苗栗縣", "zip": 350],
        ["id": 85, "parent": 84, "name": "竹南鎮", "zip": 350],
        ["id": 86, "parent": 84, "name": "頭份鎮", "zip": 351],
        ["id": 87, "parent": 84, "name": "三灣鄉", "zip": 352],
        ["id": 88, "parent": 84, "name": "南庄鄉", "zip": 353],
        ["id": 89, "parent": 84, "name": "獅潭鄉", "zip": 354],
        ["id": 90, "parent": 84, "name": "後龍鎮", "zip": 356],
        ["id": 91, "parent": 84, "name": "通霄鎮", "zip": 357],
        ["id": 92, "parent": 84, "name": "苑裡鎮", "zip": 358],
        ["id": 93, "parent": 84, "name": "苗栗市", "zip": 360],
        ["id": 94, "parent": 84, "name": "造橋鄉", "zip": 361],
        ["id": 95, "parent": 84, "name": "頭屋鄉", "zip": 362],
        ["id": 96, "parent": 84, "name": "公館鄉", "zip": 363],
        ["id": 97, "parent": 84, "name": "大湖鄉", "zip": 364],
        ["id": 98, "parent": 84, "name": "泰安鄉", "zip": 365],
        ["id": 99, "parent": 84, "name": "銅鑼鄉", "zip": 366],
        ["id": 100, "parent": 84, "name": "三義鄉", "zip": 367],
        ["id": 101, "parent": 84, "name": "西湖鄉", "zip": 368],
        ["id": 102, "parent": 84, "name": "卓蘭鎮", "zip": 369],
        ["id": 103, "parent": 0, "name": "台中市", "zip": 400],
        ["id": 104, "parent": 103, "name": "中區", "zip": 400],
        ["id": 105, "parent": 103, "name": "東區", "zip": 401],
        ["id": 106, "parent": 103, "name": "南區", "zip": 402],
        ["id": 107, "parent": 103, "name": "西區", "zip": 403],
        ["id": 108, "parent": 103, "name": "北區", "zip": 404],
        ["id": 109, "parent": 103, "name": "北屯區", "zip": 406],
        ["id": 110, "parent": 103, "name": "西屯區", "zip": 407],
        ["id": 111, "parent": 103, "name": "南屯區", "zip": 408],
        ["id": 113, "parent": 103, "name": "太平區", "zip": 411],
        ["id": 114, "parent": 103, "name": "大里區", "zip": 412],
        ["id": 115, "parent": 103, "name": "霧峰區", "zip": 413],
        ["id": 116, "parent": 103, "name": "烏日區", "zip": 414],
        ["id": 117, "parent": 103, "name": "豐原區", "zip": 420],
        ["id": 118, "parent": 103, "name": "后里區", "zip": 421],
        ["id": 119, "parent": 103, "name": "石岡區", "zip": 422],
        ["id": 120, "parent": 103, "name": "東勢區", "zip": 423],
        ["id": 121, "parent": 103, "name": "和平區", "zip": 424],
        ["id": 122, "parent": 103, "name": "新社區", "zip": 426],
        ["id": 123, "parent": 103, "name": "潭子區", "zip": 427],
        ["id": 124, "parent": 103, "name": "大雅區", "zip": 428],
        ["id": 125, "parent": 103, "name": "神岡區", "zip": 429],
        ["id": 126, "parent": 103, "name": "大肚區", "zip": 432],
        ["id": 127, "parent": 103, "name": "沙鹿區", "zip": 433],
        ["id": 128, "parent": 103, "name": "龍井區", "zip": 434],
        ["id": 129, "parent": 103, "name": "梧棲區", "zip": 435],
        ["id": 130, "parent": 103, "name": "清水區", "zip": 436],
        ["id": 131, "parent": 103, "name": "大甲區", "zip": 437],
        ["id": 132, "parent": 103, "name": "外埔區", "zip": 438],
        ["id": 133, "parent": 103, "name": "大安區", "zip": 439],
        ["id": 134, "parent": 0, "name": "彰化縣", "zip": 500],
        ["id": 135, "parent": 134, "name": "彰化市", "zip": 500],
        ["id": 136, "parent": 134, "name": "芬園鄉", "zip": 502],
        ["id": 137, "parent": 134, "name": "花壇鄉", "zip": 503],
        ["id": 138, "parent": 134, "name": "秀水鄉", "zip": 504],
        ["id": 139, "parent": 134, "name": "鹿港鎮", "zip": 505],
        ["id": 140, "parent": 134, "name": "福興鄉", "zip": 506],
        ["id": 141, "parent": 134, "name": "線西鄉", "zip": 507],
        ["id": 142, "parent": 134, "name": "和美鎮", "zip": 508],
        ["id": 143, "parent": 134, "name": "伸港鄉", "zip": 509],
        ["id": 144, "parent": 134, "name": "員林鎮", "zip": 510],
        ["id": 145, "parent": 134, "name": "社頭鄉", "zip": 511],
        ["id": 146, "parent": 134, "name": "永靖鄉", "zip": 512],
        ["id": 147, "parent": 134, "name": "埔心鄉", "zip": 513],
        ["id": 148, "parent": 134, "name": "溪湖鎮", "zip": 514],
        ["id": 149, "parent": 134, "name": "大村鄉", "zip": 515],
        ["id": 150, "parent": 134, "name": "埔鹽鄉", "zip": 516],
        ["id": 151, "parent": 134, "name": "田中鎮", "zip": 520],
        ["id": 152, "parent": 134, "name": "北斗鎮", "zip": 521],
        ["id": 153, "parent": 134, "name": "田尾鄉", "zip": 522],
        ["id": 154, "parent": 134, "name": "埤頭鄉", "zip": 523],
        ["id": 155, "parent": 134, "name": "溪州鄉", "zip": 524],
        ["id": 156, "parent": 134, "name": "竹塘鄉", "zip": 525],
        ["id": 157, "parent": 134, "name": "二林鎮", "zip": 526],
        ["id": 158, "parent": 134, "name": "大城鄉", "zip": 527],
        ["id": 159, "parent": 134, "name": "芳苑鄉", "zip": 528],
        ["id": 160, "parent": 134, "name": "二水鄉", "zip": 530],
        ["id": 161, "parent": 0, "name": "南投縣", "zip": 540],
        ["id": 162, "parent": 161, "name": "南投市", "zip": 540],
        ["id": 163, "parent": 161, "name": "中寮鄉", "zip": 541],
        ["id": 164, "parent": 161, "name": "草屯鎮", "zip": 542],
        ["id": 165, "parent": 161, "name": "國姓鄉", "zip": 544],
        ["id": 166, "parent": 161, "name": "埔里鎮", "zip": 545],
        ["id": 167, "parent": 161, "name": "仁愛鄉", "zip": 546],
        ["id": 168, "parent": 161, "name": "名間鄉", "zip": 551],
        ["id": 169, "parent": 161, "name": "集集鎮", "zip": 552],
        ["id": 170, "parent": 161, "name": "水里鄉", "zip": 553],
        ["id": 171, "parent": 161, "name": "魚池鄉", "zip": 555],
        ["id": 172, "parent": 161, "name": "信義鄉", "zip": 556],
        ["id": 173, "parent": 161, "name": "竹山鎮", "zip": 557],
        ["id": 174, "parent": 161, "name": "鹿谷鄉", "zip": 558],
        ["id": 175, "parent": 0, "name": "雲林縣", "zip": 630],
        ["id": 176, "parent": 175, "name": "斗南鎮", "zip": 630],
        ["id": 177, "parent": 175, "name": "大埤鄉", "zip": 631],
        ["id": 178, "parent": 175, "name": "虎尾鎮", "zip": 632],
        ["id": 179, "parent": 175, "name": "土庫鎮", "zip": 633],
        ["id": 180, "parent": 175, "name": "褒忠鄉", "zip": 634],
        ["id": 181, "parent": 175, "name": "東勢鄉", "zip": 635],
        ["id": 182, "parent": 175, "name": "台西鄉", "zip": 636],
        ["id": 183, "parent": 175, "name": "崙背鄉", "zip": 637],
        ["id": 184, "parent": 175, "name": "麥寮鄉", "zip": 638],
        ["id": 185, "parent": 175, "name": "斗六市", "zip": 640],
        ["id": 186, "parent": 175, "name": "林內鄉", "zip": 643],
        ["id": 187, "parent": 175, "name": "古坑鄉", "zip": 646],
        ["id": 188, "parent": 175, "name": "莿桐鄉", "zip": 647],
        ["id": 189, "parent": 175, "name": "西螺鎮", "zip": 648],
        ["id": 190, "parent": 175, "name": "二崙鄉", "zip": 649],
        ["id": 191, "parent": 175, "name": "北港鎮", "zip": 651],
        ["id": 192, "parent": 175, "name": "水林鄉", "zip": 652],
        ["id": 193, "parent": 175, "name": "口湖鄉", "zip": 653],
        ["id": 194, "parent": 175, "name": "四湖鄉", "zip": 654],
        ["id": 195, "parent": 175, "name": "元長鄉", "zip": 655],
        ["id": 196, "parent": 0, "name": "嘉義市", "zip": 600],
        ["id": 197, "parent": 196, "name": "東區", "zip": 600],
        ["id": 198, "parent": 196, "name": "西區", "zip": 600],
        ["id": 199, "parent": 0, "name": "嘉義縣", "zip": 602],
        ["id": 200, "parent": 199, "name": "番路鄉", "zip": 602],
        ["id": 201, "parent": 199, "name": "梅山鄉", "zip": 603],
        ["id": 202, "parent": 199, "name": "竹崎鄉", "zip": 604],
        ["id": 203, "parent": 199, "name": "阿里山鄉", "zip": 605],
        ["id": 204, "parent": 199, "name": "中埔鄉", "zip": 606],
        ["id": 205, "parent": 199, "name": "大埔鄉", "zip": 607],
        ["id": 206, "parent": 199, "name": "水上鄉", "zip": 608],
        ["id": 207, "parent": 199, "name": "鹿草鄉", "zip": 611],
        ["id": 208, "parent": 199, "name": "太保市", "zip": 612],
        ["id": 209, "parent": 199, "name": "朴子市", "zip": 613],
        ["id": 210, "parent": 199, "name": "東石鄉", "zip": 614],
        ["id": 211, "parent": 199, "name": "六腳鄉", "zip": 615],
        ["id": 212, "parent": 199, "name": "新港鄉", "zip": 616],
        ["id": 213, "parent": 199, "name": "民雄鄉", "zip": 621],
        ["id": 214, "parent": 199, "name": "大林鎮", "zip": 622],
        ["id": 215, "parent": 199, "name": "溪口鄉", "zip": 623],
        ["id": 216, "parent": 199, "name": "義竹鄉", "zip": 624],
        ["id": 217, "parent": 199, "name": "布袋鎮", "zip": 625],
        ["id": 218, "parent": 0, "name": "台南市", "zip": 700],
        ["id": 219, "parent": 218, "name": "中西區", "zip": 700],
        ["id": 220, "parent": 218, "name": "東區", "zip": 701],
        ["id": 221, "parent": 218, "name": "南區", "zip": 702],
        ["id": 222, "parent": 218, "name": "北區", "zip": 704],
        ["id": 223, "parent": 218, "name": "安平區", "zip": 708],
        ["id": 224, "parent": 218, "name": "安南區", "zip": 709],
        ["id": 226, "parent": 218, "name": "永康區", "zip": 710],
        ["id": 227, "parent": 218, "name": "歸仁區", "zip": 711],
        ["id": 228, "parent": 218, "name": "新化區", "zip": 712],
        ["id": 229, "parent": 218, "name": "左鎮區", "zip": 713],
        ["id": 230, "parent": 218, "name": "玉井區", "zip": 714],
        ["id": 231, "parent": 218, "name": "楠西區", "zip": 715],
        ["id": 232, "parent": 218, "name": "南化區", "zip": 716],
        ["id": 233, "parent": 218, "name": "仁德區", "zip": 717],
        ["id": 234, "parent": 218, "name": "關廟區", "zip": 718],
        ["id": 235, "parent": 218, "name": "龍崎區", "zip": 719],
        ["id": 236, "parent": 218, "name": "官田區", "zip": 720],
        ["id": 237, "parent": 218, "name": "麻豆區", "zip": 721],
        ["id": 238, "parent": 218, "name": "佳里區", "zip": 722],
        ["id": 239, "parent": 218, "name": "西港區", "zip": 723],
        ["id": 240, "parent": 218, "name": "七股區", "zip": 724],
        ["id": 241, "parent": 218, "name": "將軍區", "zip": 725],
        ["id": 242, "parent": 218, "name": "學甲區", "zip": 726],
        ["id": 243, "parent": 218, "name": "北門區", "zip": 727],
        ["id": 244, "parent": 218, "name": "新營區", "zip": 730],
        ["id": 245, "parent": 218, "name": "後壁區", "zip": 731],
        ["id": 246, "parent": 218, "name": "白河區", "zip": 732],
        ["id": 247, "parent": 218, "name": "東山區", "zip": 733],
        ["id": 248, "parent": 218, "name": "六甲區", "zip": 734],
        ["id": 249, "parent": 218, "name": "下營區", "zip": 735],
        ["id": 250, "parent": 218, "name": "柳營區", "zip": 736],
        ["id": 251, "parent": 218, "name": "鹽水區", "zip": 737],
        ["id": 252, "parent": 218, "name": "善化區", "zip": 741],
        ["id": 253, "parent": 218, "name": "大內區", "zip": 742],
        ["id": 254, "parent": 218, "name": "山上區", "zip": 743],
        ["id": 255, "parent": 218, "name": "新市區", "zip": 744],
        ["id": 256, "parent": 218, "name": "安定區", "zip": 745],
        ["id": 257, "parent": 0, "name": "高雄市", "zip": 800],
        ["id": 258, "parent": 257, "name": "新興區", "zip": 800],
        ["id": 259, "parent": 257, "name": "前金區", "zip": 801],
        ["id": 260, "parent": 257, "name": "苓雅區", "zip": 802],
        ["id": 261, "parent": 257, "name": "鹽埕區", "zip": 803],
        ["id": 262, "parent": 257, "name": "鼓山區", "zip": 804],
        ["id": 263, "parent": 257, "name": "旗津區", "zip": 805],
        ["id": 264, "parent": 257, "name": "前鎮區", "zip": 806],
        ["id": 265, "parent": 257, "name": "三民區", "zip": 807],
        ["id": 266, "parent": 257, "name": "楠梓區", "zip": 811],
        ["id": 267, "parent": 257, "name": "小港區", "zip": 812],
        ["id": 268, "parent": 257, "name": "左營區", "zip": 813],
        ["id": 270, "parent": 257, "name": "仁武區", "zip": 814],
        ["id": 271, "parent": 257, "name": "大社區", "zip": 815],
        ["id": 272, "parent": 257, "name": "岡山區", "zip": 820],
        ["id": 273, "parent": 257, "name": "路竹區", "zip": 821],
        ["id": 274, "parent": 257, "name": "阿蓮區", "zip": 822],
        ["id": 275, "parent": 257, "name": "田寮區", "zip": 823],
        ["id": 276, "parent": 257, "name": "燕巢區", "zip": 824],
        ["id": 277, "parent": 257, "name": "橋頭區", "zip": 825],
        ["id": 278, "parent": 257, "name": "梓官區", "zip": 826],
        ["id": 279, "parent": 257, "name": "彌陀區", "zip": 827],
        ["id": 280, "parent": 257, "name": "永安區", "zip": 828],
        ["id": 281, "parent": 257, "name": "湖內區", "zip": 829],
        ["id": 282, "parent": 257, "name": "鳳山區", "zip": 830],
        ["id": 283, "parent": 257, "name": "大寮區", "zip": 831],
        ["id": 284, "parent": 257, "name": "林園區", "zip": 832],
        ["id": 285, "parent": 257, "name": "鳥松區", "zip": 833],
        ["id": 286, "parent": 257, "name": "大樹區", "zip": 840],
        ["id": 287, "parent": 257, "name": "旗山區", "zip": 842],
        ["id": 288, "parent": 257, "name": "美濃區", "zip": 843],
        ["id": 289, "parent": 257, "name": "六龜區", "zip": 844],
        ["id": 290, "parent": 257, "name": "內門區", "zip": 845],
        ["id": 291, "parent": 257, "name": "杉林區", "zip": 846],
        ["id": 292, "parent": 257, "name": "甲仙區", "zip": 847],
        ["id": 293, "parent": 257, "name": "桃源區", "zip": 848],
        ["id": 294, "parent": 257, "name": "那瑪夏區", "zip": 849],
        ["id": 295, "parent": 257, "name": "茂林區", "zip": 851],
        ["id": 296, "parent": 257, "name": "茄萣區", "zip": 852],
        ["id": 297, "parent": 0, "name": "屏東縣", "zip": 900],
        ["id": 298, "parent": 297, "name": "屏東市", "zip": 900],
        ["id": 299, "parent": 297, "name": "三地門鄉", "zip": 901],
        ["id": 300, "parent": 297, "name": "霧台鄉", "zip": 902],
        ["id": 301, "parent": 297, "name": "瑪家鄉", "zip": 903],
        ["id": 302, "parent": 297, "name": "九如鄉", "zip": 904],
        ["id": 303, "parent": 297, "name": "里港鄉", "zip": 905],
        ["id": 304, "parent": 297, "name": "高樹鄉", "zip": 906],
        ["id": 305, "parent": 297, "name": "鹽埔鄉", "zip": 907],
        ["id": 306, "parent": 297, "name": "長治鄉", "zip": 908],
        ["id": 307, "parent": 297, "name": "麟洛鄉", "zip": 909],
        ["id": 308, "parent": 297, "name": "竹田鄉", "zip": 911],
        ["id": 309, "parent": 297, "name": "內埔鄉", "zip": 912],
        ["id": 310, "parent": 297, "name": "萬丹鄉", "zip": 913],
        ["id": 311, "parent": 297, "name": "潮州鎮", "zip": 920],
        ["id": 312, "parent": 297, "name": "泰武鄉", "zip": 921],
        ["id": 313, "parent": 297, "name": "來義鄉", "zip": 922],
        ["id": 314, "parent": 297, "name": "萬巒鄉", "zip": 923],
        ["id": 315, "parent": 297, "name": "崁頂鄉", "zip": 924],
        ["id": 316, "parent": 297, "name": "新埤鄉", "zip": 925],
        ["id": 317, "parent": 297, "name": "南州鄉", "zip": 926],
        ["id": 318, "parent": 297, "name": "林邊鄉", "zip": 927],
        ["id": 319, "parent": 297, "name": "東港鎮", "zip": 928],
        ["id": 320, "parent": 297, "name": "琉球鄉", "zip": 929],
        ["id": 321, "parent": 297, "name": "佳冬鄉", "zip": 931],
        ["id": 322, "parent": 297, "name": "新園鄉", "zip": 932],
        ["id": 323, "parent": 297, "name": "枋寮鄉", "zip": 940],
        ["id": 324, "parent": 297, "name": "枋山鄉", "zip": 941],
        ["id": 325, "parent": 297, "name": "春日鄉", "zip": 942],
        ["id": 326, "parent": 297, "name": "獅子鄉", "zip": 943],
        ["id": 327, "parent": 297, "name": "車城鄉", "zip": 944],
        ["id": 328, "parent": 297, "name": "牡丹鄉", "zip": 945],
        ["id": 329, "parent": 297, "name": "恆春鎮", "zip": 946],
        ["id": 330, "parent": 297, "name": "滿洲鄉", "zip": 947],
        ["id": 331, "parent": 0, "name": "台東縣", "zip": 950],
        ["id": 332, "parent": 331, "name": "台東市", "zip": 950],
        ["id": 333, "parent": 331, "name": "綠島鄉", "zip": 951],
        ["id": 334, "parent": 331, "name": "蘭嶼鄉", "zip": 952],
        ["id": 335, "parent": 331, "name": "延平鄉", "zip": 953],
        ["id": 336, "parent": 331, "name": "卑南鄉", "zip": 954],
        ["id": 337, "parent": 331, "name": "鹿野鄉", "zip": 955],
        ["id": 338, "parent": 331, "name": "關山鎮", "zip": 956],
        ["id": 339, "parent": 331, "name": "海端鄉", "zip": 957],
        ["id": 340, "parent": 331, "name": "池上鄉", "zip": 958],
        ["id": 341, "parent": 331, "name": "東河鄉", "zip": 959],
        ["id": 342, "parent": 331, "name": "成功鎮", "zip": 961],
        ["id": 343, "parent": 331, "name": "長濱鄉", "zip": 962],
        ["id": 344, "parent": 331, "name": "太麻里鄉", "zip": 963],
        ["id": 345, "parent": 331, "name": "金峰鄉", "zip": 964],
        ["id": 346, "parent": 331, "name": "大武鄉", "zip": 965],
        ["id": 347, "parent": 331, "name": "達仁鄉", "zip": 966],
        ["id": 348, "parent": 0, "name": "花蓮縣", "zip": 970],
        ["id": 349, "parent": 348, "name": "花蓮市", "zip": 970],
        ["id": 350, "parent": 348, "name": "新城鄉", "zip": 971],
        ["id": 351, "parent": 348, "name": "秀林鄉", "zip": 972],
        ["id": 352, "parent": 348, "name": "吉安鄉", "zip": 973],
        ["id": 353, "parent": 348, "name": "壽豐鄉", "zip": 974],
        ["id": 354, "parent": 348, "name": "鳳林鎮", "zip": 975],
        ["id": 355, "parent": 348, "name": "光復鄉", "zip": 976],
        ["id": 356, "parent": 348, "name": "豐濱鄉", "zip": 977],
        ["id": 357, "parent": 348, "name": "瑞穗鄉", "zip": 978],
        ["id": 358, "parent": 348, "name": "萬榮鄉", "zip": 979],
        ["id": 359, "parent": 348, "name": "玉里鎮", "zip": 981],
        ["id": 360, "parent": 348, "name": "卓溪鄉", "zip": 982],
        ["id": 361, "parent": 348, "name": "富里鄉", "zip": 983],
        ["id": 362, "parent": 0, "name": "宜蘭縣", "zip": 260],
        ["id": 363, "parent": 362, "name": "宜蘭市", "zip": 260],
        ["id": 364, "parent": 362, "name": "頭城鎮", "zip": 261],
        ["id": 365, "parent": 362, "name": "礁溪鄉", "zip": 262],
        ["id": 366, "parent": 362, "name": "壯圍鄉", "zip": 263],
        ["id": 367, "parent": 362, "name": "員山鄉", "zip": 264],
        ["id": 368, "parent": 362, "name": "羅東鎮", "zip": 265],
        ["id": 369, "parent": 362, "name": "三星鄉", "zip": 266],
        ["id": 370, "parent": 362, "name": "大同鄉", "zip": 267],
        ["id": 371, "parent": 362, "name": "五結鄉", "zip": 268],
        ["id": 372, "parent": 362, "name": "冬山鄉", "zip": 269],
        ["id": 373, "parent": 362, "name": "蘇澳鎮", "zip": 270],
        ["id": 374, "parent": 362, "name": "南澳鄉", "zip": 272],
        ["id": 375, "parent": 0, "name": "澎湖縣", "zip": 880],
        ["id": 376, "parent": 375, "name": "馬公市", "zip": 880],
        ["id": 377, "parent": 375, "name": "西嶼鄉", "zip": 881],
        ["id": 378, "parent": 375, "name": "望安鄉", "zip": 882],
        ["id": 379, "parent": 375, "name": "七美鄉", "zip": 883],
        ["id": 380, "parent": 375, "name": "白沙鄉", "zip": 884],
        ["id": 381, "parent": 375, "name": "湖西鄉", "zip": 885],
        ["id": 382, "parent": 0, "name": "金門縣", "zip": 890],
        ["id": 383, "parent": 382, "name": "金沙鎮", "zip": 890],
        ["id": 384, "parent": 382, "name": "金湖鎮", "zip": 891],
        ["id": 385, "parent": 382, "name": "金寧鄉", "zip": 892],
        ["id": 386, "parent": 382, "name": "金城鎮", "zip": 893],
        ["id": 387, "parent": 382, "name": "烈嶼鄉", "zip": 894],
        ["id": 388, "parent": 382, "name": "烏坵鄉", "zip": 896],
        ["id": 389, "parent": 0, "name": "連江縣", "zip": 209],
        ["id": 390, "parent": 389, "name": "南竿鄉", "zip": 209],
        ["id": 391, "parent": 389, "name": "北竿鄉", "zip": 210],
        ["id": 392, "parent": 389, "name": "莒光鄉", "zip": 211],
        ["id": 393, "parent": 389, "name": "東引鄉", "zip": 212],
        ["id": 395, "parent": 0, "name": "全省", "zip": 0]
    ]
}
