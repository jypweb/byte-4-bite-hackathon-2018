var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var axios = require('axios');

var settings = require('./config');
var api_url = settings.api_url;

var validSockets = {};
var adminSockets = {};

http.listen(3001, function(){
  console.log('listening on *:3001');
});

io.on("connection", function(socket) {
  socket.emit("auth-request", "Please authenticate");
  socket.on("login", function(data) {
    axios.get(api_url + "/test", {
      headers: {
        'Authorization': 'Bearer ' + data
      }
    })
    .then(function (response) {
      if (response.data.currentUser.is_admin) {
        console.log("Adding to adminSockets");
        adminSockets[socket.id] = socket;
        socket.on("disconnect", function() {
          console.log("Admin Socket disconnected: ", socket.id);
          delete adminSockets[socket.id];
          socket.disconnect();
        })
      } else {
        if (!validSockets["" + response.data.currentUser.id]) {
          validSockets["" + response.data.currentUser.id] = {};
        }
        console.log("Adding to validSockets");
        validSockets["" + response.data.currentUser.id][socket.id] = socket;
        socket.on("disconnect", function() {
          console.log("Socket disconnected: ", socket.id);
          delete validSockets["" + response.data.currentUser.id][socket.id];
          socket.disconnect();
        });
      }
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
redis.subscribe("order-created");
redis.subscribe("order-updated");
redis.subscribe("order-cancelled");

redis.on("message", function(channel, message) {
  console.log("received message");
  try {
    var info = message;
    if (typeof message == "string") {
      var info = JSON.parse(message);
    }
    console.log("INFO!!!!!!!!", info)
    if (info.user && validSockets["" + info.user]) {
      for (var index in validSockets["" + info.user]) {
        if (validSockets[""+info.user].hasOwnProperty(index)) {
          console.log("Sending a message to users in group " + info.user);
          validSockets["" + info.user][index].emit(channel, info.data);
        }
      }
    }
    for (var index in adminSockets) {
      if (adminSockets.hasOwnProperty(index)) {
        console.log('Sending a message to connect admin');
        adminSockets[index].emit(channel, info.data);
      }
    }
  } catch(err) {
    console.log("ERROR!!!!!!\n", err);
  }
});
