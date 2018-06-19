# Xapo iOS Technical Interview

A simple iOS app in Swift that shows a list of trending repositories on Github and a detail of each one when clicked.
The selected architecture for the project was MVVM (Model-View-ViewModel)

## Libraries

- ReactiveCocoa 7.0
- Alamofire 4.7
- ObjectMapper 3.1
- Down (to show markdown text)
- Kingfisher (to load images)

## Tests

### Unit tests

Added unit tests for both RepoDetailViewModel and RepoDetailViewModel.

## Taken decisions

- The search is done on the already searched items. It does not perform a new search within the API
- The trending topic search query is 'ios', so it will show the trending repositories on iOS

## Improvements
- Add UI tests (I did not have time to finish them)