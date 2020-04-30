# Accessible-Block-Coding
Our goal is to create an iOS application which allows visually impaired students to learn the basic concepts of computer programming by moving a Sphero robot through some maze or obstacle course in the classroom.

## Code Overview
The project is an iPad application targeting iOS 13 or newer

The application also interfaces with the Sphero SPRK+ hardware via Bluetooth

## Code Ownership
The codebase is open source, meaning that any future contributor can download, modify, and update the code via Git. 
No direct action must be taken to keep the code available moving forward.

# Code Installation
## Via XCode - 
Connect iPad to computer

Select the Blocks_X tab on the left side of project navigator

Select the “Signings & Capabilities” tab

In the box next to “Team”, select add Account, and input either the development credentials provided, or your personal iTunes account information if you don’t have access to the development credentials.

Select your device from the “Active Scheme” tab in the top left of XCode

Build and run the program


## Via TestFlight - (Contact a team member for TestFlight invitation)
Install TestFlight app on iPad

Click “View in TestFlight” button on email link

Go to TestFlight and choose “Install app”

Once the app is installed, open and run it via the home screen


## Sphero Controller
SpheroController.swift contains the CoreBluetooth implementation of a Sphero SPRK+ controller, largely using code from [this Apple project](https://developer.apple.com/swift/blog/?id=38) with some custom functions for use with the app's block structure.  The core functionality of the controller with regard to this project (connecting to the hardware, turning left or right by a given number of degrees, moving forward or backwards by a given distance in meters) is implemented within this framework. 

Sphero itself does not provide any documentation for the SPRK+'s API, so other resources were consulted to figure out how to put the project together. In terms of understanding the SPRK+ BLE interface, the Python ROS driver [here](https://github.com/antonellabarisic/sphero_sprk_ros) is a good jumping-off point for the command values and packet structure. Resources for Apple's CoreBluetooth library can be found [here;](https://developer.apple.com/documentation/corebluetooth) however, the documentation can be unclear if you aren't already familiar with Swift and BLE. 
