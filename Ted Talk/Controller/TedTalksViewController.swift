//
//  TedTalksViewController.swift
//  Ted Talk
//
//  Created by Ignacio Cervino on 15/11/2021.
//

import UIKit

class TedTalksViewController: UIViewController {
    
    @IBOutlet weak var tedTalksTableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tedTalksActivityIndicator: UIActivityIndicatorView!
    
    var tedtalks: [TedTalk]? = [] {
        didSet {
            self.tedTalksTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tedTalksActivityIndicator.startAnimating()
        TedTalksManager().retrieve() {
            [weak self] result in
            DispatchQueue.main.async {
                self?.tedTalksActivityIndicator.stopAnimating()
                switch result {
                case .success(let tedtalks):
                    self?.tedtalks = tedtalks
                    self?.errorLabel.isHidden = true
                case .failure(let error):
                    switch error {
                    case .fileNotFound:
                        self?.errorLabel.text = "File not found"
                    case .decodingProblem(let problem):
                        self?.errorLabel.text = "There was a problem decoding the data: \(problem)"
                    default:
                        self?.errorLabel.text = "There was a problem"
                    }
                    self?.errorLabel.isHidden = false
                    self?.tedtalks = []
                }
            }
        }
        
        tedTalksTableView.dataSource = self
        tedTalksTableView.delegate = self
    }
}

extension TedTalksViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tedtalks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "tedTalkCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = "\(getYearPublished(indexPath: indexPath)) - \(tedtalks![indexPath.row].name)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegue(withIdentifier: "tedTalkSegue", sender: self)
    }
    
    private func getYearPublished(indexPath: IndexPath) -> Int {
        let teddate = NSDate(timeIntervalSince1970: tedtalks![indexPath.row].publishedDate)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: teddate as Date)
        return year
    }
}

extension TedTalksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "tedTalkSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "tedTalkSegue") {
            if let destination = segue.destination as? TedTalkDetailViewController {
                destination.tedtalk = tedtalks?[(tedTalksTableView.indexPathForSelectedRow?.row)!]
            }
        }
    }
}
