# Automated Barney's Hide & Seek Game Any% No Controller Speedrun Setup

![screenshot of my](https://i.imgur.com/jMsGNDs.png)

## Table of Contents
1. [Context](#context)
2. [How to use](#how-to-use)
    - [Setting up the Lua script](#lua)
    - [Setting up the Node.js server](#node)
    - [Setting up OBS Studio](#obs)
    - [Starting everything](#starting)
3. [Results](#results)

<a name="context"></a>
## Context

There's a category of speedrunning for the 1993 game [Barney's Hide & Seek](https://en.wikipedia.org/wiki/Barney's_Hide_%26_Seek_Game) called [Any% No Controller](https://www.speedrun.com/Barneys_Hide_and_Seek_Game#Any_No_Controller). In this run, you cannot touch the controller, and must instead let Barney himself finish the game (which he will inevitably do). The game resets itself once it reaches the credits, so Barney will continue completing the game for eternity if the game isn't turned off.

Due to what I can only assume to be built-in randomness, Barney doesn't take the same time to complete the game on every attempt (e.g. deciding to stop by a rooster and say "Look! A rooster!" on one run, but not another), which is where the motivation for this speedrunning category comes from. For (very unclear) reasons, it seems as if the current World Record for this category, 9 minutes and 9 seconds, can only be achieved on an original Sega Genesis, and not on an emulator.

Because of that belief, I decided to build this automated system to run Barney's game while also recording any good runs. In the beginning, it seemed like a simple idea: time how long Barney took and, if it's a record, save the recording to a file.

However, things turned out to be harder than I expected. Using the [BizHawk emulator](https://github.com/TASVideos/BizHawk), I could write Lua scripts to be executed during the game, and even managed to time each attempt, but I could not find an easy way of getting a video recording of the run. So I decided it would be a good idea to use [OBS Studio](https://obsproject.com/), which has a feature they call "Replay Buffer". In short, it records your screen non-stop until you press a certain combination of keys, in which case it then saves the last few minutes of recording to a file. This way, it doesn't clutter your hard drive with useless files, but still allows you to save recordings of your runs.

I still needed a way to simulate key presses to trigger OBS, which I couldn't do via the emulator script. So, I set up a [Node.js](https://nodejs.org/) server to run locally on my machine, using [RobotJS](http://robotjs.io/) to simulate the key presses. That way, the Lua script could send an HTTP request to the local server, which would then simulate the key presses and trigger OBS, that would in turn save the screen recording.

<a name="how-to-use"></a>
## How to use

<a name="lua"></a>
### Setting up the Lua script

To use the Lua script, open BizHawk and open the game ROM (how to get a ROM is outside the the scope of this article). Make sure you click "Emulation" -> "Pause" after opening the game. After that, click on "Tools" -> "Lua Console". Then, on the window that opens, click on "Script" -> "Open Script" and select the `barney.lua` file.

Make sure the script is activated. You can check that it is if the window has "1 script (1 active, 0 paused)" written over the script list. If it is **not** activated, either double click it or select it and then click the "Toggle script" button.

In case you make any changes while the script is running, remember to select the script and click the "Reload script" button. Keep in mind that reloading the script will erase any potential variable values from a previous script execution, so it's best to only do it if the variables are in a reset state (i.e. after a run is over, while the script waits for a new run to begin).

<a name="node"></a>
### Setting up the Node.js server

Copy the `server` folder and enter it. Then, run the command `npm install`. That'll install the dependencies required for the project.

Note: In case you get any errors about missing "VSBuild.exe", try running `npm install -g --production windows-build-tools`.

<a name="obs"></a>
### Setting up OBS Studio

First, adjust the preview to match what you'd like to record of your screen. You'll obviously want the emulator window to show up on the video, so make sure to set it up accordingly.

Now, click "File" -> "Settings", then "Output" on the sidebar. At "Replay Buffer", change "Maximum Replay Time (Seconds)" to something like 590 seconds (~9min 50s), which is enough time for the recording to save the entire Barney run. You can adjust under "Recording" the format and folder it'll save the file to.

Then, click on "Hotkeys" on the sidebar and, under "Replay Buffer", set up the "Save Replay" key combination. Set it to your preference, but remember to update it on `main.js` so that the Node server actually presses the right keys. You're done! You may now click "Ok" to close the settings window.

<a name="starting"></a>
### Starting everything

When you're ready to start recording, click on the "Start Replay Buffer" button under "Controls" on the bottom right of the OBS window. Then, start the Node local server by running `node .` inside the server directory. Lastly, don't forget to check if the Lua script is activated. You can now unpause the game ("Emulation" -> "Pause" on the emulator window) and let it play itself!

<a name="results"></a>
## Results

After letting this run for over 24 hours, and after over 200 attempts, Barney simply wasn't able to get any lower than 9:19.633… (according to the frame count, assuming 60fps; real time might differ slightly).

This could potentially be an issue with the ROM but, as some have previously reported, it might be a case that only an actual Sega Genesis console can get the elusive 9:09 time. Now, I couldn't possibly tell you *why* that is, but my results seem to align with the idea. This experiment isn't definitive proof of anything, really, but it's good enough for me. I'll settle with a (literal) 60+ way tie on 8+th place and leave this be. You can watch the 9:19 run I picked for submission [on YouTube](https://youtu.be/FOvqiIQgPLQ), or check it [on Speedrun.com](https://www.speedrun.com/Barneys_Hide_and_Seek_Game/run/zx4w0dqy).

If you've made it all the way down here, congratulations! I didn't expect anyone to read through all of this, considering it's a Barney game from over 25 years ago. Still, it was a lot of fun to experiment with this and, if you've got another game that plays itself and that you'd like to auto-record, hopefully this'll be helpful to you in some way or another. Cheers!
