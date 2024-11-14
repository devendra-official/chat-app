const express = require('express');
const login = require('../src/router/authentication/auth')
const cors = require('cors');
const app = express();
const server = require('http').createServer(app)
const getUsers = require('./router/chat/chat')
const io = require('socket.io')(server, {
    cors: {
        origin: "*",
        methods: ["GET", "POST"]
    }
})
const mongoose = require('mongoose')
const messageSchema = require('./schema/mongo')

const PORT = 8080
let emailtoid = new Map()

app.use(cors())
app.use(express.json())
app.use("/auth", login)
app.use(getUsers)
app.use("*", (_, res) => {
    return res.status(404).json({ message: "Nothing here!" })
})

io.on('connection', socket => {
    console.log(`user ${socket.id} is online`);
    socket.broadcast.emit('status', `user ${socket.id} is online`)

    socket.on('initial', email => {
        emailtoid[email] = socket.id;
    })
    socket.on('sendMessage', async (data) => {
        let messageModel = mongoose.model('messages', messageSchema)
        messageModel.create({
            from: data.from,
            to: data.to,
            message: data.message
        })
        socket.to(emailtoid[data.to]).emit('receiveMessage', data)
    })
})

server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
