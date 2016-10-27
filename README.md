# SwipingCarousel 
UICollectionView-based Swiping Carousel using Swift 3.0 and Xcode8

![alt tag](https://github.com/PPacie/Swiping-Carousel/blob/master/Swiping-Carousel-Demo.gif)

## What does it do?
*	When scrolling, the cards magnify when they get to the center.
*	You can tap and hold on a card, swipe up to **'Like'** it. Right after, it will scroll to next one.
*	You can tap and hold on a card, swipe down to **'Dismiss'** it. After, it will scroll to next card.
*	When tapping on the centered card, it will be opened a chat room with the user the card represents.
*	When tapping on the side cards, it will scroll to them.
*	When swiping up or down on the side cards, they won't be liked or dismissed. Just moved.

## Installation 
### Carthage
~~~
github "ppacie/SwipingCarousel" 
~~~

## How to set it up
1.
```swift
Import SwipingCarousel
```   
2.  You will need to set it as your CollectionView's custom layout: You can do it either in the Interface Builder **OR** programmatically.

*   Interface Builder: Go to your Storyboard file and select the Controller where you have the CollectionView. Later select the CollectionView in the Document Outline and set the `CardsViewFlowLayout` as the Custom Layout in the Attributes Inspector.

![alt tag](https://github.com/PPacie/Swiping-Carousel/blob/master/AddCustomLayout.png)

*   Programmaticaly: 
Add the following line in the `viewDidLoad()` of your `CollectionViewController` (the ViewController that contains your CollectionView):

```swift
collectionView.setCollectionViewLayout(SwipingCarouselFlowLayout(), animated: false)
```

## Can I customize the Layout?
Sure, you are able to customize the layout by editing the following lines in the `CardsViewFlowLayout.swift` file:

```swift
    // Mark: Constants 
    private struct CardsViewFlowConstants {
        static let activeDistance: CGFloat = 200
        static let zoomFactor: CGFloat = 0.3
        static let itemWidth: CGFloat = 210       //Width of your Cell.
        static let itemHeight: CGFloat = 278      //Height of your Cell.
        static let minLineSpacing: CGFloat = 50.0
        
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        itemSize = CGSizeMake(CardsViewFlowConstants.itemWidth, CardsViewFlowConstants.itemHeight)
        scrollDirection = .Horizontal
        minimumLineSpacing = CardsViewFlowConstants.minLineSpacing
        //These numbers will depend on the size of your cards you have set in the CardsViewFlowConstants.
        //60 - will let the first and last card of the CollectionView to be centered.
        //100 - will avoid the double rows in the CollectionView
        sectionInset = UIEdgeInsetsMake(100.0, 60.0, 100, 60.0)
        
    }
```
