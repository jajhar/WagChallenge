# WagChallenge

## TODO

- Add Unit Testing
- Flesh Out User Model with more data from API
- Extend UserPager.swift to support pagination

## Project Structure

### UI

Contains all UI elements such as storyboards, controllers, cells, etc...

### Image Caching

Contains UIImage cache using NSCache that extends URL to allow fetching of images

### API

Contains all classes necessary for communication with the API. UserAPI.swift extends the base class APICommunication (which conforms to a communication protocol)

### Core data

Contains the data model along with a manager class for dealing with core data objects. The DataCoordinator.swift file is responsible for facilitating communication between the API and Core Data.

### Models

All of the NSManagedObjects

### Pagers

An extendable class that is used for object paging. (Currently only supports 1 page)

