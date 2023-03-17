# UiTM Scheduler

Official repository of UiTM Scheduler. Built with Flutter, still in development and only has basic core functions. This app can collect list of course requested by user and provide the details of each course such as campus name, course name, group, start time, end time, day, mode, status, and room/class.

## Featuring:
- Generated vertical TIMETABLE. Yes, you heard it right!
- Added time CLASH detection algorithm. No more class clashing here and there!

## Tidbits of this app project development:
About 2 years ago, this project was an idea of creating a mobile app version of UiTM Timetable. Initially, it begins with scraping the data directly from ICRESS website. Now the core functions of app (timetable and clash detection) are successfully been developed. Take note that this app is being build while I am learning how to code mobile application so don't expect too much from me.

For more info and behind the scene development, do join my Discord server [here](https://discord.gg/uTwBPShWdz).

## Screenshot Samples (V0.5.2)
| Splash Screen | Side Drawer | Home Screen | Home screen (Course List) | Campus Selection Screen |
| --- | --- | --- | --- | --- |
![1](https://user-images.githubusercontent.com/60167498/226021952-0c06ffe8-9476-401e-b62e-797b0ef57966.png) | ![2](https://user-images.githubusercontent.com/60167498/226025109-35a6d78e-b2ff-4747-ae0b-e46817660a72.png) | ![3](https://user-images.githubusercontent.com/60167498/226022121-31892712-dcb6-4814-86f5-d67a34bccb11.png) | ![4](https://user-images.githubusercontent.com/60167498/226022375-a6c78aa4-5271-4ce5-8202-ec5bd33c5ae2.png) | ![5](https://user-images.githubusercontent.com/60167498/226022836-a3a2d4e9-0e3a-4245-9fc1-bb6f9239859d.png)

| Faculty Selection Screen | Course Selection Screen | Group Selection Screen | Result Screen |
| --- | --- | --- | --- |
| ![6](https://user-images.githubusercontent.com/60167498/226024097-e2d76d39-da49-4ced-a8f6-eab2683bda0e.png) | ![7](https://user-images.githubusercontent.com/60167498/226024278-e8ee8833-f2e0-46ad-baba-234fafd0bcfc.png) | ![8](https://user-images.githubusercontent.com/60167498/226024382-39af34c1-2e17-49a3-94c3-5c00a4ef29f5.png) | ![9](https://user-images.githubusercontent.com/60167498/226024580-eaa79ae9-fdb7-4a52-97ad-be3449e14f1a.png)

## Bugs
 - Fixed duplicated options in Autocomplete widget [here](https://github.com/ajeeq/uitmscheduler/commit/84797b8b633e54313b1b692898785f93bb04b09e)✅

## Milestones
 - Able to retrieve more than 1 selected course (List of Objects)✅
 - Vertical timetable✅
 - Time clash detection✅
 - Persisted state across app✅

