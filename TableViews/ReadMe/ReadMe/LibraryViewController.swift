//
//  ViewController.swift
//  ReadMe
//
//  Created by TakHyun Jung on 2020/11/27.
//

import UIKit

class LibraryHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "\(LibraryHeaderView.self)"
    @IBOutlet var titleLabel: UILabel!
}

class LibraryViewController: UITableViewController {
    enum Section: String, CaseIterable {
        case addNew
        case readMe = "Read ME!"
        case finished = "Finished!"
    }
    var dataSource: UITableViewDiffableDataSource<Section, Book>!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the
        tableView.register(UINib(nibName: "\(LibraryHeaderView.self)", bundle: nil), forHeaderFooterViewReuseIdentifier: LibraryHeaderView.reuseIdentifier)
        
        configureDataSource()
        updateDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.reloadData()
        updateDataSource()
    }
    
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
        guard let indePath = tableView.indexPathForSelectedRow, let book = dataSource.itemIdentifier(for: indePath) else {
            fatalError("nothing seletcted")}
        
        return DetailViewController(coder: coder, book: book)
    }
    
    // MARK:- Delegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Read Me!" : nil
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: LibraryHeaderView.reuseIdentifier) as? LibraryHeaderView else { return nil }
        
        headerView.titleLabel.text = Section.allCases[section].rawValue
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section != 0 ? 60 : 0
    }
    
    
    // MARK:- DataSource
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, book -> UITableViewCell? in
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewBookCell", for: indexPath)
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BookCell.self)", for: indexPath) as? BookCell else { fatalError("counld not create bookcell") }
            cell.titleLabel?.text = book.title
            cell.authorLabel.text = book.author
            cell.bookThumbnail?.image = book.image ?? LibrarySymbol.letterSquare(letter: book.title.first).image
            if let review = book.review {
                cell.reviewLabel.text = review
                cell.reviewLabel.isHidden = false
            }
            cell.readMeBookMark.isHidden = !book.readMe
            cell.bookThumbnail.layer.cornerRadius = 12
            return cell
        }
    }
    
    // Make SnapShot
    func updateDataSource() {
        var newSnapSHot = NSDiffableDataSourceSnapshot<Section, Book>()
        newSnapSHot.appendSections(Section.allCases)
        //newSnapSHot.appendItems(Library.books, toSection: .readMe)
        let booksByReadMe: [Bool:[Book]] = Dictionary(grouping: Library.books, by: \.readMe)
        for (readMe, books) in booksByReadMe {
            newSnapSHot.appendItems(books,toSection: readMe ? .readMe : .finished)
        }
        newSnapSHot.appendItems([Book.mockBook], toSection: .addNew)
        dataSource.apply(newSnapSHot,animatingDifferences: true)
    }
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        return 2
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return section == 0 ? 1 : Library.books.count
    //    }
    //
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        if indexPath.row == 0 {
    //            let cell = tableView.dequeueReusableCell(withIdentifier: "NewBookCell", for: indexPath)
    //            return cell
    //        }
    //        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BookCell.self)", for: indexPath) as? BookCell else { fatalError("counld not create bookcell") }
    //
    //        let book = Library.books[indexPath.row]
    //        cell.titleLabel?.text = book.title
    //        cell.authorLabel.text = book.author
    //        cell.bookThumbnail?.image = book.image
    //        cell.bookThumbnail.layer.cornerRadius = 12
    //        return cell
    //    }
    
}

