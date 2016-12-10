import UIKit

class ImageListViewController: UITableViewController {

    var detailViewController: ImageDetailViewController? = nil
    var imageNames = [
        "Batman (Black)",
        "Batman (Silver)",
        "Battlestar (Dark)",
        "Battlestar (Red)",
        "Command",
        "Engineering",
        "Instructor",
        "Life Sciences",
        "Mr. Fusion",
        "Pepsi Perfect",
        "Plutonium",
        "Serenity",
        "Star Trek",
        "The Fellowship of the Ring",
        "The Two Towers",
        "The Return of the King",
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentDetail" {

            guard let imageDetailVC = segue.destination as? ImageDetailViewController,
                  let cell = sender as? UITableViewCell,
                  let cellIndexPath = tableView.indexPath(for: cell) else {
                return
            }
            
            imageDetailVC.delegate = self
            imageDetailVC.imageNames = imageNames
            imageDetailVC.currentImageNameIndex = cellIndexPath.row
        }
    }
    
    // MARK: - Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let imageName = imageNames[indexPath.row]
        cell.textLabel!.text = imageName
        return cell
    }
    
    

}

extension ImageListViewController: ImageDetailViewControllerDelegate {
    
    func imageDetailViewControllerDidFinish(sender: ImageDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imageDetailViewController(_ sender: ImageDetailViewController, didUpdateCurrentNameIndex imageNameIndex: Int) {
        let newSelection = IndexPath(row: imageNameIndex, section: 0)
        tableView.selectRow(at: newSelection, animated: false, scrollPosition: .middle)
    }
    
}
