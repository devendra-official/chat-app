const router = require('express').Router();
const verifyToken = require('../../middleware/verify_token')
const pool = require('../../database/connection')
const mongoose = require("mongoose");
const messageSchema = require('../../schema/mongo');

router.get("/get-users", verifyToken, async (req, res) => {
    try {
        let results = await pool.query('SELECT name,username,phone,email,profile,dt_created FROM users WHERE email <> $1', [req.email])
        if (results.rowCount == 0) {
            return res.json({ "email": req.email, "users": [] });
        }
        return res.json({ "email": req.email, "users": results.rows })
    } catch (e) {
        return res.status(500).json({ message: 'Internal Server Error' })
    }
})

router.get("/get-messages", verifyToken, async (req, res) => {
    try {
        let model = mongoose.model('messages', messageSchema)
        let result = await model.find().or([
            { from: req.email },
            { to: req.email }
        ])
        return res.json(result)
    } catch (e) {
        return res.status(500).json({ message: 'Internal Server Error' })
    }
})

module.exports = router;