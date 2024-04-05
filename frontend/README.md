# Setting Up Flutter Environment

Flutter is a popular open-source UI software development toolkit created by Google. It allows developers to build natively compiled applications for mobile, web, and desktop from a single codebase. Follow the steps below to set up your Flutter development environment.

## 1. Install Flutter

- Visit the [Flutter website](https://flutter.dev/) and download the latest stable release for your operating system (Windows, macOS, or Linux).
- Extract the downloaded ZIP file to a location on your machine.
- Add the Flutter `bin` directory to your system's `PATH` variable. This can be done by adding the following line to your shell profile file (e.g., `.bashrc`, `.zshrc`, or `.bash_profile`):

  ```bash
  export PATH="$PATH:<path_to_flutter_directory>/flutter/bin"

## 2. Install Visual Studio Code (Optional)

While you can use any text editor or IDE with Flutter, Visual Studio Code (VSCode) is a popular choice with excellent Flutter support.

- Download and install [Visual Studio Code](https://code.visualstudio.com/).
- Install the "Dart" and "Flutter" extensions in VSCode for a better development experience.

## 3. Starting the project.

```
flutter run -d chrome
```