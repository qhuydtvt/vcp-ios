//
//  BannerCollectionViewCell.swift
//  Lok App
//
//  Created by Vũ Kiên on 15/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.masksToBounds = true
    }
}
