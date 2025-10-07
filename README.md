# UiTM Scheduler

Official repository of UiTM Scheduler. Built with Flutter, still in development and only has basic core functions. This app can collect list of course requested by user and provide the details of each course such as campus name, course name, group, start time, end time, day, mode, status, and room/class.

## Featuring:
- Generated vertical TIMETABLE. Yes, you heard it right!
- Added time CLASH detection algorithm. No more class clashing here and there!

## Tidbits of this app project development:
About 4 years ago, this project was an idea of creating a mobile app version of UiTM Timetable. Initially, it begins with scraping the data directly from ICRESS website. Now the core functions of app (timetable and clash detection) are successfully been developed. Take note that this app is being build while I am learning how to code mobile application so don't expect too much from me.

For more info and behind the scene development, do join my Discord server [here](https://discord.gg/uTwBPShWdz).

## Screenshot Samples (V0.7.0)
| Splash Screen | Side Drawer | Home Screen | Home screen (Course List) | Campus Selection Screen |
| --- | --- | --- | --- | --- |
![1](https://github.com/ajeeq/uitmscheduler/assets/60167498/6655fb06-11ed-4e2c-b725-4ffc053ff009) | ![2](https://github.com/ajeeq/uitmscheduler/assets/60167498/0071bf4e-abbc-477f-b08f-490ffd5c5307) | ![3](https://github.com/ajeeq/uitmscheduler/assets/60167498/e9fd09ec-db62-46d3-919c-5cdd115ad2ce) | ![4](https://github.com/ajeeq/uitmscheduler/assets/60167498/42967d4d-5141-4439-a066-c8e570d812df) | ![5](https://github.com/ajeeq/uitmscheduler/assets/60167498/7306b342-9713-4c2e-8ea3-230bfb319bae)

| Faculty Selection Screen | Course Selection Screen | Group Selection Screen | Result Screen |
| --- | --- | --- | --- |
| ![6](https://github.com/ajeeq/uitmscheduler/assets/60167498/acb5ff8f-3246-44ab-abf8-7dcf217d249c) | ![7](https://github.com/ajeeq/uitmscheduler/assets/60167498/05155894-e2a7-49ff-b6e7-975069ea4c05) | ![8](https://github.com/ajeeq/uitmscheduler/assets/60167498/dac37ba4-23ea-453a-b052-26e0b6388c1a) | ![9](https://github.com/ajeeq/uitmscheduler/assets/60167498/1e28241b-0529-4c98-8dc0-b32c70adc222) |

## Bugs
 - Fixed duplicated options in Autocomplete widget [here](https://github.com/ajeeq/uitmscheduler/commit/84797b8b633e54313b1b692898785f93bb04b09e)✅

## Milestones
 - Able to retrieve more than 1 selected course (List of Objects)✅
 - Vertical timetable✅
 - Time clash detection✅
 - Persisted state across app✅
