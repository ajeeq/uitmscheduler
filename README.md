# UiTM Scheduler

Official repository of UiTM Scheduler. Built with Flutter, still in development and only has basic core functions. This app can collect list of course requested by user and provide the details of each course such as campus name, course name, group, start time, end time, day, mode, status, and room/class.

Featuring:
- Generated vertical TIMETABLE. Yes, you heard it right!
- Added time CLASH detection algorithm. No more class clashing here and there!

### Tidbits of this app project development:
About 2 years ago, this project was an idea of creating a mobile app version of UiTM Timetable. Initially, it begins with scraping the data directly from ICRESS website. Now the core functions of app (timetable and clash detection) are successfully been developed. Take note that this app is being build while I am learning how to code mobile application so don't expect too much from me.

For more info and behind the scene development, do join my Discord server [here](https://discord.gg/2uWksRgT).

# Screenshot Samples

### Splash Screen
![1](https://user-images.githubusercontent.com/60167498/193637705-d1be652d-f985-4233-bd1a-88d0708a5f1b.jpg)

### Home Screen
![2](https://user-images.githubusercontent.com/60167498/193637966-1258ac17-95bf-460f-bc84-bc9fea6d775d.jpg)

### Home screen (with selected course list in Course Selection Screen)
![3](https://user-images.githubusercontent.com/60167498/193638066-9f16fbfb-f67b-4bac-9772-d6a3da180c4f.jpg)

### Course Selection Screen
![4](https://user-images.githubusercontent.com/60167498/193638003-780a7e14-3709-4130-87fa-e811d171f68f.jpg)

### Detail Screen (Detail of every course selected)
![5](https://user-images.githubusercontent.com/60167498/193638166-2101a080-a35a-41c4-a52f-e5248833c150.jpg)

# Bugs
 - Fixed duplicated options in Autocomplete widget [here](https://github.com/ajeeq/uitmscheduler/commit/84797b8b633e54313b1b692898785f93bb04b09e)✅

# Milestones
 - Able to retrieve more than 1 selected course (List of Objects)✅
 - Vertical timetable✅
 - Time clash detection✅
 - Persisted state across app❌

