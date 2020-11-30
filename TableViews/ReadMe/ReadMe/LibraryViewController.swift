//
//  ViewController.swift
//  ReadMe
//
//  Created by TakHyun Jung on 2020/11/27.
//

import UIKit

class LibraryViewController: UITableViewController {

    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
        guard let indePath = tableView.indexPathForSelectedRow else { fatalError("nothing seletcted")}
        let book = Library.books[indePath.row - 1]

        return DetailViewController(coder: coder, book: book)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK:- DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Library.books.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewBookCell", for: indexPath)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BookCell.self)", for: indexPath) as? BookCell else { fatalError("counld not create bookcell") }
        
        let book = Library.books[indexPath.row - 1]
        cell.titleLabel?.text = book.title
        cell.authorLabel.text = book.author
        cell.bookThumbnail?.image = book.image
        cell.bookThumbnail.layer.cornerRadius = 12
        return cell
    }
    
}

