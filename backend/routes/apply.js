const router = require("express").Router();
const applyController = require("../controllers/applyController");
const { verifyTokenAndAuthorization, verifyTokenAndAdmin } = require("../middleware/verifyToken");

// REGISTRATION 

router.post("/",verifyTokenAndAuthorization, applyController.apply);


// GET APPLIED JOBS 
router.get("/",verifyTokenAndAuthorization, applyController.getApplied);

// GET APPLICANTS FOR A SPECIFIC JOB
router.get("/job/:jobId", verifyTokenAndAuthorization, applyController.getJobApplicants);

module.exports = router