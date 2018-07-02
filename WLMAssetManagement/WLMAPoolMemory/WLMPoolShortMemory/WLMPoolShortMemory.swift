//
//  WLMPoolShortMemory.swift
//  Playing Offline HLS
//
//  Created by Beach Partner LLC on 11/6/17.
//  Copyright © 2017 Beach Partner LLC. All rights reserved.
//

import Foundation
import AVFoundation
class WLMPoolShortMemory {
    
    struct WLMShortMemoryCell {
        let order:Int
        let asset:AVURLAsset
        init(asset:AVURLAsset,order:Int) {
            self.order = order
            self.asset = asset
        }
    }
    
    let maxCells = 20
    
    lazy private var cells = [URL:WLMShortMemoryCell]()
    
    func add(_ asset:AVURLAsset) {
       let order = self.getOrderForNewCell()
       let newCell = WLMShortMemoryCell(asset: asset, order: order)
        if let orginalUrl = asset.url.removeWlmScheme() {
          self.cells[orginalUrl] = newCell
          self.handelOverFlow()
        }
    }
    
    func removeAsset(withUrl url:URL) {
        self.cells[url] = nil
    }
    
    func freeUp(){
        self.cells.removeAll()
    }
    
    func getAsset(forUrl url:URL) -> AVURLAsset? {
        guard let cell = self.cells[url] else {
            return nil
        }
        return cell.asset
    }
    
    private func getOrderForNewCell() -> Int {
        return self.cellsInOrder().count
    }
    
    private func handelOverFlow() {
        if  self.cells.keys.count >= maxCells {
            let orderdResult =  cellsInOrder()
            guard let removingPath = orderdResult.first?.0 else {
                return
            }
            self.cells.removeValue(forKey: removingPath)
        }
    }
    
    private func cellsInOrder() -> [(URL,WLMShortMemoryCell)] {
        return  self.cells.sorted(by: { (first, second) -> Bool in
            let firstCellOrder  =  first.value.order
            let secondCellOrder =  second.value.order
            if firstCellOrder < secondCellOrder {
                return true
            }else {
                return false
            }
        })
    }
}
