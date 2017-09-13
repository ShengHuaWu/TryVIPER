### Interactor
1. Business logic to manipulate model objects (Entities) to carry out a specific task.
2. Independent of any UI.
3. Interactor initiates a network operation, but it won’t handle the networking code directly. It will ask a dependency, like a network manager or API client.

### Entity
1. Model objects
2. Only be manipulated by Interactor.
3. Never be passed from Interactor to Presenter.

### Presenter
1. Contains logic to drive UI.
2. Gather inputs from user interactions.
3. Send requests to Interactor, and receive results from Interactor.
4. Don't know about UILabe, UIButton, etc...

### View
1. Wait for Presenter to give contents to display.
2. Express in terms of contents.
3. An abstract interface (Protocol)

### Routing
1. Presenter knows when to navigate to another screen, and which screen to navigate to.
2. Wireframe knows how to navigate.
3. Presenter will use Wireframe to perform the navigation.
4. Wireframe is also a place to handle navigation transition animations.

### Module
1. Usually, implement the module interface.
2. When another module wants to present this one, its Presenter will implement the module delegate protocol.

### Testing
1. Start with the Interactor.
2. If you develop the Interactor first, followed by the Presenter, you get to build out a suite of tests around those layers first and lay the foundation for implementing those use cases. 

### Reference
[objc.io](https://www.objc.io/issues/13-architecture/viper/)
