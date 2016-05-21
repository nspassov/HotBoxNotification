# HotBoxNotification
Unobtrusive and customizable alerts for your iOS app

![Demo](http://i.imgur.com/51F5YNu.gif)

## Usage

First you define and configure the types of notifications you wish to display:

```swift
HotBox.sharedInstance().settings = [
    "failure": [ "backgroundColor": UIColor.redColor(), "image": UIImage(named: "677-emoticon-sad")! ],
    "warning": [ "backgroundColor": UIColor.yellowColor(), "image": UIImage(named: "676-emoticon-suprise")! ],
    "success": [ "backgroundColor": UIColor.greenColor(), "image": UIImage(named: "680-emoticon-shades")! ],
]
```

Then you call any of the public methods to display the kind of notification you would like:

```swift
/**
 Notification that remains on screen until dismised via tap.
 */
public func showStickyMessage(text: NSAttributedString!, ofType type: String!)

/**
 Notification that remains on screen until dismised via tap. The delegate may react on tap event.
 */
public func showStickyMessage(text: NSAttributedString!, ofType type: String!, withDelegate delegate: HotBoxDelegate!)

/**
 Notification with button that remains on screen until dismised via tap or button. The delegate may react on tap event or button action.
 */
public func showStickyMessage(text: NSAttributedString!, ofType type: String!, withDelegate delegate: HotBoxDelegate!, buttonTitle: String!)

/**
 Notification that remains on screen for the time of the default duration or until dismised via tap.
 */
public func showMessage(text: NSAttributedString!, ofType type: String!)

/**
 Notification that remains on screen for the time of the default duration or until dismised via tap. The delegate may react on tap event or expiration event.
 */
public func showMessage(text: NSAttributedString!, ofType type: String!, withDelegate delegate: HotBoxDelegate!)

/**
 Notification that remains on screen for the time of the specified duration or until dismised via tap. The delegate may react on tap event or expiration event.
 */
public func showMessage(text: NSAttributedString!, ofType type: String!, withDelegate delegate: HotBoxDelegate!, duration timeout: NSTimeInterval)
```

A HotBox delegate may implement the following methods:

```swift
func hotBoxHasExpired(type: String!) {
    print("Dismissed due to timeout")
}

func hotBoxWasTapped(type: String!) {
    print("Notification was tapped")
}

func hotBoxWasSwiped(type: String!) {
    print("Dismissed via swipe")
}

func hotBoxButtonWasTapped(type: String!) {
    print("Dismissed via button action")
}
```

## Pod

`pod 'HotBoxNotification', :git => 'https://github.com/nspassov/HotBoxNotification.git'`
