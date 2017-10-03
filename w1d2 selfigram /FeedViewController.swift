//
//  FeedViewController.swift
//  w1d2 selfigram
//
//  Created by Nitin Panchal on 2017-08-22.
//  Copyright © 2017 Sweta panchal. All rights reserved.
//
import Foundation
import Parse
import UIKit

class FeedViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    var posts = [Post]()
    func getPosts() {
        if let query = Post.query() {
            query.order(byDescending: "createdAt")
            query.includeKey("user")
            
            query.findObjectsInBackground(block: { (posts, error) -> Void in
                self.refreshControl?.endRefreshing()
                if let posts = posts as? [Post]{
                    self.posts = posts
                    self.tableView.reloadData()
                }
                
            })
        }
    }
    override func viewDidLoad() {
    navigationItem.titleView = UIImageView(image: UIImage(named: "Selfigram"))
     

        super.viewDidLoad()
     
          getPosts()
        
    }
    
        override func viewWillAppear(_ animated: Bool) {
            if (PFUser.current() == nil) {
               DispatchQueue.main.async(execute: { () -> Void in
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginViewController
                    self.present(viewController, animated: true, completion: nil)
                })
            }
        }
    
    
    @IBAction func refreshPulled(_ sender: UIRefreshControl) {
          getPosts()
    }

    @IBAction func doubleTappedSelfie(_ sender: UITapGestureRecognizer) {
        
        // get the location (x,y) position on our tableView where we have clicked
        let tapLocation = sender.location(in: tableView)
        
        // based on the x, y position we can get the indexPath for where we are at
        if let indexPathAtTapLocation = tableView.indexPathForRow(at: tapLocation){
            
            // based on the indexPath we can get the specific cell that is being tapped
            let cell = tableView.cellForRow(at: indexPathAtTapLocation) as! SelfieCell
            
            //run a method on that cell.
            cell.tapAnimation()
        }
    }
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    @IBAction func cameraButtonPressed(_ sender: Any) {
        print("Camera Button Pressed")
        // 1: Create an ImagePickerController
        let pickerController = UIImagePickerController()
        
        // 2: Self in this line refers to this View Controller
        //    Setting the Delegate Property means you want to receive a message
        //    from pickerController when a specific event is triggered.
        pickerController.delegate = self
        
        if TARGET_OS_SIMULATOR == 1 {
            // 3. We check if we are running on a Simulator
            //    If so, we pick a photo from the simulator’s Photo Library
            // We need to do this because the simulator does not have a camera
            pickerController.sourceType = .photoLibrary
        } else {
            // 4. We check if we are running on an iPhone or iPad (ie: not a simulator)
            //    If so, we open up the pickerController's Camera (Front Camera, for selfies!)
            
          //  pickerController.sourceType = .camera
          //  pickerController.cameraDevice = .front
           // pickerController.cameraCaptureMode = .photo
            
            
            
            
        }
        
        // Preset the pickerController on screen
        self.present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // setting the compression quality to 90%
            if let imageData = UIImageJPEGRepresentation(image, 0.9),
                let imageFile = PFFile(data: imageData),
                let user = PFUser.current(){
                    //2. We create a Post object from the image
                    let post = Post(image: imageFile, user: user, comment: "A Selfie")
                
                    post.saveInBackground(block: { (success, error) -> Void in
                    if success {
                        print("Post successfully saved in Parse")
                        
                        //3. Add post to our posts array, chose index 0 so that it will be added
                        //   to the top of your table instead of at the bottom (default behaviour)
                        self.posts.insert(post, at: 0)
                        
                        //4. Now that we have added a post, updating our table
                        //   We are just inserting our new Post instead of reloading our whole tableView
                        //   Both method would work, however, this gives us a cool animation for free
                        
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.tableView.insertRows(at: [indexPath], with: .automatic)
                        
                    }
                })
            }
        }
        dismiss(animated: true, completion: nil)
    }
   

    @IBAction func didZoomImages(_ sender: UIPinchGestureRecognizer) {
        
        var lastScale = sender.scale
    
        if (sender.state == .began || sender.state == .changed) {
            let currentScale = sender.view!.layer.value(forKeyPath:"transform.scale")! as! CGFloat
            // Constants to adjust the max/min values of zoom
            let kMaxScale:CGFloat = 2.0
            let kMinScale:CGFloat = 1.0
            var newScale = 1 -  (lastScale - sender.scale)
            newScale = min(newScale, kMaxScale / currentScale)
            newScale = max(newScale, kMinScale / currentScale)
            let transform = (sender.view?.transform)!.scaledBy(x: newScale, y: newScale);
            sender.view?.transform = transform
            lastScale = sender.scale  // Store the previous scale factor for the next pinch gesture call
        }
     
    }
   



    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return self.posts.count
        }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! SelfieCell
        
        let post = self.posts[indexPath.row]
        cell.post = post
//        cell.selfieImageView.image = nil
//        
//        let imageFile = post.image
//        imageFile.getDataInBackground(block: {(data, error) -> Void in
//            if let data = data {
//                let image = UIImage(data: data)
//                cell.selfieImageView.image = image
//            }
//        })
//        
//        cell.usernameLabel.text = post.user.username
//        cell.commentLabel.text = post.comment
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
