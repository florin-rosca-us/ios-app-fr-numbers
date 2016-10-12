# Count With Me
Teach toddlers numbers from 1 to 10 using your voice.

## Background
Toddlers seem to enjoy swiping back and forth on phones and tablets, but they always seem to be able to reach the phone's settings and mess it up.
Even with "Guided Access" mode on, if the app has any configuration settings, they will reach that too.

I wanted a simple unbreakable app able to run in "Guided Access" mode without any settings or options that shows one number at a time and reads it back loud.

## Implementation
Xcode has a wizard for getting started with a Page-Based Application that creates a `UIPageViewControllerDelegate` and a `UIPageViewControllerDataSource`, which seems to be a good place to start. This application adds 10 pages and draws a label on each page with different colors.

For audio, this application uses System Sound Services to play one m4a file for each number currently showing, after a swipe or when the application comes to foreground.

## Challenges
Without any synchronization, if the sound starts playing and a swipe happens right away, then the new sound will start right away and override the previous sound mid-word, creating a stuttering effect. This application uses a synchronized queue for playing sounds.

## Screenshots
![1](Docs/cw01.png?raw=true) ![2](Docs/cw02.png?raw=true) ![3](Docs/cw03.png?raw=true)
