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
#### Carthage
~~~
github "ppacie/SwipingCarousel" 
~~~

## How to set it up

1. Import `SwipingCarousel` module to your `ViewController` and `CollectionViewCell` classes.

    ```swift
    import SwipingCarousel
    ```
2. Make your `CollectionViewCell` subclass of `SwipingCarouselCollectionViewCell`.
    ```swift
    class MyCollectionViewCell: SwipingCarouselCollectionViewCell {
    }
    ```
3. Conform to `SwipingCarouselDelegate` protocol methods `func cellSwipedDown()` and `func cellSwipedUp()`.
e.g.
    ```swift
    extension MyCollectionViewController: SwipingCarouselDelegate {
    
        func cellSwipedUp(_ cell: UICollectionViewCell) {
        ...
        }
        
        func cellSwipedDown(_ cell: UICollectionViewCell) {
        ...
        }
    }
    ```
4. Finally, you will need to set it as your CollectionView's custom layout: You can do it either in the Interface Builder **OR** programmatically.

*   Interface Builder: Go to your Storyboard file and select the Controller where you have the CollectionView. Later select the CollectionView in the Document Outline and set the `SwipingCarouselFlowLayout` as the Custom Layout in the Attributes Inspector and set the Module to `SwipingCarousel`.

![alt tag](https://github.com/PPacie/Swiping-Carousel/blob/master/AddCustomLayout.png)

*   Programmaticaly: 
Add the following line in the `viewDidLoad()` of your `CollectionViewController` (the ViewController that contains your CollectionView):

```swift
collectionView.setCollectionViewLayout(SwipingCarouselFlowLayout(), animated: false)
```
## SwipingCarouselCollectionViewCell Properties 

```swift
weak public var delegate: SwipingCarouselDelegate?
```
An object that supports the SwipingCarouselDelegate protocol and can respond to swiping events.
```swift
public var deleteOnSwipeDown = false
```
Indicates weather to remove the SwipingCarouselCell cell from view or to get it back to the original position when swiping down. Default behavior is to get back to original position.
```swift
public var deleteOnSwipeUp = false
```
Indicates weather to remove the SwipingCarouselCell cell from view or to get it back to the original position when swiping up. Default behavior is to get back to original position.

## Example
Check the *ExampleProject* folder to see an example of how it works.

## Can I customize the Layout?
Sure, you are able to customize the layout by overriding the `UICollectionViewDelegateFlowLayout` methods you desire.
e.g.
```swift
    extension MyCollectionViewController: UICollectionViewDelegateFlowLayout {
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 220, height: 220)
        }
    }
```
