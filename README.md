To run: 
Clone or download the repo, 

no need to pod install. pod files are included

**IMPORTANT Note**
1. open 'medication-reminder.xcworkspace' go to medication-reminder/etc/GlobalModel.swift, change 'localIp' to ip address of the machine which the server is running on.
 e.g) If you are running the server on mac, go to 'Network Utility' -> Find IP Address under interface information, copy that to localIp variable

2. If you are testing on actual device, device must be connected to same wifi network as of the machine running the server

5 minute prior to medication time, 'Completed button' will be shown with yellow background
![ScreenShot](/screenshots/5before.PNG)

On medication time, there will be a chime sound notification sent and cell will be covered with reddish background
![ScreenShot](/screenshots/ontime.PNG)

5 minute after medication time, there will be annoying alarming notification sent adn data will be sent to 'Missed' controller. 
Missed tab will show badge to notify user that there are missed medication: 
![ScreenShot](/screenshots/after1.PNG)

And on Missed tab, it will be shown as: 
![ScreenShot](/screenshots/after2.PNG)

If user has clicked on 'Complete' button before passing 5minute to medication time, 
it will show alert view to double-confirm that user has done proper job and data will be sent to Completed tab

Completed tab will have specific time constraint when the button was clicked;
![ScreenShot](/screenshots/complete.PNG)

Medication Reminder Sample App
==============================

This app reminds individuals or their caregivers of upcoming and missed medications.

The view defaults to the current date. All medications for the selected day are displayed and ordered by time.

Beginning 5 minutes prior to medication time, a button will be enabled to mark the medication as completed.

At medication time there will be a chime sound and alert of which medication to take along with the dosage.

5 minutes after medication time there will be a louder, more annoying sound and the medication will be marked as missed.

There should be a visual indicator to differentiate between an upcoming medication, one that should be taken within +/-5 mins and one that has been missed.

### Technology Stack
* Alamofire
* SwiftyJSON

### Getting Started

1. Install XCode
2. Install Cocoapods
3. Clone this repository
4. pod install
5. Open the workspace
6. Run the project
