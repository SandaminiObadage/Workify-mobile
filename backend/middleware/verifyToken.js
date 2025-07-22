const jwt = require("jsonwebtoken");
const User = require("../models/User");


const verifyToken = (req, res, next)=> {
    const authHeader = req.headers.authorization;

    if(authHeader){
        const token = authHeader.split(" ")[1];

        jwt.verify(token, process.env.JWT_SEC, async (err, user) => {
            if(err){
                return res.status(403).json({status: false, message: "Invalid token"})
            }

            req.user = user;
            next();
        })

    }else{
        return res.status(401).json({status: false, message: "You are not authenticated"})
    }
}

const verifyTokenAndAuthorization = (req, res, next) => {
    verifyToken(req, res, () => {
        if (req.user.id || req.user.isAdmin) {
            next();
        } else {
            res.status(403).json("You are restricted from perfoming this operation");
        }
    });
};

const verifyTokenAndAdmin = (req, res, next) => {
    verifyToken(req, res, () => {
        if (req.user.isAdmin) {
            next();
        } else {
            res.status(403).json("You have limited access");
        }
    });
};


const verifyTokenAndAgent = (req, res, next) => {
    verifyToken(req, res, () => {
        if (req.user.isAgent || req.user.isAdmin) {
            next();
        } else {
            res.status(403).json("You are restricted from perfoming this operation");
        }
    });
};

module.exports = { verifyToken, verifyTokenAndAuthorization, verifyTokenAndAdmin, verifyTokenAndAgent };
