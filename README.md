![1](Docs/1234_80x80.png?raw=true)

# Count With Me
Teach toddlers numbers from 1 to 10 using your voice.

## Background
Toddlers seem to enjoy swiping back and forth on phones and tablets, but they always seem to be able to reach the phone's settings and mess it up.
Even with "Guided Access" mode on, if the app has any configuration settings, they will reach that too.

I wanted a simple unbreakable app able to run in "Guided Access" mode without any settings or options that shows one number at a time and reads it back loud.

## Implementation
Xcode has a wizard for getting started with a Page-Based Application that creates a `UIPageViewControllerDelegate` and a `UIPageViewControllerDataSource`, which seems to be a good place to start. This application adds 10 pages and draws a label on each page with different colors.

For audio, this application uses System Sound Services to play a short `m4a` file for each number currently showing, after a swipe or when the application comes to foreground.

## Challenges
Without any synchronization, if the sound starts playing and a swipe happens right away, then the new sound will start right away and override the previous sound mid-word, creating a stuttering effect. This application uses a synchronized queue for playing sounds.

## Importing Audio From Other Apps
This application adds an extension for importing audio from other apps. For example, the user can create an audio recording for each number using the Voice Memos app and use them in this application instead of the default audio. This application provides an option to reset to the default audio.

## Screenshots
Swiping through numbers:

![1](Docs/cw01.png?raw=true) ![2](Docs/cw02.png?raw=true) ![3](Docs/cw03.png?raw=true)

Importing from Voice Memos:

![Choose](Docs/vm02.png?raw=true) ![Export](Docs/vm03.png?raw=true) ![Assign](Docs/vm04.png?raw=true)

Option to reset audio:

![Reset](Docs/op01.png?raw=true)
