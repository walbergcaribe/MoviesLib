//
//  MoviesTableViewController.swift
//  MoviesLib
//
//  Created by user195143 on 12/15/21.
//

import UIKit
import CoreData

class MoviesTableViewController: UITableViewController {

    // var movies: [Movie] = []
    
    var fetchedResultsController: NSFetchedResultsController<Movie>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieViewController = segue.destination as? MovieViewController,
           /*
           let row = tableView.indexPathForSelectedRow?.row {
             movieViewController.movie = movies[row]
           }
            */

           let indexPath = tableView.indexPathForSelectedRow {
            movieViewController.movie = fetchedResultsController.object(at: indexPath)
        }
    }
    
    func loadMovies () {
        
        let fetchedRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchedRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        
        // Ler json de filmes
        /*
        guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            movies = try JSONDecoder().decode([Movie].self, from: data)
            
            // Imprimir valores
            /*
            for movie in movies {
                print("Title: \(movie.title)")
                print("Categories: \(movie.categories)")
                print("duration: \(movie.duration)")
                print("Rating: \(movie.rating)")
                print("summary: \(movie.summary)")
                print("Image: \(movie.image)")
                print("--------------------------------------")
            }
            */
        } catch {
            print(error)
        }
        */
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return movies.count
        
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let movie = movies[indexPath.row]
        
        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = movie.duration
        */
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }

        //let movie = movies[indexPath.row]
        //cell.configureWith(movie: movie)
        
        let movie = fetchedResultsController.object(at: indexPath)
        cell.configureWith(movie: movie)
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movie = fetchedResultsController.object(at: indexPath)
            
            context.delete(movie)
            
            try? context.save()
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MoviesTableViewController:  NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}
