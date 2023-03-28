//
//  ListLocalidadesTableViewCell.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 27/03/23.
//

import UIKit

class ListLocalidadesTableViewCell: UITableViewCell {

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
