const express = require("express")
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const pool = require('../../database/connection')
const router = express.Router()
require('dotenv').config()

router.post("/login", async (req, res) => {
    try {
        const { email, password } = req.body;
        const values = await pool.query('SELECT * FROM users WHERE email=$1', [email])
        if (values.rowCount == 0) {
            return res.status(404).json({
                message: "No users found"
            })
        }

        if (bcrypt.compare(password, values.rows[0].password)) {
            const token = jwt.sign({ uid: values.rows[0].uid }, process.env.JWTSIGN, { expiresIn: "1h" })
            return res.status(200).json({
                token: token,
                name: values.rows[0].name,
                username: values.rows[0].username,
                email: values.rows[0].email,
                phone: values.rows[0].phone,
                profile: values.rows[0].profile
            })
        }
        return res.status(401).json({ message: "Wrong password" })
    } catch (e) {
        return res.status(500).json({ message: 'Internal Server Error' })
    }
})

module.exports = router;