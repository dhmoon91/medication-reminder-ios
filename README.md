To run: 
Clone or download the repo, 

no need to pod install. pod files are included

open 'medication-reminder.xcworkspace' go to medication-reminder/etc/GlobalModel.swift, change 'localIp' to ip address of the machine which the server is running on.
 e.g) If you are running the server on mac, go to 'Network Utility' -> Find IP Address under interface information, copy that to localIp variable

*Make sure the server is running on localhost.*

**IMPORTANT NOTE**
1. If you are testing on actual device, device must be connected to same wifi network as of the machine running the server
2. Closing and re-opening the app will reset the datas 


If you would like to test the app using different data set, there seems to be a bug from time to time where short time frame between medications (let say <1min) 
can cause notifications to stack up and not launch.

But the app should work for originally provided dataset and requirements. 

======================================================================
5 minute prior to medication time, 'Completed button' will be shown with yellow background

<img  src = "/screenshots/5before.png"  height="700" width="400" />


On medication time, there will be a chime sound notification sent and cell will be covered with reddish background:

<img  src = "/screenshots/ontime.png"  height="700" width="400" />


5 minute after medication time, there will be annoying alarming notification sent and data will be sent to 'Missed' controller. 
Missed tab will show badge to notify user that there are missed medication: 

<img  src = "/screenshots/after1.png"  height="700" width="400" />


And on Missed tab, it will be shown as:

<img  src = "/screenshots/after2.png"  height="700" width="400" />


If user has clicked on 'Complete' button before passing 5minute to medication time, 
it will show alert view to double-confirm that user has done proper job and data will be sent to Completed tab


Completed tab will have specific time constraint when the button was clicked;

<img  src = "/screenshots/complete.png"  height="700" width="400" />


Some Decisions I Made
===========================================================
1) Getting Whole medication data when app launches.
2) I added two other date datas to the root model meds;
	First one is formatted date, to use later when setting timers, notifications, etc. 
	Second one is simple YYYY-MM-DD data, used to query medicatoins on specific date.
4) I'm assuming that there are no duplicate medication time. 
5) Most of view controllers have similar code and layout (except MainController()) I couldn've put it all in one file,
	but decided to separte them per tab item for better readability.

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
