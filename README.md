# XCSelectableButton

## Summary
With this lib you can add programatically radios buttons, checkbox or chip. You just need create an instance from the XCCollection or XCTable, pass to it wht kind of element you want, the list and the class that will handle the didSelect event. Is important that the type of the list passes extenda from CollectionData.

## How to add the library to your project
### Swift Package Manager
In your project copy this link to add it https://github.com/xchelcd/XCSelectableButton.git

#### Requirements
iOS 15 or upper

## How to implement

### Step 1: Prepare your object class/struct
CollectionData allow to set the name displayed in the selectable button, so is mandatory extends from this for use it

#### Extends from CollectionData
<pre class = 'swift' active = 'swift'>
<swift>struct User: CollectionData {
  let id: UUID
  let name: String
  // more attributes ...
}</swift> </pre>

#### Implement functions
<pre class = 'swift' active = 'swift'>
<swift>struct User: CollectionData {
  let id: UUID
  let name: String


  // These attribute "name" will be display in the radio button/checkbox/chip
  var chipTitle: String {
    get { name }
  }
  func toString() -> String {
    name
  }
}</swift> </pre>
### Step 2: Work with XCSelectable
We can create a instance of XCSelectableCollectionGroup or XCSelectableTableGroup and these will receive the following data:

**Type:** It is the type of button to display, it could be *radio button, checkbox or chip*

**List:** This is the array of any type that extends from *CollectionData*

**Delegate:** The delegate usually is *self* (the ViewController) or any class that handle the selection button listener
#### Create an instance of the XCCollection or XCTable
<pre class = 'swift' active = 'swift'>
<swift> let userCollection = XCSelectableCollectionGroup(type: .chip, list: users, delegate: self)</swift> </pre>
#### Pass the parameters

#### Select the type
We have this options from XCSelectableButton.SelectableType:

* **radioButton**

* **checkbook**

* **chip**

* **custom** (not support)
### Step 3: Add constraints in code
In this step we need to add the view *userCollection* to the main view and after add the constraints:
<pre class = 'swift' active = 'swift'>
<swift>self.view.addSubview(userCollection)
  
  NSLayoutConstraint.activate([
    userCollection.topAnchor.constraint(equalTo: self.view.topAnchor),
    userCollection.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
    userCollection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
    userCollection.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
  ])</swift> </pre>

### Step 4: Add the listener
Now the IDE will throw an error that will request to you that the viewController conform the protocol *SelectableDelegate*
<pre class = 'swift' active = 'swift'>
<swift>extension ViewController: SelectableDelegate {
  typealias T = User
  
  func onSelected(data: User, selectableButton: XCSelectableButton) {
    print("\(data.name) - \(selectableButton.toString())")
  }
}</swift> </pre>
#### What data has the XCSelectableButton?

### Step 5: How to implement another XCSelectableCollection/XCSelectableTable with a different object in the same ViewController

