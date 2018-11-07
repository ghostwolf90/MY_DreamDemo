//
//  MYAcceptListView.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/11/7.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit

class MYAcceptListView: UITableView,UITableViewDelegate,UITableViewDataSource,MYEasyAudioPlayerDelegate {
    
    
    private var data = Array<MYMessageModel>()
    private var playName : String?
    private var lastRow : Int = 0
    let cellID = "MYMessageCellID"
    

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
        separatorStyle = .none
        backgroundColor = MYColorForRGB(239, 243, 246)
        tableFooterView = UIView()
        register(MYMessageTableViewCell.self, forCellReuseIdentifier: cellID)
        MYEasyAduioPlayer.shared.delegate = self
    }
    
    public func addTextMessage(_ attribute: NSAttributedString) {
        let model = MYMessageModel()
        model.attribute = attribute;
        model.source = Int(arc4random()%2) - 1
        model.calculate()
        data.append(model)
        rollBottom()
    }
    
    public func addVoiceBlankMessag(_ name: String) {
        print(name)
        let model = MYMessageModel()
        model.isVoice = true
        model.time = 0
        model.name = name
        model.source = 1
        model.calculate()
        data.append(model)
        rollBottom()
    }
    
    public func cancelVoiceMessage(_ name: String) {
        let temp = self.data.filter { (model) -> Bool in
            if model.name == name {
                return false
            }
            return true
        }
        self.data = temp
        rollBottom()
    }
    
    public func addVoiceMessage(path: String, time: Int, name: String) {
        print(name)
        for model in self.data {
            if model.name == name {
                model.isVoice = true
                model.path = path;
                model.time = time
                model.name = name
                model.source = 1
                model.calculate()
                break
            }
            
        }
        
        rollBottom()
    }
    
    private func rollBottom() {
        DispatchQueue.main.async {
            self.reloadData()
            let rowCount = self.numberOfRows(inSection: 0)
            if rowCount > 1 {
                let indexPath = IndexPath(row: rowCount - 1, section: 0)
                self.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MYMessageTableViewCell
        let model = self.data[indexPath.row]
        separatorStyle = .none
        cell.updataFrame(model)
        if model.name == self.playName {
            cell.playAnimation()
        }
        cell.handle = {[weak self] in
            self?.playVoiceWithRow(indexPath.row)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.data[indexPath.row]
        return model.frame.maxY + 15
    }
    
    // MARK: - 播放器代理
    
    func changeStatus(_ status: MYAudioPlayerStatus) {
        if status == .finish || status == .stop {
            
            self.playName = nil
            let lastPath = IndexPath.init(row: self.lastRow, section: 0)
            let cell = cellForRow(at: lastPath) as! MYMessageTableViewCell
            if cell.isPlaying {
                cell.stopAnimation()
            }
        }
    }
    
    private func playVoiceWithRow(_ index: Int) {
        if self.lastRow != index {
            let lastPath = IndexPath.init(row: self.lastRow, section: 0)
            let cell = cellForRow(at: lastPath) as! MYMessageTableViewCell
            if cell.isPlaying {
                cell.stopAnimation()
            }
        }
        let model = self.data[index]
        let currentPath = IndexPath.init(row: index, section: 0)
        let cell = cellForRow(at: currentPath) as! MYMessageTableViewCell
        if cell.isPlaying {
            MYEasyAduioPlayer.shared.stop()
            cell.stopAnimation()
        }else{
            self.playName = model.name
            cell.playAnimation()
            MYEasyAduioPlayer.shared.play(with: URL.init(fileURLWithPath: model.path))
        }
        self.lastRow = index
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
