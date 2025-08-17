# ABInBev

Overview:
- Demo app to showcase Combine and Composable Architecture (TCA)
- Designed to handle slow network connections in foreground and background
- With time delayed retries, automatic reconnection and queue prioritization
- Uses a mocked API that simulates slow streamed network connection with async iterators
- Tap and hold to re-order priority and/or swipe to delete


Demo of main scenarios:



P2 Further Work:
- production standard error handling, monitoring and alert
- interactive widget for viewing uploads with iOS 26 Carplay Ultra
- live activity on lock screen and/or widgets to show dynamic upload progress in real time
- optimize concurrent connections, delay and timeouts with learning modal over time
- optimize successul uploads with scheduled tasks at specific time/day with the operating system
- add optional clean up process to remove cached files, failed downloads older than one month, etc.