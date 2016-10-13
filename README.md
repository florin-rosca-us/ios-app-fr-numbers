![1](Docs/1234_80x80.png?raw=true)

# Count With Me
An iOS application for teaching toddlers numbers from 1 to 10 using your voice.

## Background
Toddlers seem to enjoy swiping back and forth on phones and tablets, but they always seem to be able to reach the phone's settings and mess it up.
Even with "Guided Access" mode on, if the application has any configuration settings, they will reach that too.

I wanted a simple toddler-proof application able to run in "Guided Access" mode without access to any settings or options from within the application, to show one number at a time and read it back loud, then switch to the next number after a swipe.

## Implementation
Xcode has a wizard for getting started with a Page-Based Application that creates a `UIPageViewControllerDelegate` and a `UIPageViewControllerDataSource`, which seems to be a good place to start. This application adds 10 pages and draws a label on each page with different colors.

For audio, this application uses [System Sound Services](https://developer.apple.com/reference/audiotoolbox/1657326-system_sound_services) to play a short `m4a` file for each number currently showing, after a swipe or when the application comes to foreground.

### Challenges
[System Sound Services](https://developer.apple.com/reference/audiotoolbox/1657326-system_sound_services) does not wait for the currently playing audio to finish before playing a new one. However, it provides a callback that indicates when playing audio is finished. The application starts playing an audio file when the user does a swipe. Without any synchronization, if audio starts playing and a new swipe event happens right away, the new audio starts and replaces the previous audio mid-word, creating a stuttering effect. To avoid that, the application synchronizes audio using a queue.

### Importing Audio From Other Applications
This application adds an [extension](https://developer.apple.com/library/content/documentation/General/Conceptual/ExtensibilityPG/) for importing audio from other applications such as Voice Memos and use that instead of the default audio. This can be used by parents to teach numbers in their own voice or even to teach numbers in another language. There is an option to reset to the default audio.

The extension shares data with this application. To make that possible, the application has the App Group [capability](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/AddingCapabilities/AddingCapabilities.html) enabled. If you want to build the application, you will need your own Apple Developer account and an App Group ID. To change the App Group ID, edit [FRAppConstants.h](FRNumbers/FRAppConstants.h) and change the `FRAppGroup` constant.

### Localization
This applications currently supports English and Romanian.

## Screenshots
Swiping through numbers:

![1](Docs/cw01.png?raw=true) ![2](Docs/cw02.png?raw=true) ![3](Docs/cw03.png?raw=true)

Importing from Voice Memos:

![Choose](Docs/vm02.png?raw=true) ![Export](Docs/vm03.png?raw=true) ![Assign](Docs/vm04.png?raw=true)

Option to reset audio:

![Reset](Docs/op01.png?raw=true)
