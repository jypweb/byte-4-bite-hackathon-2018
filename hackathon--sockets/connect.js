var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var axios = require('axios');

var settings = require('./config');
var api_url = settings.api_url;

var validSockets = {};

http.listen(3001, function(){
  console.log('listening on *:3001');
});

io.on("connection", function(socket) {
  socket.emit("auth-request", "Please authenticate");
  socket.on("login", function(data) {
    console.log("DATA!!!", data);
    axios.get(api_url + "/test" + (api_auth ? "?auth=" + api_auth : ""), {
      headers: {
        'Authorization': 'Bearer ' + data
      }
    })
    .then(function (response) {
      console.log("THE ID!!!!!" + response.data.currentUser.id);
      if (!validSockets["" + response.data.currentUser.id]) {
        validSockets["" + response.data.currentUser.id] = {};
      }
      validSockets["" + response.data.currentUser.id][socket.id] = socket;
      socket.on("disconnect", function() {
        console.log("Socket disconnected: ", socket.id);
        delete validSockets["" + response.data.currentUser.id][socket.id];
        socket.disconnect();
      });
      socket.emit("auth-success", "Logged in");
    })
    .catch(function (error) {
      console.log("ERROR!!!!!!!!!!!!!!", error.response.data);
      socket.emit("auth-failure", error.response.data.message);
      socket.disconnect();
    })
  });
});

var redis = require("redis").createClient();
// Redis Channels subscribe here
redis.subscribe("user-updated");

redis.on("message", function(channel, message) {
  try {
    var info = message;
    if (typeof message == "string") {
      var info = JSON.parse(message);
    }
    if (info.user && validSockets["" + info.user]) {
      for (var index in validSockets["" + info.user]) {
        if (validSockets[""+info.user].hasOwnProperty(index)) {
          console.log("Sending a message to users in group " + info.user);
          validSockets["" + info.user][index].emit(channel, info.data);
        }
      }
    }
  } catch(err) {
    console.log("ERROR!!!!!!\n", err);
  }
});
