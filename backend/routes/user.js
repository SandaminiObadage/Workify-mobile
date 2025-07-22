const router = require("express").Router();
const userController = require("../controllers/userController");
const { verifyTokenAndAuthorization, verifyTokenAndAdmin } = require("../middleware/verifyToken");


// UPADATE USER
router.put("/", verifyTokenAndAuthorization, userController.updateUser);

// DELETE USER

router.delete("/", verifyTokenAndAuthorization, userController.deleteUser);

// GET USER (moved before other routes to ensure priority)
router.get("/profile", verifyTokenAndAuthorization, userController.getUser);

// TEST ENDPOINT - for debugging (no auth required)
router.get("/test", (req, res) => {
    res.status(200).json({ message: "Test endpoint hit", type: "single_object" });
});

// GET ALL USER (admin only) - moved to different endpoint to avoid conflict
router.get("/all", verifyTokenAndAdmin, userController.getAllUsers);

// Add Skills
router.post("/skills", verifyTokenAndAuthorization, userController.addSkills);

// Get Skills
router.get("/skills", verifyTokenAndAuthorization, userController.getSkills);

router.delete("/skills/:id", verifyTokenAndAuthorization, userController.deleteSkill);

// GET ALL AGENTS
router.get("/agents", userController.getAgents);

// POST AGENTS
router.post("/agents",verifyTokenAndAuthorization, userController.postAgent);


// UPDATE AGENTS
router.put("/agents",verifyTokenAndAuthorization, userController.updateAgent);

// GET SINGLE AGENTS
router.get("/agents/:uid", userController.getAgent);


module.exports = router