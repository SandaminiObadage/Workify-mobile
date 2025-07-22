const router = require("express").Router();
const applyController = require("../controllers/applyController");
const { verifyTokenAndAuthorization, verifyTokenAndAdmin } = require("../middleware/verifyToken");

// REGISTRATION 

router.post("/",verifyTokenAndAuthorization, applyController.apply);


// LOGIN 
router.get("/",verifyTokenAndAuthorization, applyController.getApplied);


module.exports = router