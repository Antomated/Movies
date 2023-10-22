# Movies

The app was developed within a **4-day sprint** according to specific test task requirements

## Screenshots

| Search | Details | Trailer |
| :----------: | :---------: | :---------: |
<img src = "https://github.com/Beavean/Movies/assets/105853157/1ac4b960-5881-48ec-a90c-0c03f4a70562" width=300> |<img src="https://github.com/Beavean/Movies/assets/105853157/6a518ab3-197f-45b6-934e-8b0600eac502"  width=300> |<img src="https://github.com/Beavean/Movies/assets/105853157/c0effce1-3a78-4757-bb97-61bf587951be"  width=300> |

## Key Features

* Light/Dark appearance support
* The Movie Database API for data source
* iOS 15+
* UIKit
* MVVM+Coordinator
* Programmatic UI without storyboards
* Diverse search result sort options
* Pagination
* 4 screens with different elements
* Separate network service
* User-friendly error handling
* Basic dependency injection
* Minimum dependencies: Alamofire & Kingfisher
* Localization

## Completed task requirements

✅ Displays a list of movies with details.

✅ Uses The Movie Database API for data source.

✅ Minimum supported OS: iOS 15.0.

✅ Networking: Alamofire

✅ Architecture: MVVM

✅ Layout: UIKit + Autolayout (Programmatic or Interface Builder).

✅ Data parsing: Codable protocol.

✅ Implements Dependency Injection.

✅ Error Handling: Displays native alert with title "Error".

✅ Handle no internet connectivity: Shows alert.

✅ Implements pull to refresh for fresh data load.

✅ Libraries: SwiftPackageManager.

✅ Displays activity indicator on network requests.

✅ Handles empty states for no results in the list.

✅ Uses Git repository with the basic git flow.

✅ Displays popular movies in default sorting.

✅ Pagination: Loads 20 items per page seamlessly.

✅ Clicking on a movie leads to its details screen.

✅ Displays movie details:

✅ Displays trailer button (only if available).

✅ Clicking on poster leads to Screen 3 (modal display of full-size poster).

✅ Navigation bar with movie title and back button.

✅ Has modal display of full-size movie poster.

✅ Supports simple offline Mode with previously downloaded movies.

✅ Shows an alert when trying to view details of a movie offline.

✅ Implements local search for movie titles when offline.

✅ Cache images for offline viewing with Kingfisher

✅ Supports Ukrainian and English localization (both app and API calls)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
