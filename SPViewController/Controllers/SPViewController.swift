//
//  SPViewController.swift
//  AppSearchablePicker
//
//  Created by Pawan on 23/07/19.
//  Copyright © 2019 VDB. All rights reserved.
//

import UIKit

public enum Style {
	case plain
	case detail
}

public struct EmptyMessage{
	
	public var title: String
	public var message: String
	
	public init(title: String, message: String) {
		self.title = title
		self.message = message
	}
}

public typealias DoneBlock 	= (SPItem?) -> Void
public typealias CancelBlock 	= () -> Void
public var frameworkBundle = Bundle(identifier: "com.pawan.SPViewController")

public class SPViewController: UIViewController {
	
	// MARK: Blocks
	public var doneBlock: DoneBlock?
	private var cancelBlock: CancelBlock?

	// MARK: Outlets
	@IBOutlet private weak var searchBar: UISearchBar!
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet weak var navBar: UINavigationBar!
	
	// MARK: Variables
	private var rows: [SPItem] = []
	private var filteredRows: [SPItem] = []
	private var style: Style = .plain
	private var pickerTitle: String?
	private var selectedItem: SPItem?
	private var isSearching = false
	private var emptyMessage: EmptyMessage?
	private var initialSelection: String?
	
	public override func viewDidLoad() {
        super.viewDidLoad()
		configureTableView()
		configureCell()
		configureInitialSelection()
    }
	
	//MARK: Public methods
	public static func show(title: String,
							rows: [SPItem],
							style: Style,
							sourceView: UIView,
							doneBlock: @escaping DoneBlock,
							cancelBlock: @escaping CancelBlock,
							presenter: UIViewController,
							emptyMessge: EmptyMessage? = nil,
							initialSelection: String? = nil) {
		let spViewController = SPViewController(nibName: "SPViewController", bundle: frameworkBundle).initPicker(title: title,
																	rows: rows,
																	style: style,
																	sourceView: sourceView,
																	doneBlock: doneBlock,
																	cancelBlock: cancelBlock,
																	presenter: 	presenter,
																	emptyMessge: emptyMessge,
																	initialSelection: initialSelection)
		presenter.present(spViewController, animated: true, completion: nil)
	}
	
	private func initPicker(title: String,
							rows: [SPItem],
							style: Style,
							sourceView: UIView,
							doneBlock: @escaping DoneBlock,
							cancelBlock: @escaping CancelBlock,
							presenter: UIViewController,
							emptyMessge: EmptyMessage? = nil,
							initialSelection: String? = nil) -> SPViewController {
		// Title
		self.pickerTitle = title
		
		// Set data
		self.rows = rows
		
		// Style
		self.style = style
		
		// Block
		self.doneBlock = doneBlock
		self.cancelBlock = cancelBlock
		
		// Model Style & Present
		self.modalPresentationStyle = .formSheet
		self.popoverPresentationController?.sourceView = sourceView
		
		// Empty Message
		self.emptyMessage = emptyMessge
		
		// Initial selection
		self.initialSelection = initialSelection
		
		// Keyboard hide notification
		NotificationCenter.default.addObserver(self,
											   selector: #selector(SPViewController.keyboardDidHide(notification:)),
											   name: UIResponder.keyboardWillHideNotification,
											   object: nil)
		
		return self
	}
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navBar.topItem?.title = pickerTitle
	}
	
	// MARK: Configure Table View
	
	private func configureTableView() {
		tableView.tableFooterView = UIView()
	}
	
	// MARK: Configure Cell
	
	private func configureCell() {
		// Register cell
		switch self.style {
		case .plain:
			tableView.register(UINib(nibName: SPTextTableViewCell.identifier,
									 bundle: frameworkBundle),
							   forCellReuseIdentifier: SPTextTableViewCell.identifier)
		case .detail:
			tableView.register(UINib(nibName: SPDetailTableViewCell.identifier,
									 bundle: frameworkBundle),
							   forCellReuseIdentifier: SPDetailTableViewCell.identifier)
		}
	}
	
	// MARK: Done after selection
	@IBAction func doneAction(_ sender: Any) {
		if let doneBlock = doneBlock {
			doneBlock(self.selectedItem)
			dismiss(animated: true, completion: nil)
		}
	}
	
	// MARK: Cancel without selection
	@IBAction func cancelAction(_ sender: Any) {
		if let cancelBlock = cancelBlock {
			cancelBlock()
			dismiss(animated: true, completion: nil)
		}
	}
	
	// MARK: Filter and Update Picker
	
	private func reload() {
		tableView.reloadData()
		tableView.layoutIfNeeded()
	}
	
	private func filterPickerDataForInput(_ text: String) {
		filteredRows = rows.filter { item -> Bool in
			return item.title.lowercased().contains(text.lowercased())
		}
	}
	
	// MARK: Show Selection
	private func scrollToCheckMarkedIndex() {
		let items = isSearching ? filteredRows : rows
		guard let selectedItem = selectedItem else { return }
		guard let selectedItemIndex = items.firstIndex(of: selectedItem) else { return }
		tableView.scrollToRow(at: IndexPath(row: selectedItemIndex, section: 0), at: .top, animated: true)
	}
	
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		scrollToCheckMarkedIndex()
	}
	
	// MARK: Keyboard hidden
	@objc
	private func keyboardDidHide(notification: Notification) {
		isSearching = false
		reload()
		scrollToCheckMarkedIndex()
	}
	
	// MARK: Remove all observers
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	// MARK: Update Initial Selection
	private func configureInitialSelection() {
		//
		if let initialSelection = initialSelection {
			selectedItem = rows.first(where: { item -> Bool in
				return item.title.lowercased() == initialSelection.lowercased()
			})
		}
	}
}

extension SPViewController: UISearchBarDelegate {
	
	public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		guard let searchText = searchBar.text else {
			fatalError("Search field has invalid text")
		}
		//
		isSearching = searchText.count > 0
		
		//
		if isSearching {
			filterPickerDataForInput(searchText)
		}
		reload()
	}
	
	public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		searchBar.setShowsCancelButton(true, animated: true)
	}
	
	public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		searchBar.setShowsCancelButton(false, animated: true)
	}
	
	public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.text = ""
		searchBar.resignFirstResponder()
	}
}

extension SPViewController: UITableViewDataSource {
	
	public func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let items = isSearching ? filteredRows.count : rows.count
		
		//
		if let emptyMessage = emptyMessage, items == 0 {
			tableView.setEmptyView(title: emptyMessage.title,
								   message: emptyMessage.message)
		} else {
			tableView.restore()
		}
		
		return items
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//
		let item = isSearching ? filteredRows[indexPath.row] : rows[indexPath.row]
		
		//
		switch self.style {
		case .plain:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: SPTextTableViewCell.identifier, for: indexPath) as? SPTextTableViewCell else {
				fatalError("Could not dequeue SPTextTableViewCell")
			}
		
			cell.locationName?.text = item.title
			cell.isSelected = item == selectedItem
			
			return cell
			
		case .detail:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: SPDetailTableViewCell.identifier, for: indexPath) as? SPDetailTableViewCell else {
				fatalError("Could not dequeue SPDetailTableViewCell")
			}
			
			cell.locationName?.text = item.title
			cell.locationImage.image = UIImage(named: item.image ?? "place-holder")
			cell.locationCode.text = item.detail
			cell.isSelected = item == selectedItem
			
			return cell
		}
	}
}

extension SPViewController: UITableViewDelegate {
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item = isSearching ? filteredRows[indexPath.row] : rows[indexPath.row]
		selectedItem = item
		reload()
	}
	
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
}
