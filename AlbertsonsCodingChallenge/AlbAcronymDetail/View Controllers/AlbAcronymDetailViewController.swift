//
//  AlbertsonsCodingChallengeTests.swift
//  AlbertsonsCodingChallengeTests
//
//  Created by Vijay on 11/22/22.
//


import UIKit

class AlbAcronymDetailViewController: UIViewController {
    
    @IBOutlet weak var tblAcronymList: UITableView!
    @IBOutlet weak var lblSelectedLF: UILabel!
    
    var slectedLF: LF?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = AlB_ACN_TITLE
        lblSelectedLF.text = slectedLF?.lf
    }
}
extension AlbAcronymDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slectedLF?.vars?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbAcronymListCell", for: indexPath) as! AlbAcronymListTableViewCell
        let longForData = slectedLF?.vars?[indexPath.row]
        cell.setAcronyData(longForData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
