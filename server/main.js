// Load HTTP module
const http = require("http");

// Define "url" to be pinged
const hostname = "127.0.0.1";
const port = 3000;

// Robotjs module for simnulating key presses
const robot = require("robotjs");

// Avoid multiple key press requests simultaneously
let pressing = false;

// Create HTTP server and listen on port 3000 for requests
const server = http.createServer((req, res) => {
  // Log each received request
  console.log("received request!");
  // If a previous key press request isn't already being fulfilled
  if(!pressing) {
    // Log key press
    console.log("pressing");
    // Prevent other key presses from being triggered
    pressing = true;
    // Press <Ctrl Shift Alt F10> (which is my personal combination for OBS)
    robot.keyToggle("shift","down");
    robot.keyToggle("control","down");
    robot.keyToggle("alt","down");
    robot.keyToggle("f10","down");
    // Wait 1 and a half second and call unpress()
    setTimeout(unpress, 1500);
    // Note: I think 1.5s is too much. Sometimes it seems as if OBS is being
    // triggered twice. Didn't test with other values, though.
  } else {
    console.log("already pressing");
  }

  // Return request (the response isn't used by the Lua script)
  res.statusCode = 200;
  res.setHeader("Content-Type", "text/plain");
  res.end("pressed");
});

function unpress() {
  // Log key unpressing
  console.log("unpressing");
  // Unpress <Ctrl Shift Alt F10>
  robot.keyToggle("shift","up");
  robot.keyToggle("control","up");
  robot.keyToggle("alt","up");
  robot.keyToggle("f10","up");
  // Allow for new requests to be made
  pressing = false;
}

// Listen for request on port 3000
server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
