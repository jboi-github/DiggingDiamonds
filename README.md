# DiggingDiamonds
The Game of Digging Diamonds as iOS App
## How the branches work
There're four branches at the moment with more to come. The two most important branches are:
- `template-master`
- `template-development`

These two branches contain the template, aka GameFrame, to be used be the actual game development.

Other branches are derived from the `template-master` to create an instance of a game. There're always at least two branches for a game:
- `<Game>-master` contains the currently published game on AppStore
- `<Game>-development` contains the current development status. There can be more branches, depending on the features and complexity of the game.

The following picture illustrates how code is pulled towards AppStore. Note that the original master branch is never used.
![Branches](/images/branches.png)

And this is, how you can use the template: Clone `template-master` and add your game on top of it. The GNU licences explicitely excludes to use it for closed software like Games in the AppStore. When you plan to go publich your game on the AppStore, let me know. It requires simply to be mentioned on your launch screen and I expect some donation to be able to continue with this project.

## The template
The template contains all bits and pieces of a game - apart from the game itelf. It offers handling of
- **Scores**: Any kind measurement in the game, that can be collected or earned. Examples are points, stars, levels etc. Scores are automatically synced to local disk and, if possible, synchronized with iCloud. Scores, that reference a score in GameCenter are pushed to the leaderboard.
- **Achievements**: Anything, the player can achieve, when playing the game. Such as medals, mastered experience etc. An achievement can be achieved up to a percentage. Like scores, achievements are automatically synced to local disk, iCloud and GameCenter.
- **Ads** like banner, interstitals and videos. Google Admob is currently the only ad provider, that is implemented. Fallback to other providers is yet to come.
- **InApp purchases** of consumable (like scores) and non-consumable (like stop Ads) goods. If connected to Ads, a non-consumable inApp purchase stops showing banners, interstatials and videos. The player is still able to use Videos to get earnings in the game.
- **GameCenter** link to show leaderboard and achievements.
- **Record**, replay and share the game scenes.
- **Feedback** and get ratings by standard feedback screen or directly linking the player to the AppStore webpage to provide feedback text.
- **Links** to facebook, twitter, Instagram and other social media accounts for serving your community
- Data Privacy is yet to come

In addition, the templates implement a standard storyboard for games. This picture illustrates the storyboard screens:
!!!PICTURE!!!

One of the central design criterias for the storyboard were, that the game should be lightweight, simple and easy to use. Short start times are also important as straight processes without being bothered by additional buttons and long click-through paths until the player can even start the game. Therefore the main screen directly contains the game and this is presented straight after starting.

Some remarks and best practice for the screens:
- Launchscreen: I like games to be lightweight and look like straight starters. On the other hand some startup procedure is necessary and might need some time. To give the player the impression of a fast starting app, let the Launchscreen look like the static parts of the main screen. Make a screenshot and put it onto the launchscreen. Add all buttons in the `disabled` status to the picture. It'll look like you already started but need just an additional second to allow the player to interact.
- Main screen: As the name says. It contains all links to other interactions and screens as well as a banner for Ads, areas to show current scores and the like. It also contains the game itself in either a SceneKit or SpriteKit View. Depending on the type of game, you can add several elements:
  - If it is an arcade game, you should averlay the game view with a play button to allow the player to get ready before the game starts.
  - If you want the player to make a choice before each and every start of your game, add a overlay over the game view that let the player choose. This includes any choices, that you dont want to put into the settings screen. Difficulty level of Sudoku or chosing between black and white in chess are exmaples here.
  - If your Game has neither of the abve requirements, simply start your game and expect the players input.
- Feedback screen is either the standard rating screen, that iOS provides or an external URL-link to the AppStore.
- GameCenter shows the standard GameCenter UIController as it is provided by iOS.
- Video and interstatials are shown when:
  - Game is paused + it is appropriate (fuzzy value) and not the stop-ads non-consumable was purchased
  - Or the player pressed the earn-button
  - In addition interstatials overlay the game view
- Settings contaisn three groups of settings:
  - Switches, values and texts to provide control over common behaviour. Most commonly mixed with system settings for the App.
  - Game Settings like choosing characters or weapons. The choice might link to the store.
  - A restore purchases button
- InApp Store contains all consumable and non-consumable (if not already bought) goods. It also contains a button to restore purchaes. This button has the same code as in settings.
- InApp Offer shows a specific offer and itspresentation is context driven. Example is to buy additional lives just before Game ends.
  - A button in this screen links to the InApp store.
  - When presenting the store from here, the store replaces this screen as the top screen innavigation. Thus, when the player exits the store, the main-screen will be shown again.

## Setup the game
It's a few steps to get to your game. The good thing: You can focus as much as possible on your game and game design.
1. Clone the `template-master` and create your project (including iCloud and Core Data) on top of it. Run it and see what you already have.
2. Make sure your XCode contains the capabilities for Game Center, In-App Purchase and iCloud.
    - In iCloud activate "CloudKit" which includes Push Notifications
    - Choose your Container or click on "+" to create one. Containers cannot be deleted, so ensure you name them correctly.
    - !!!WHICH ELSE!!!
3. The following steps can be done in any order. In fact I revisit and change them and follow an iterative approach.
  - In itunes connect, create the App, add achievements and leaderboards (scores) to GameCenter and receive your AppId
  - Design your game by changing the storyboard and controls to fit your game layout. Also fill the settings screen.
  - Build your Game Engine. That is what you're looking for :-)
  - Call the appropriate functions in the template to ensure it knows what it has to do. See below chapters to know, where to put the corresponding information.
  
