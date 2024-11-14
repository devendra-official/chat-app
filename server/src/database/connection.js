const pg = require("pg")
const { Pool } = pg
const mongoose = require('mongoose')

mongoose.connect('mongodb://localhost:27017/messages').then((_) => {
    console.log("connected to MongoDB");
})

const pool = new Pool({
    user: 'postgres',
    password: 'linux',
    host: '127.0.0.1',
    port: '5432',
    database: 'message',
})

module.exports = pool
