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

## 4. Mobile Device Setup

### Android

If you're using a physical device:

- Run through the setup steps [here](https://flutter.dev/docs/get-started/install/windows#set-up-your-android-device) for Windows, and [here](https://flutter.dev/docs/get-started/install/macos#set-up-your-android-device) for iOS.

- If your `flutter devices` call doesn't pick up your device, ensure you've got the correct Android SDK version installed. For example, a Samsung Galaxy S9+ requires Android 10 (API 29). Use the Android Studio SDK to configure & install this, then restart your console and/or reconnect your device.

---

## Workshop Steps!

1. Hello world! - A basic flutter app with some things that need fixing. Run `git checkout da38d09` to go to/back to this commit.
2. Fix some tests - Lets delve into testing with flutter and make sure our tests are working correctly. Run `git checkout 11e95bd` to go to/back to this commit.

---

<sup>^ :: whispers :: I did say it was a YOLO workshop.
