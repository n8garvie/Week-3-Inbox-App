# Week-3-Inbox-App

Recreation of Inbox app that lets you swipe messages and the menu.

Time Spent: 10 hours

## User Stories completed:

* [x] Setup:
- Create a new project (disable Auto Layout). Guide
- Add the image assets above. Guide
- Configure the app icon and splash screen. Guide
* [x] Mailbox Screen
- In the Storyboard, add a custom view controller for the MailboxViewController. Guide: Creating Custom View Controllers
- The assets should include the help text, the search bar, a single message, and the feed of messages, all embedded in a scroll view.
- Configure the content size of the scroll view. Using UIScrollView
* [x]Message Interaction
- Wrap the single message into a view and put two image views for the left and right icons below the message. The background color view will provide the revealed color.
- Drag a pan gesture recognizer onto the message view. Be sure to enable user interaction in the view properties. Using Gesture Recognizers
* [x]Swipeable Menu
- Put all of the current views inside another view.
- Put the menu image view behind the view you added above.
- Add a screen edge gesture recognizer with a left edge to view.

![Walkthrough 1](Week3_Inbox_App.gif)
![Walkthrough 2](Week3_Inbox_App-2.gif)
![Walkthrough 3](Week3_Inbox_App-3.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).
