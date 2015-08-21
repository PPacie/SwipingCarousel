//
//  SwipingCarouselCollectionViewController.swift
//  Swiping Carousel
//
//  Created by Pablo Surfate on 8/20/15.
//  Copyright (c) 2015 Pablo Paciello. All rights reserved.
//

import UIKit

let reuseIdentifier = "Card"

class SwipingCarouselCollectionViewController: UICollectionViewController {
    
    //MARK: Model
    private var savedCards = [Card?]()
    
    private struct Card {
        let image: UIImage?
        let name: String
        let profession: String
        let mainDescription: String
        let activity: String
    }
   
    private func loadCards() {
        for index in 1...10 {
            let newCard = Card(image: UIImage(named:"image\(index).png"), name: "User\(index)", profession: "Profesion\(index)", mainDescription: "To share my idea with somebody! I want to start my own fashion company. It's going to be called Black Milk! Ping me if you want to chat 😜", activity: "Activity\(index)")
            savedCards.append(newCard)
        }
        collectionView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCards()
        
        // Do any additional setup after loading the view.
//        
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action:"handleGesture:")
//        collectionView?.addGestureRecognizer(pinchGesture)
    }
    
//    func handleGesture(gesture: UIPinchGestureRecognizer) {
//        switch gesture.state {
//        case .Began:
//            let scaleStart = gesture.scale
//        case .Changed:
//            
//            collectionView?.collectionViewLayout.invalidateLayout()
//        default: break
//        }
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return savedCards.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CardCollectionViewCell
        
        // Configure the cell
        if let currentCard = savedCards[indexPath.row] {
            cell.imageView.image = currentCard.image
            cell.nameLabel.text = currentCard.name
            cell.professionLabel.text = currentCard.profession
            cell.mainDescriptionLabel.text = currentCard.mainDescription
            cell.activityLabel.text = currentCard.activity
        }
        return cell
    }


    // MARK: UICollectionViewDelegate

 

}
