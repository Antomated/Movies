# Movies

The app was developed according to specific test task requirements

### Dark appearance with English localization 

| Search | Details | Trailer |
| :----------: | :---------: | :---------: |
<img src = "https://github.com/user-attachments/assets/1ccbbbce-86f4-4fc7-bf8a-d0ffd8a7a1ec" width=300> |<img src="https://github.com/user-attachments/assets/c030ccd7-e27e-4bea-93de-16777713ed6d"  width=300> |<img src="https://github.com/user-attachments/assets/a4bfce4e-6903-490a-aeb5-19326c92750a"  width=300> |

### Light appearance with Ukrainian localization

| Search | Details | Sort |
| :----------: | :---------: | :---------: |
<img src = "https://github.com/user-attachments/assets/902f1ebe-8913-4dad-b68e-b79dfa73d08d" width=300> |<img src="https://github.com/user-attachments/assets/fd82f4ae-3a2a-497e-95dd-53ae6b6f15c5"  width=300> |<img src="https://github.com/user-attachments/assets/70a96447-835d-47c6-900b-7a43b49047e6"  width=300> |

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

✓ Displays a list of movies with details

✓ Uses The Movie Database API for data source

✓ Minimum supported OS: iOS 15.0

✓ Networking: Alamofire

✓ Architecture: MVVM

✓ Layout: UIKit + Autolayout (Programmatic or Interface Builder)

✓ Data parsing: Decodable protocol

✓ Implements Dependency Injection

✓ Error Handling: Displays native alert with title "Error"

✓ Handle no internet connectivity: Shows alert

✓ Implements pull to refresh for fresh data load

✓ Libraries: SwiftPackageManager

✓ Displays activity indicator on network requests

✓ Handles empty states for no results in the list

✓ Uses Git repository with the basic git flow

✓ Displays popular movies in default sorting

✓ Pagination: Loads 20 items per page seamlessly

✓ Clicking on a movie leads to its details screen

✓ Displays movie details:

✓ Displays trailer button (only if available)

✓ Clicking on poster leads to Screen 3 (modal display of full-size poster)

✓ Navigation bar with movie title and back button

✓ Has modal display of full-size movie poster

✓ Supports simple offline Mode with previously downloaded movies

✓ Shows an alert when trying to view details of a movie offline

✓ Implements local search for movie titles when offline

✓ Cache images for offline viewing with Kingfisher

✓ Supports Ukrainian and English localization (both app and API calls)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
