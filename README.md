# YOLO FLUTTER

A YOLO Flutter Workshop!

Here we run some scripts to (hopefully) set everything up correctly. Then we YOLO against some Dart and Flutter.

I use [Excalidraw](https://excalidraw.com/) for my pretty pictures in `\planning\workshop.excalidraw`. You should be able to import that file and see what unspeakable horrors I've concocted.

## Setup

### 1a. Windows installation

As an administrator, run `\windows-setup.ps1` and accept any warnings that get thrown your way<sup>^</sup>.

### 1b. Mac/Linux(?) installation

Run the following run `sudo linux-setup.sh`, and accept any warnings that get thrown your way<sup>^</sup>.

## 2. Env File Setup

Ask Adam for an API key we can use on the day, and put this in a `.env` file at the root of the directory

## 3. Editor setup

Install the VSCode Flutter extension [here](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

## 4. Device Setup

### Android

If you're using a physical device:

- Run through the setup steps [here](https://flutter.dev/docs/get-started/install/windows#set-up-your-android-device) for Windows, and [here](https://flutter.dev/docs/get-started/install/macos#set-up-your-android-device) for iOS.

- If your `flutter devices` call doesn't pick up your device, ensure you've got the correct Android SDK version installed. For example, a Samsung Galaxy S9+ requires Android 10 (API 29). Use the Android Studio SDK to configure & install this, then restart your console and/or reconnect your device.

### iOS

- Run through the setup steps [here](https://flutter.dev/docs/get-started/install/macos#ios-setup).

> Note, that you cant do iOS development (from what I can see at least) on a Windows machine (question mark?).

### Web

While you _can_ dev for Flutter on Chrome (hell its what I've done most of this workshop on!), my recommendation would be to stick to Android or iOS for your device as they're both first-class citizens of the Flutter world. I think the Web experience is still a bit raw.

If you're _determined_ to do this (my sympathies), you'll have to do some extra setup to make Chrome temporarily forget about CORS and the like, otherwise you wont be able to call any APIs on the net. Apparently you can get around this by running a CORS proxy, but I dont currently know how to do this 🙃

See [here](https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code/66879350#66879350) on how to tweak Flutter's Chrome setup. I found this approach worked for me.

Alternatively, you can see [here](https://github.com/flutter/flutter/issues/46904#issuecomment-629363145) for a different approach if the above doesnt work for you.

---

## Workshop Steps!

1. `git checkout da38d09`: Hello world! - A basic flutter app with some things that need fixing.
2. `git checkout 11e95bd`: Fix some tests - Lets delve into testing with flutter and make sure our tests are working correctly.
3. `git checkout 007021b`: Add our dependencies - We need to add a HTTP client and a dotenv library to make our things work!
4. `git checkout 30cc4d8`: Set up our Search Screen and request something from the tracker.gg API.
5. `git checkout 8f3f3ee`: Make our nav experience a bit more coherent.

---

## Known Issues (lol because of course there are!)

1. The state of the `FancyButton` controller doesnt seem to handle the change for the `status` property, resulting in the CircularProgressIndicator spinner not loading/showing correctly. It'll eventually just pop into a 'Open result' button instead. NFI what I've done wrong here. The code for this was ~~shamelessly stolen~~ borrowed from [this](https://flutter.dev/docs/cookbook/effects/download-button) cookbook entry on the Flutter docs. Bonus points if you can figure this out.

   - I'm pretty sure its because I changed my `FancyButton`'s ctor arguments to _not_ use the state variables I'd set up on the `search.dart` form. I was trying to keep everything within `FancyButton`, nice and neatly contained. More fool me.

<sup>^ :: whispers :: I did say it was a YOLO workshop.
