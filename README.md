# Automated Barney's Hide & Seek Game Any% No Controller Speedrun Setup

## Context

There's a category of speedrunning for the 1993 game [Barney's Hide & Seek](https://en.wikipedia.org/wiki/Barney's_Hide_%26_Seek_Game) called [Any% No Controller](https://www.speedrun.com/Barneys_Hide_and_Seek_Game#Any_No_Controller). In this run, you cannot touch the controller, and must instead let Barney himself finish the game (which he will inevitably do). The game resets itself once it reaches the credits, so Barney will continue completing the game for eternity if the game isn't turned off.

Due to what I can only assume to be built-in randomness, Barney doesn't take the same time to complete the game on every attempt (e.g. deciding to stop by a rooster and say "Look! A rooster!" on one run, but not another), which is where the motivation for this speedrunning category comes from. For (very unclear) reasons, it seems as if the current World Record for this category, 9 minutes and 9 seconds, can only be achieved on an original Sega Genesis, and not on an emulator.

Because of that belief, I decided to build this automated system to run Barney's game while also recording any good runs. In the beginning, it seemed like a simple idea: time how long Barney took and, if it's a record, save the recording to a file.

However, things turned out to be harder than I expected. Using the [BizHawk emulator](https://github.com/TASVideos/BizHawk), I could write Lua scripts to be executed during the game, and even managed to time each attempt, but I could not find an easy way of getting a video recording of the run. So I decided it would be a good idea to use [OBS Studio](https://obsproject.com/), which has a feature they call "Replay Buffer". In short, it records your screen non-stop until you press a certain combination of keys, in which case it then saves the last few minutes of recording to a file. This way, it doesn't clutter your hard drive with useless files, but still allows you to save recordings of your runs.

I still needed a way to simulate key presses to trigger OBS, which I couldn't do via the emulator script. So, I set up a [Node.js](https://nodejs.org/) server to run locally on my machine, using [RobotJS](http://robotjs.io/) to simulate the key presses. That way, the Lua script could send an HTTP request to the local server, which would then simulate the key presses and trigger OBS, that would in turn save the screen recording.

<!-- TODO: Add tutorial on how to use -->
