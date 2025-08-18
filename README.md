# ABInBev

Minimum Requirements:
- Xcode 16, Swift 5 and iOS 18

Overview:
- Demo survey app that showcases Combine, Composable Architecture (TCA), SwiftUI, robust network handling and background task processing
- Designed for slow network connections in both foreground and background
- Time delayed retries, increased timeouts, automatic reconnection/retry and queue prioritization
- Persists surveys on disk (documents directory) for easy/quick demo purposes
- Uses a mocked API to simulate slow network connections with a streamed response using async iterators for faster/dynamic response rendering
- Drag and drop to re-order priority and/or swipe to delete items
- Main parts include ListReducer for handling survey state management, SurveyReducer for handling publishing combine network updates + foreground/background and UploadClient for handling background tasks

Demo videos:
- Device going in and out of poor network (automatically reconnecting)
https://www.dropbox.com/scl/fi/3hl4pxj2hfp1fim99ldl8/ConnectionInAndOutAutoReconnect.MP4?rlkey=m1p150oote789m33mgrnlpp0z&st=nyn1e5cc
- Requests processing with background tasks (can be over an extended period of time, device can be not running and again automatic retry)

Device part: https://www.dropbox.com/scl/fi/fasabw1v7mh8fdhqjob3i/backgroundtaskiphone.mov?rlkey=1kzquec75jk0pu3xtmjztmsbe&st=ds6wg46i

Xcode and server part: https://www.dropbox.com/scl/fi/al374whi5szrcj7k3nua9/backgroundtaskxcodeandserver.mov?rlkey=vaqkp01appfdo9ltzuj0cvwga&st=cdsyjpbw

NOTE: in case you need debug trigger for xcode the steps and statement (e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.henryheleine.ABInBev.backgroundTask"]) can be found at:
https://developer.apple.com/documentation/backgroundtasks/starting-and-terminating-tasks-during-development
- Operation Queue (set to max concurrent = 2 for demo purposes) with priority change on drag n drop
https://www.dropbox.com/scl/fi/s8kc9m2qauvkio3m286f4/PrioritizeRequests.MP4?rlkey=kcy233ghruzmvag81u6ut8na8&st=0iswppmv
- Delete survey and cancel request on swipe
https://www.dropbox.com/scl/fi/dyfhzziq815po6rc86t6g/SwipeToDelete.MP4?rlkey=sgqyzr85iztd121vg28gwd1dx&st=n3gps86j

P2 Further Work:
- Integrate production level monitoring, error handling, alerting and security
- For this demo the network requests are entirely cancelled and retried however with a full server setup the resume data APIs could be used with tasks to reduce total bytes processed
- Optimize concurrent connections, delay and timeouts based on success model over time
- Integrate clean up process to remove old/cached files, failed downloads older than one month, etc. to improve app resources/size
- Scheduled networking tasks with the operating system at times/locations that historically provide the best success rates for the user
- Integrate a dynamic lock screen live activity to show dynamic request progress in real time
(many applications similar to: https://www.youtube.com/watch?v=DytXQ3-igPs)
- Integrate an interactive widget for viewing request progress and with iOS 26 via Carplay (Ultra)
https://developer.apple.com/videos/play/wwdc2025/278/