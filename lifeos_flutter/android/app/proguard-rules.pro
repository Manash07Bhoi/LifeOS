# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Hive
-keep class path_provider.** { *; }
# Keep play core missing classes to satisfy R8 compiler when it tree-shakes
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
