const jwt = require('jsonwebtoken')
const pool = require('../database/connection')
require('dotenv').config();

async function verifyToken(req, res, next) {
    try {
        const token = req.header('x-auth-token')

        var decoded;
        jwt.verify(token, process.env.JWTSIGN, (error, user) => {
            if (error) { return res.status(401).json({ "message": error.toString() }) }
            decoded = user;
        })

        var results = await pool.query('SELECT * FROM users WHERE uid=$1', [decoded.uid])
        if (results.rowCount == 0) {
            return res.status(404).json({ "message": "oops something went wrong!" })
        }
        req.email = results.rows[0].email;
        next()
    } catch (e) {
        return res.status(401).json({ "message": 'Authentication failed' })
    }
}

module.exports = verifyToken;