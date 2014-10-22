##Lost Character Challenge - 10/21/2014

The challenge pulls in a plist from a URL with data about several characters from _Lost_.

* The challenge was to display characters in a list
 	* Populate CoreData database with plist contents (only if it haden't already been populated).

  
* Add new characters
	* Sort alphabetically. 
	* Open in a separate view (Modal view).

* Make custom UITableViewCell to display all character information (including image).

* Delete characters from list (and CoreData database respectively).

* Add NSPredicate to filter the list of characters

* Enable editing mode to delete multiple characters from list.

--- 
####Classes Used 
• NSFetchRequest • NSManagedObjectContext • NSSortDescriptor • NSPredicate • titleForDeleteConfirmationButtonForRowAtIndexPath • Some sweet textField passing the responder to next textField and executing method on the last textField •