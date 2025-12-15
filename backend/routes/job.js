const router = require("express").Router();
const jobController = require("../controllers/jobController");
const { verifyTokenAndAgent } = require("../middleware/verifyToken");


// CREATE JOB
router.post("/", verifyTokenAndAgent, jobController.createJob);


// UPADATE JOB
router.put("/:id", verifyTokenAndAgent, jobController.updateJob);

// DELETE JOB

router.delete("/:id", verifyTokenAndAgent, jobController.deleteJob);

// GET JOB BY ID
router.get("/:id", jobController.getJob);

// GET ALL JOBS
router.get("/", jobController.getAllJobs);

// GET ALL JOBS
router.get("/agent/:id", jobController.getAgentJobs);

// GET AGENT JOBS WITH APPLICANT COUNT
router.get("/agent/:id/applicants", jobController.getAgentJobsWithApplicants);

// SEARCH FOR JOBS
router.get("/search/:key", jobController.searchJobs);

// ADVANCED SEARCH WITH FILTERS
router.post("/search/advanced", jobController.advancedSearch);

module.exports = router