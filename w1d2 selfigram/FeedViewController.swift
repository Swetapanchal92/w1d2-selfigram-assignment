//
//  FeedViewController.swift
//  w1d2 selfigram
//
//  Created by Nitin Panchal on 2017-08-22.
//  Copyright © 2017 Sweta panchal. All rights reserved.
//
import Foundation
import UIKit
class User {
    
    let username:String
    let profileImage:UIImage
    
    init(aUsername:String, aProfileImage:UIImage){
        //we are setting the User property of "username" to an aUsername property you are going to pass in
        username = aUsername
        profileImage = aProfileImage
    }
    
}
class Post {
    
    let imageURL:URL
    let user:User
    let comment:String
    
    init(imageURL:URL, user:User, comment:String){
        // You can name the property you are passing into the function the
        // same name as the class' property. To distinguish the two
        // add "self." to the beginning of the class' property.
        // So for example we are passing in an UImage called image and setting it as our
        // image property for Post.
        self.imageURL = imageURL
        self.user = user
        self.comment = comment    }
    
}

class FeedViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let nameArray = ["Hello", "my", "name", "is", "Selfigram"]
    
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        // let me = User(aUsername: "Sweta", aProfileImage: UIImage(named: "instaactivity")!)
       // let post0 = Post(image: UIImage(named: "instaactivity")!, user: me, comment: "Like 0")
       // let post1 = Post(image: UIImage(named: "instaactivity")!, user: me, comment: "Like 1")
       // let post2 = Post(image: UIImage(named: "instaactivity")!, user: me, comment: "Like 2")
        //let post3 = Post(image: UIImage(named: "instaactivity")!, user: me, comment: "Like 3")
        //let post4 = Post(image: UIImage(named: "instaactivity")!, user: me, comment: "Like 4")
  
        // posts = [post0, post1, post2, post3, post4]
        
        let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=289fce69069adc561a9e0d3c0cc3b29d&tags=cat")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            
            if let jsonUnformatted = try? JSONSerialization.jsonObject(with: data!, options: []){
                let json = jsonUnformatted as? [String : AnyObject]
                let photosDictionary = json?["photos"] as? [String : AnyObject]
                if let photosArray = photosDictionary?["photo"] as? [[String : AnyObject]] {
                    
                    for photo in photosArray {
                        
                        if let farmID = photo["farm"] as? Int,
                            let serverID = photo["server"] as? String,
                            let photoID = photo["id"] as? String,
                            let secret = photo["secret"] as? String {
                            
                            let photoURLString = "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg"
                            print(photoURLString)
                           
                            if let photoURL = URL(string: photoURLString) {
                                
                                let me = User(aUsername: "sam", aProfileImage: UIImage(named: "intsprofile")!)
                                let post = Post(imageURL: photoURL, user: me, comment: "A Flickr Selfie")
                                self.posts.append(post)
                            }
                        }
                        
                    }
                    
                    // We use OperationQueue.main because we need update all UI elements on the main thread.
                    // This is a rule and you will see this again whenever you are updating UI.
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                    
       
            } else{
                    print("error with response data")
                }
        }
            
        })
        // this is called to start (or restart, if needed) our task
        task.resume()

        
        
        
        
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
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        
//        // 1. When the delegate method is returned, it passes along a dictionary called info.
//        //    This dictionary contains multiple things that maybe useful to us.
//        //    We are getting an image from the UIImagePickerControllerOriginalImage key in that dictionary
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            
//            //2. To our imageView, we set the image property to be the image the user has chosen
//           // profileImageView.image = image
//            let me = User(aUsername: "sam", aProfileImage: UIImage(named: "intsprofile")!)
//            let post = Post(imageURL: image, user: me, comment: "My Selfie")
//            posts.insert(post, at: 0)
//            tableView.reloadData()
//            
//        }
//        
//        //3. We remember to dismiss the Image Picker from our screen.
//        dismiss(animated: true, completion: nil)
//        
//    }


    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return self.posts.count
        }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! SelfieCell
        
        let post = self.posts[indexPath.row]
        
        
        // I've added this line to prevent flickering of images
        // We are inside the cellForRowAtIndexPath method that gets called everything we layout a cell
        // Because we are reusing "postCell" cells, a reused cell might have an image already set on it.
        // This always resets the image to blank, waits for the image to download, and then sets it
        cell.selfieImageView.image = nil
        
        let task = URLSession.shared.downloadTask(with: post.imageURL) { (url, response, error) -> Void in
            
            if let imageURL = url, let imageData = try? Data(contentsOf: imageURL) {
                OperationQueue.main.addOperation {
                    
                    cell.selfieImageView.image = UIImage(data: imageData)
                    
                }
            }
            
        }
        
        task.resume()
        
        cell.usernameLabel.text = post.user.username
        cell.commentLabel.text = post.comment
        
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
