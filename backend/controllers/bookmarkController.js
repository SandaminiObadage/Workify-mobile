const Bookmark = require("../models/Bookmark");
const Job = require("../models/Job");


module.exports = {

    createBookmark: async (req, res) => {
        const jobID = req.body.job;
        const user = req.user.id 

        try {
            const job = await Job.findById(jobID);

            if (!job) {
                return res.status(404).json({ error: 'Job not found' });
            }
            const newBook = new Bookmark({ job: jobID, userId: user});

            const savedBookmark = await newBook.save();

            res.status(200).json({status: true, bookmarkId: savedBookmark._id});
        } catch (error) {
            res.status(500).json(error);
        }
    },

   
    deleteBookmark: async (req, res) => {
        const id = req.params.id;
        try {
            await Bookmark.findByIdAndDelete(id); 
            res.status(200).json({status: true, message: "Bookmark deleted"});
        } catch (error) {
            res.status(500).json(error);
        }
    },


    getBookmarks: async (req, res) => {
        try {
            const bookmarks = await Bookmark.find({ userId: req.user.id }, {createdAt: 0, updatedAt: 0, __v: 0})
            .populate({
                path: 'job',
                select: "-requirements -createdAt -updatedAt -description  -__v"
            })
            res.status(200).json(bookmarks)
        } catch (error) {
            res.status(500).json(error)
        }
    },

    getBookmark: async (req, res) => {
        const jobId = req.params.id;
        try {
            const bookmark = await Bookmark.findOne({ userId: req.user.id, job: jobId })
           
            if (!bookmark) {
                return res.status(200).json({status: false, bookmarkId: 'none'})}

            
            res.status(200).json({status: true, bookmarkId: bookmark._id})
        } catch (error) {
            res.status(500).json(error)
        }
    }


}