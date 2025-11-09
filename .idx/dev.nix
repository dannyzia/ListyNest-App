{ pkgs, ... }:

let
  # 1. Import Nixpkgs with configuration to allow the proprietary Android SDK.
  pkgsWithAndroid = import pkgs.path {
    system = pkgs.stdenv.system;
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };
  };

  # 2. Define a complete Android SDK environment.
  androidComposition = pkgsWithAndroid.androidenv.composeAndroidPackages {
    platformVersions = [ "34" ];
    buildToolsVersions = [ "34.0.0" ];
    
    # Use the latest actual version instead of "latest"
    cmdLineToolsVersion = "11.0";
    
    includeNDK = false;
    includeSystemImages = false;
  };

in {
  # 3. Update the packages list
  packages = [
    # Flutter itself
    pkgsWithAndroid.flutter

    # Add the Android SDK platform-tools
    androidComposition.platform-tools
    
    # General build tools
    pkgsWithAndroid.unzip
    pkgsWithAndroid.which
    pkgsWithAndroid.git
    pkgsWithAndroid.gcc
    pkgsWithAndroid.clang
    pkgsWithAndroid.cmake
    pkgsWithAndroid.ninja
    pkgs.pkg-config

    # Go for backend services
    pkgs.go

    # Libraries for Flutter Linux builds
    pkgs.gtk3
    pkgs.webkitgtk
    pkgs.glib
    pkgs.json-glib
    pkgs.lucene
    pkgs.pango
    pkgs.cairo
    pkgs.atk
    pkgs.gdk-pixbuf
    pkgs.at-spi2-atk
    pkgs.libxkbcommon
    pkgs.libinput
    pkgs.xorg.libX11
    pkgs.xorg.libXext
    pkgs.xorg.libXrandr
    pkgs.xorg.libXinerama
    pkgs.xorg.libXi
    pkgs.xorg.libXcursor
    pkgs.xorg.libXdamage
    pkgs.xorg.libXfixes
    pkgs.xorg.libXrender
    pkgs.xorg.libXcomposite
    pkgs.xorg.libXtst
    pkgs.mesa
    pkgs.vulkan-loader
  ];

  # 4. Set environment variables
  env = {
    # Point to the Android SDK root
    ANDROID_SDK_ROOT = "${androidComposition.androidsdk}/libexec/android-sdk";
    ANDROID_HOME = "${androidComposition.androidsdk}/libexec/android-sdk";
  };

  idx = {
    extensions = [
      "dart-code.flutter"
    ];

    previews = {
      enable = true;
      previews = {
        flutter = {
          manager = "flutter";
        };
      };
    };

    workspace = {
      onCreate = {
        flutter-pub-get = "flutter pub get";
      };
    };
  };
}