//
//  TableViewDataSourceDelegate.swift
//  Ladybug
//
//  Created by Ethanhuang on 2018/6/14.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit

class TableViewDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate {
    var viewModel: TableViewViewModel = TableViewViewModel(sections: [])
    private weak var tableViewController: UITableViewController?

    init(tableViewController: UITableViewController) {
        super.init()
        self.tableViewController = tableViewController
        tableViewController.registerForPreviewing(with: self, sourceView: tableViewController.view)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].header
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return viewModel.sections[section].footer
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = self.viewModel.sections[indexPath.section].rows[indexPath.row]
        let identifier = cellViewModel.reuseIdentifier
        let cell = UITableViewCell(style: cellViewModel.cellStyle, reuseIdentifier:identifier)
        cellViewModel.configure(cell)

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cellViewModel = self.viewModel.sections[indexPath.section].rows[indexPath.row]
        cellViewModel.selectAction()
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cellViewModel = self.viewModel.sections[indexPath.section].rows[indexPath.row]
        return cellViewModel.leadingSwipeActions
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cellViewModel = self.viewModel.sections[indexPath.section].rows[indexPath.row]
        return cellViewModel.trailingSwipeActions
    }

    // MARK: - UIViewControllerPreviewingDelegate

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let view = tableViewController?.view,
            let tableView = tableViewController?.tableView,
            let indexPath = tableView.indexPathForRow(at: tableView.convert(location, from: view)),
            let cell = tableView.cellForRow(at: indexPath) else {
                return nil
        }
        previewingContext.sourceRect = tableView.convert(cell.frame, to: view)

        let cellViewModel = viewModel.sections[indexPath.section].rows[indexPath.row]
        return cellViewModel.previewingViewController?()
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        tableViewController?.present(viewControllerToCommit, animated: true, completion: nil)
    }
}
