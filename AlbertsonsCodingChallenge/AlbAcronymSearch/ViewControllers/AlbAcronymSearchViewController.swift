//
//  AlbertsonsCodingChallengeTests.swift
//  AlbertsonsCodingChallengeTests
//
//  Created by Vijay on 11/22/22.
//


import UIKit

class AlbAcronymSearchViewController: UIViewController {

    @IBOutlet weak var tblAcronymList : UITableView!
    @IBOutlet weak var progressBar : UIActivityIndicatorView!
    
    let acronymVM = AlbAcronymViewModel()
    let sc = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = AlB_ACN_TITLE
        self.showSearchbar()
    }
    private func showSearchbar() {
        sc.searchBar.delegate = self
        if #available(iOS 13.0, *) {
            if let textfield = sc.searchBar.value(forKey: "searchTextField") as? UITextField {
                textfield.placeholder = "Search Acronym here"
                if let backgroundview = textfield.subviews.first {
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }
        } else {
            sc.searchBar.tintColor = .white
            if let textfield = sc.searchBar.value(forKey: "Search Acronym here") as? UITextField {
                textfield.placeholder = "Search Acronym here"
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            }
        }
        sc.searchBar.layoutIfNeeded()
        sc.searchBar.layoutSubviews()
        navigationItem.searchController = sc
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func handleError(_ error : WebError<CustomError>) {
        
        switch error {
        
        case .noInternetConnection:
            AlbUtility.showErrorAlert(with: MSG_NO_INTERNET, controller: self)
            
        case .custom(let error):
            AlbUtility.showErrorAlert(with: error.message, controller: self)
           
        case .unauthorized:
            AlbUtility.showErrorAlert(with: MSG_UNAUTHORIZED, controller: self)
           
        case .other:
            AlbUtility.showErrorAlert(with:MSG_OTHER, controller: self)
        }
    }
    func validateSpaceInTextField(searchText:String) -> Bool{
        let characterSet:NSCharacterSet = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        
        if searchText.contains(" ") {
            return false
        }
        if searchText.rangeOfCharacter(from: characterSet.inverted) != nil {
           return false
        }
        return true
    }
}



extension AlbAcronymSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // make api call
        acronymVM.longFormList?.removeAll()
        self.tblAcronymList.reloadData()
        
        progressBar.isHidden = false
        if validateSpaceInTextField(searchText: searchBar.text ?? "") {
            if let acronym = searchBar.text {
                
                acronymVM.fetchAcronymListWithName(acronym) { [weak self](response) in
                    self?.progressBar.isHidden = true
                    
                    switch(response){
                    case .success(_):
                        if self?.acronymVM.albAcrList?.count ?? 0 > 0 {
                            self?.tblAcronymList.reloadData()
                        }
                    case .failure(_):
                        if let error = response.error {
                            self?.handleError(error)
                        }
                    }
                    }
            }
        } else {
            progressBar.isHidden = true
            AlbUtility.showErrorAlert(with: MSG_EMPTY_FIELD, controller: self)
           
        }
       
    }
}

extension AlbAcronymSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {

            var numOfSections: Int = 0
            if acronymVM.longFormList?.count ?? 0 > 0
            {
                tableView.separatorStyle = .singleLine
                numOfSections            = 1
                tableView.backgroundView = nil
            }
            else
            {
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "No data available"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
            }
            return numOfSections

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acronymVM.longFormList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbAcronymListCell", for: indexPath) as! AlbAcronymListTableViewCell
        let longForData = acronymVM.longFormList?[indexPath.row]
        cell.setAcronyData(longForData)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = mainStoryBoard.instantiateViewController(withIdentifier: "AlbAcronymDetailVC") as! AlbAcronymDetailViewController
        if let selectedLF = acronymVM.longFormList?[indexPath.row]{
            detailVC.slectedLF = selectedLF
        }
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
