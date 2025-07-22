const router = require("express").Router();
const authController = require("../controllers/authContoller");


// REGISTRATION 

router.post("/register", authController.createUser);


// LOGIN 
router.post("/login", authController.loginUser);

// GET ALL USERS (for viewing database data)
router.get("/users", authController.getAllUsers);


module.exports = router