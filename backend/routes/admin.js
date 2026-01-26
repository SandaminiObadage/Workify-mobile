const router = require("express").Router();
const adminController = require("../controllers/adminController");
const { verifyToken } = require("../middleware/verifyToken");
const verifyAdmin = require("../middleware/verifyAdmin");

// Apply both authentication and admin verification to all routes
router.use(verifyToken);
router.use(verifyAdmin);

// Dashboard Stats
router.get("/stats", adminController.getDashboardStats);

// User Management
router.get("/users", adminController.getAllUsers);
router.get("/users/:id", adminController.getUserById);
router.put("/users/:id/status", adminController.updateUserStatus);
router.delete("/users/:id", adminController.deleteUserById);

// Job Management
router.get("/jobs", adminController.getAllJobsAdmin);
router.put("/jobs/:id/status", adminController.updateJobStatus);
router.delete("/jobs/:id", adminController.deleteJobById);

// Application Management
router.get("/applications", adminController.getAllApplications);

// Agent Management
router.get("/agents", adminController.getAllAgents);

// Analytics
router.get("/analytics/user-growth", adminController.getUserGrowthStats);
router.get("/analytics/job-posting", adminController.getJobPostingStats);
router.get("/analytics/applications", adminController.getApplicationStats);

module.exports = router;
