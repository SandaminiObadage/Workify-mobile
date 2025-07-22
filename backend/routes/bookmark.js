const router = require("express").Router();
const { verifyToken, verifyTokenAndAuthorization } = require("../middleware/verifyToken");
const bookmarkController = require("../controllers/bookmarkController");


// CREATE BOOKMARKS
router.post("/", verifyTokenAndAuthorization, bookmarkController.createBookmark);


// DELETE BOOKMARKS

router.delete("/:id", verifyTokenAndAuthorization, bookmarkController.deleteBookmark);


// GET BOOKMARKS
router.get("/",verifyTokenAndAuthorization, bookmarkController.getBookmarks);


// GET BOOKMARKS
router.get("/bookmark/:id",verifyTokenAndAuthorization, bookmarkController.getBookmark);




module.exports = router