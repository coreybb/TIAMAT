# TIAMAT (TIAMAT is Another Mobile App Take-Home)
<img src="TIAMAT/Assets.xcassets/tiamat.imageset/tiamat.png" width="300" alt="TIAMAT">

Hi, there. If you're reading this, it's probably because you've been asked to build this app, or one very similar to it showing employees, news, recipes or Pokémon. No matter the data model or endpoints, the core requirements usually look the same: 
- Fetch data from an API
- Display it in a list
- Handle images (prefetching, caching, lazy loading)
- Show a detail screen or web view for selected items
- Add search/sort
- Handle loading states and errors gracefully
- Cache data (either images, object data, or both)

## The Solution
TIAMAT aims to provide a flexible, production-quality template that can be quickly adapted to different requirements. Please note that I'm currently in the process of making the project much more flexible, relying on abstractions and concrete implementations thereof to grant base functionality including: 
- Protocol-based architecture
- Type-safe networking layer
- Performant, generic presentation layer
- Generic state management
- Image caching system
- Dependency injection and encapsulation
- Navigation coordination
- Factory pattern for UI components
- Error handling infrastructure
- Type-safe configuration management (xcconfig support)
- Bundle configuration
- Comprehensive documentation
- UI composition

The data flow infrastructure and much of the UI is model-agnostic. The heavy lifting—project structure, object graph composition, networking, image caching,  data binding, collection views, state management, error handling—is all reusable regardless of what you're showing. 

## Current Status
This repository is actively being developed to provide:
- Clear protocol definitions
- Implementation guidance
- Best practices documentation
- Example branches
- Practical testing strategies

Check back for updates and improvements.

## Roadmap

I plan to publish various permutations of TIAMAT by integrating different technologies and architectural patterns. The project will leverage combinations of UI frameworks (UIKit and SwiftUI), data management solutions (Core Data, Swift Data, and SQLite), and architectural patterns (MVVM and MVP). Currently, the app uses the MVVM pattern without an object data persistence layer. Future feature branches will demonstrate how these components can be integrated to enhance functionality and architecture.

I also plan to migrate the app to Swift 6 following incremental adoption of the new strict concurrency checking.

## Why This Exists

This repository was born out of an observation: Many companies use dubiously similar (or identical) take-home project specifications for iOS interviews. After building the same app multiple times, it became clear that:

1. Take-home projects often evaluate table-stakes aptitude that could be more efficiently assessed through discussion
2. Companies frequently share (perhaps unwittingly) or repurpose project specifications
3. Developers spend considerable time reimplementing the same boilerplate and architectural patterns

So, like any good developer confronted with repetitive tasks, we're taking a DRY approach to solving a common problem.

This project aims to:
- Reduce redundant work 
- Highlight architectural considerations alongside common implementations
- Allow developers to focus on real, domain-specific problems 
- Demonstrate that good iOS architecture is, more often than not, pattern-based—not project-specific


## Getting Started

The project is designed for easy configuration of environment-specific constants through user-defined build settings or xcconfig files. In theory, this approach keeps sensitive values and environment-specific URLs out of the codebase. For our purposes, it allows for runtime configuration of networking behavior and testing scenarios without modifying the source code.

#### Prerequisites
- Xcode installed on your macOS system.
- Basic understanding of iOS development and working with Xcode.

#### Configuration Setup
Xcode uses a priority-based configuration system. Values can be set using either User-Defined build settings or xcconfig files, with the former having higher precedence.

**Option 1: User-Defined Build Settings (Quick Testing)**
1. Open Xcode and navigate to your project's Build Settings.
2. Under "User-Defined", add the following entry:

`API_BASE_URL = https://api.example.com/`

3. This value will override any corresponding values set in xcconfig files.
    
**Option 2: xcconfig Files (Multiple Test Scenarios)**
1. Create xcconfig Files in your project directory:

- In `GoodData.xcconfig`:

`API_BASE_URL = https://api.example.com/good-data.json`

- In `MalformedData.xcconfig`:

`API_BASE_URL = https://api.example.com/malformed-data.json`

- In `EmptyData.xcconfig`:

`API_BASE_URL = https://api.example.com/empty-data.json`

2. Configure Build Settings:
- Leave `API_BASE_URL` empty to use values from xcconfig files, OR
- Set `API_BASE_URL = ${API_BASE_URL}` to ensure xcconfig values are used.

3. Create Schemes in Xcode:
- Create different schemes for each xcconfig file to easily switch between configurations.

#### Referencing Configuration Values
Reference the configuration values in your Info.plist file:
```xml
<key>API_BASE_URL</key>
<string>${API_BASE_URL}</string>
```
**Example Usage**

- Access configuration values directly in your code:

`let baseURLString = ConfigurationConstant.apiBaseURL.value()`

- Use the configuration value in URL construction:

`let baseURL = URL(string: ConfigurationConstant.apiBaseURL.value())!`

- Retrieve configuration values for specific bundles (useful for testing):

`let testURLString = ConfigurationConstant.apiBaseURL.value(in: testBundle)`

**Notes**
- In `DEBUG` builds, missing configuration values will trigger a fatal error.
- In `RELEASE` builds, missing values will default to an empty string.

For more information on this pattern, see NSHipster's [*Xcode Build Configuration Files*](https://nshipster.com/xcconfig/).

# Contact

[Connect with me on LinkedIn.](https://www.linkedin.com/in/coreybeebe)
