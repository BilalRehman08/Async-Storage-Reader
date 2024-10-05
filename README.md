# Migrate Local Data from React Native to Flutter - async_storage_reader 


A Flutter package created to assist in migrating data from a React Native app by accessing and reading AsyncStorage for Android and iOS. It allows reading of AsyncStorage data from react native app, like user session tokens, preferences, other configurations, and cached data are preserved without logging out or data loss during migration to a new Flutter app.

### Why This Package?
When migrating from React Native to Flutter, one of the most significant challenges is ensuring that existing data stored in the app is preserved. This could include user session tokens, settings, cached preferences, or any other key-value pairs that were previously stored using React Native's AsyncStorage. Without this, users might lose their preferences or be logged out. This package solves the problem by offering an easy way to access all AsyncStorage in your new Flutter app. 

### Demo Preview

![Demo Preview](https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExMTQydGs1M2Y2b3kyM2M4ZDJiZWR0MWh6a3l2ZjRheTFlNms5aXVneiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/0XGU8iKdhs0To3nzKM/giphy.gif)

### Platform Support for async_storage_reader

The `async_storage_reader` package provides support for both Android and iOS platforms. 

### Features
- Read individual key-value pairs from React Native's AsyncStorage.
- Retrieve all key-value pairs stored in AsyncStorage.
- Support for both Android and iOS platforms.
- Prevent user logouts during app migrations by retrieving session tokens or other vital data.
- Provides methods to read, remove, and clear storage data.

### Getting Started

To use this package, add `async_storage_reader` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  async_storage_reader: ^1.0.0
```

### Example Usage

```dart
import 'package:async_storage_reader/async_storage_reader.dart';

final reader = AsyncStorageReader();

String? value = await reader.getItem('your_key');
print(value);  

Map<String, String> allItems = await reader.getAllItems();
print(allItems);  

bool success = await reader.removeItem('your_key');
print(success);  

bool success = await reader.clear();
print(success);  
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


## Connect With Me

[![GitHub: bilalrehman08](https://img.shields.io/badge/bilalrehman08-EFF7F6?logo=GitHub&logoColor=333&link=https://www.github.com/bilalrehman08)][github] [![Linkedin: bilalrehman08](https://img.shields.io/badge/bilalrehman08-EFF7F6?logo=LinkedIn&logoColor=blue&link=https://www.linkedin.com/in/bilalrehman08)][linkedin] [![YouTube: Bilal Rehman](https://img.shields.io/badge/Bilal%20Rehman-EFF7F6?logo=YouTube&logoColor=FF0000&link=https://www.youtube.com/@bilalrehman08)][youtube] [![Instagram: bilalrehman08](https://img.shields.io/badge/bilalrehman08-EFF7F6?logo=Instagram&link=https://www.instagram.com/bilalrehman08)][instagram] [![Gmail: bilalrehman080808@gmail.com](https://img.shields.io/badge/bilalrehman080808@gmail.com-EFF7F6?logo=Gmail&link=mailto:bilalrehman080808@gmail.com)][gmail]

[github]: https://github.com/BilalRehman08
[instagram]: https://instagram.com/bilalrehman08
[linkedin]: https://linkedin.com/in/bilalrehman08
[gmail]: mailto:bilalrehman080808@gmail.com
[youtube]: https://www.youtube.com/@bilalrehman08
[license]: https://github.com/BilalRehman08/Async-Storage-Reader/blob/main/LICENSE


