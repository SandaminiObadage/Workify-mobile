const router = require("express").Router();
const userController = require("../controllers/userController");
const { verifyTokenAndAuthorization, verifyTokenAndAdmin } = require("../middleware/verifyToken");
const multer = require('multer');

// Configure multer for file uploads
const storage = multer.memoryStorage();
const upload = multer({ 
  storage: storage,
  fileFilter: (req, file, cb) => {
    // Accept common PDF MIME types
    const acceptedMimeTypes = [
      'application/pdf',
      'application/x-pdf',
      'application/x-bzpdf',
      'application/x-gzpdf'
    ];
    
    // Also check file extension as fallback
    const originalname = file.originalname || '';
    const isPdfByExtension = originalname.toLowerCase().endsWith('.pdf');
    
    if (acceptedMimeTypes.includes(file.mimetype) || isPdfByExtension) {
      cb(null, true);
    } else {
      cb(new Error('Only PDF files are allowed'), false);
    }
  },
  limits: { fileSize: 10 * 1024 * 1024 } // 10MB limit
});

// UPADATE USER
router.put("/", verifyTokenAndAuthorization, userController.updateUser);

// UPDATE USER PROFILE - specific route for profile updates
router.put("/profile", verifyTokenAndAuthorization, userController.updateUser);

// UPDATE USER RESUME
router.put("/resume", verifyTokenAndAuthorization, userController.updateResume);

// UPLOAD RESUME
router.post("/upload-resume", verifyTokenAndAuthorization, upload.single('resume'), userController.uploadResume);

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