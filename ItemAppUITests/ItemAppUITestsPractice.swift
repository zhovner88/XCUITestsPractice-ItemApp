//
//  ItemAppUITestsPractice.swift
//  ItemApp
//
//  Created by Denys Zhovnerovych on 2025-07-17.
//

import XCTest

class ItemAppUITestsPractice: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }



    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it's important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    @MainActor
    func testAddNewItem() throws {
        // --- GIVEN ---
        
        // --- WHEN ---
        // Tap the Add Item button to open the sheet
        let addButton = app.buttons[UIIdentifiers.ItemList.addButton]
        addButton.tap()
        
        // Find the text field and enter a new item name
        let textField = app.textFields["Item name"]
        textField.tap()
        textField.typeText("New Test Item")
        
        // Tap the Add Item button in the sheet
        let addItemButton = app.buttons[UIIdentifiers.AddNewItem.addButton]
        addItemButton.tap()
        
        // --- THEN ---
        // Verify the new item appears in the list
        XCTAssertTrue(app.staticTexts["New Test Item"].exists)
    }
    
    @MainActor
    func testAddEmptyItemShouldNotWork() throws {
        // --- GIVEN ---
        
        // --- WHEN ---
        // Tap the Add Item button to open the sheet
        let addButton = app.buttons[UIIdentifiers.ItemList.addButton]
        addButton.tap()
        
        // --- THEN ---
        // Try to add an empty item - the button should be disabled
        let addItemButton = app.buttons[UIIdentifiers.AddNewItem.addButton]
        XCTAssertFalse(addItemButton.isEnabled)
    }
    
    @MainActor
    func testDeleteAllItems() throws {
        // --- GIVEN ---
        
        // Verify initial items exist
        XCTAssertTrue(app.staticTexts["first"].exists)
        XCTAssertTrue(app.staticTexts["second"].exists)
        XCTAssertTrue(app.staticTexts["third"].exists)
        XCTAssertTrue(app.staticTexts["forth"].exists)
        
        let removeButton = app.buttons[UIIdentifiers.ItemList.deleteButton]
        
        // --- WHEN ---
        // Delete all items one by one
        removeButton.tap() // Remove "forth"
        removeButton.tap() // Remove "third"
        removeButton.tap() // Remove "second"
        removeButton.tap() // Remove "first"
        
        // --- THEN ---
        // Verify all items are removed
        XCTAssertFalse(app.staticTexts["forth"].exists)
        XCTAssertFalse(app.staticTexts["third"].exists)
        XCTAssertFalse(app.staticTexts["second"].exists)
        XCTAssertFalse(app.staticTexts["first"].exists)
        
        // Verify the remove button is now disabled
        XCTAssertFalse(removeButton.isEnabled)
    }
    
    @MainActor
    func testItemInteraction() throws {
        // --- GIVEN ---
        
        let firstItem = app.staticTexts["first"]
        
        // --- WHEN ---
        // Tap on the first item
        firstItem.tap()
        
        // --- THEN ---
        // Verify the item is still there after tapping
        XCTAssertTrue(firstItem.exists)
    }
    
    @MainActor
    func testScrollViewFunctionality() throws {
        // --- GIVEN ---
        
        // --- WHEN ---
        // Add multiple items to test scrolling
        for i in 1...10 {
            let addButton = app.buttons[UIIdentifiers.ItemList.addButton]
            addButton.tap()
            
            let textField = app.textFields["Item name"]
            textField.tap()
            textField.typeText("Scroll Item \(i)")
            
            let addItemButton = app.buttons[UIIdentifiers.AddNewItem.addButton]
            addItemButton.tap()
        }
        
        // Verify we can scroll through the items
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()
        scrollView.swipeDown()
        
        // --- THEN ---
        // Verify some items are still visible
        XCTAssertTrue(app.staticTexts["Scroll Item 10"].exists)
    }
    
    @MainActor
    func testItemAccessibilityIdentifiers() throws {
        // --- GIVEN ---
        
        // --- WHEN ---
        // Test that items have proper accessibility identifiers
        let predicate = NSPredicate(format: "identifier CONTAINS 'ItemList.item.'")
        let items = app.descendants(matching: .any).matching(predicate)
        
        // --- THEN ---
        XCTAssertTrue(items.count >= 4, "Should have at least 4 items with accessibility identifiers")
        
        // Verify specific item identifiers
        XCTAssertTrue(app.staticTexts["first"].exists)
        XCTAssertTrue(app.staticTexts["second"].exists)
        XCTAssertTrue(app.staticTexts["third"].exists)
        XCTAssertTrue(app.staticTexts["forth"].exists)
    }
    
    @MainActor
    func testSheetDismissal() throws {
        // --- GIVEN ---
        
        // --- WHEN ---
        // Open the add item sheet
        let addButton = app.buttons[UIIdentifiers.ItemList.addButton]
        addButton.tap()
        
        // Verify the sheet is presented
        XCTAssertTrue(app.textFields["Item name"].exists)
        
        // Dismiss the sheet by swiping down
        app.swipeDown()
        
        // --- THEN ---
        // Verify we're back to the main view
        XCTAssertTrue(app.buttons[UIIdentifiers.ItemList.addButton].exists)
    }
    
    @MainActor
    func testButtonStates() throws {
        // --- GIVEN ---
        
        let removeButton = app.buttons[UIIdentifiers.ItemList.deleteButton]
        let addButton = app.buttons[UIIdentifiers.ItemList.addButton]
        
        // Initially, remove button should be enabled
        XCTAssertTrue(removeButton.isEnabled)
        XCTAssertTrue(addButton.isEnabled)
        
        // --- WHEN ---
        // Delete all items
        for _ in 0..<4 {
            removeButton.tap()
        }
        
        // --- THEN ---
        // Now remove button should be disabled
        XCTAssertFalse(removeButton.isEnabled)
        XCTAssertTrue(addButton.isEnabled)
    }
    
    @MainActor
    func testAddMultipleItems() throws {
        // --- GIVEN ---
        
        let itemNames = ["Apple", "Banana", "Cherry", "Date"]
        
        // --- WHEN ---
        for itemName in itemNames {
            // Add new item
            let addButton = app.buttons[UIIdentifiers.ItemList.addButton]
            addButton.tap()
            
            let textField = app.textFields["Item name"]
            textField.tap()
            textField.typeText(itemName)
            
            let addItemButton = app.buttons[UIIdentifiers.AddNewItem.addButton]
            addItemButton.tap()
            
            // Verify item was added
            XCTAssertTrue(app.staticTexts[itemName].exists)
        }
        
        // --- THEN ---
        // Verify all items are present
        for itemName in itemNames {
            XCTAssertTrue(app.staticTexts[itemName].exists)
        }
    }
    
    @MainActor
    func testAllAccessibilityIdentifiersExist() throws {
        // --- GIVEN ---
        
        // --- WHEN ---
        // Test main screen elements
        XCTAssertTrue(app.buttons[UIIdentifiers.ItemList.deleteButton].exists, "Delete button should have accessibility identifier")
        XCTAssertTrue(app.buttons[UIIdentifiers.ItemList.addButton].exists, "Add button should have accessibility identifier")
        
        // Test initial items exist with their identifiers
        XCTAssertTrue(app.staticTexts["first"].exists, "First item should exist")
        XCTAssertTrue(app.staticTexts["second"].exists, "Second item should exist")
        XCTAssertTrue(app.staticTexts["third"].exists, "Third item should exist")
        XCTAssertTrue(app.staticTexts["forth"].exists, "Fourth item should exist")
        
        // Test sheet elements
        let addButton = app.buttons[UIIdentifiers.ItemList.addButton]
        addButton.tap()
        
        // --- THEN ---
        // Verify sheet elements have proper identifiers
        XCTAssertTrue(app.textFields["Item name"].exists, "Text field should be accessible")
        XCTAssertTrue(app.buttons[UIIdentifiers.AddNewItem.addButton].exists, "Add item button in sheet should have accessibility identifier")
        
        // Test that items have the expected accessibility identifier pattern
        let predicate = NSPredicate(format: "identifier CONTAINS 'ItemList.item.'")
        let items = app.descendants(matching: .any).matching(predicate)
        XCTAssertTrue(items.count >= 4, "Should have at least 4 items with 'ItemList.item.' accessibility identifiers")
    }
    
    @MainActor
    func testAccessibilityIdentifierConsistency() throws {
        // --- GIVEN ---
        
        // Test that all interactive elements can be found by their identifiers
        let deleteButton = app.buttons[UIIdentifiers.ItemList.deleteButton]
        let addButton = app.buttons[UIIdentifiers.ItemList.addButton]
        
        XCTAssertTrue(deleteButton.isEnabled, "Delete button should be enabled initially")
        XCTAssertTrue(addButton.isEnabled, "Add button should be enabled")
        
        // --- WHEN ---
        // Test sheet interaction through accessibility identifiers
        addButton.tap()
        
        let textField = app.textFields["Item name"]
        let addItemButton = app.buttons[UIIdentifiers.AddNewItem.addButton]
        
        XCTAssertTrue(textField.exists, "Text field should be accessible by placeholder text")
        XCTAssertFalse(addItemButton.isEnabled, "Add item button should be disabled when text field is empty")
        
        // Test text field interaction
        textField.tap()
        textField.typeText("Test Item")
        
        // --- THEN ---
        XCTAssertTrue(addItemButton.isEnabled, "Add item button should be enabled when text is entered")
    }
    
    @MainActor
    func testItemAccessibilityIdentifierPattern() throws {
        // --- GIVEN ---
        
        // --- WHEN ---
        // Test that items follow the expected accessibility identifier pattern
        let predicate = NSPredicate(format: "identifier CONTAINS 'ItemList.item.'")
        let items = app.descendants(matching: .any).matching(predicate)
        
        // --- THEN ---
        // Verify each item has the correct pattern
        for item in items.allElementsBoundByIndex {
            let identifier = item.identifier
            XCTAssertTrue(identifier.hasPrefix("ItemList.item."), "Item identifier should start with 'ItemList.item.'")
            
            // Extract the item name from the identifier
            let itemName = String(identifier.dropFirst(13)) // Remove "ItemList.item." prefix
            XCTAssertTrue(app.staticTexts[itemName].exists, "Item with name '\(itemName)' should exist")
        }
    }
}
