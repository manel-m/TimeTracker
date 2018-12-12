# TimeTracker
Time tracker is an application that help build good habits and allows its users to record time spent on tasks or projects.

Goals :
   - Track time for multiple projects.
   - Define goals (weekly goals): how much time to work on a project.
   - Show statistics about time tracked.
   
Functionalities:
   - Manage Projects : add and delete.
   - Start, pause and stop Timer for a chosen project.
   - Manage Goals: add, update and delete.
   - View project list with total time tracked for each project.
   - View project list with goal for each project.
   - Save and retrieve projects and total durations for each project from web server (Firebase API).
   - Persist projects and goals locally using Core Data.
   
To do list :
  - Support using the app across multiple devices simultaneously.
  - Display tasks and projects in Calender.
  - Add reminder.
  
Prerequisites for Firebase :
  - Install CocoaPods (https://guides.cocoapods.org/using/getting-started.html#getting-started).
  - Execute pod install in the project directory in terminal
  - Open the .xcworkspace file.
  
Notes :
   - We don’t need a separate class for networking as its already encapsulated by the Firebase client.
   - We used the Firebase Database to store the total duration for all projects to allow future extension of the app to support multiple devices.
  - We used Core Data to store the individual tasks as they are not necessarily needed across multiple devices, and will allow future extension of the app to display the tasks in a calendar.

  

   




