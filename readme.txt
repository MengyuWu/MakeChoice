Model design

User:
Friend: user(pointer), friend(pointer)
Post: choice(pointer), votes, totalVotes, poster, isPrivate
Choice: post(pointer), image

votes: post(pointer), voter(point user) choice(pointer)

I fixed it by referencing the bridging header in Build Settings.

Under Build Settings, make sure the Objective-C Bridging Header build setting under Swift Compiler - Code Generation has a path to the header. The path should be relative to your project, similar to the way your Info.plist path is specified in Build Settings. In most cases, you should not need to modify this setting.
I just typed in the name of the bridging header folderName/xxxx-BridgingHeader.h in the field that states bridging header and all was well again.


2. In your project build settings, find Swift Compiler – Code Generation, and next to Objective-C Bridging Header add the path to your bridging header file, from the project’s root folder. So it could by MyProject/MyProject-Bridging-Header.h or simply MyProject-Bridging-Header.h if the file lives in the project root folder.

new_message: resources/jsqmessagesAssets.bundle/base/.string