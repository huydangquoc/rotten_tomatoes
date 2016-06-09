## Rotten Tomatoes

This is a movies app displaying box office and top rental DVDs using the [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON).

Time spent: `24 hours`

### Features

#### Required

- [x] User can view a list of movies from Rotten Tomatoes. Poster images must be loading asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for movies API. You can use one of the 3rd party libraries at [https://www.cocoacontrols.com/search?q=hud](https://www.cocoacontrols.com/search?q=hud).
- [x] User sees error message when there’s a networking error. You may not use UIAlertView or a 3rd party library to display the error. See this screenshot for what the error message should look like: [network error screenshot](http://forums.androidcentral.com/attachments/google-nexus-10-tablet/51236d1355614625t-facebook-network-error-no-internet-connection-screenshot_2012-12-15-15-15-05.png).
- [x] User can pull to refresh the movie list. Guide: [Using UIRefreshControl](http://courses.coderschool.vn/content/week_1/refresh_control).

#### Optional

- [x] All images fade in.
- [x] For the larger poster, load the low-res first and switch to high-res when complete.
- [ ] All images should be cached in memory and disk: AppDelegate has an instance of `NSURLCache` and `NSURLRequest` makes a request with `NSURLRequestReturnCacheDataElseLoad` cache policy. I tested it by turning off wifi and restarting the app.
- [x] Customize the highlight and selection effect of the cell.
- [x] Customize the navigation bar.
- [x] Add a tab bar for Box Office and DVD.
- [x] Add a search bar: pretty simple implementation of searching against the existing table view data.

#### Additional

* [x] apply UICollectionView for DVDs tab
* [x] Support search function by using TextField (in DVDs tab)
* [x] Choose locale currency
* [x] Show/hide detail content (in DVD Detail) by swipe up/down

### Walkthrough
Coming soon

Credits
---------
* [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [EZLoadingActivity](https://github.com/goktugyil/EZLoadingActivity)
* [TSMessages](https://github.com/KrauseFx/TSMessages)
