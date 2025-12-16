const Application = require("../models/Applications");


module.exports = {
    apply: async (req, res) => { 
        
        const newApplication =  new Application({
            user:req.user.id,
            job: req.body.job,
        });
        try {
            await newApplication.save();
       
        res.status(200).json({status: true, message: 'Application submitted successfully!'})
    } catch (error) {
        res.status(500).json(error)
    }
    },

    getApplied: async (req, res) => {
        const userId = req.user.id;
        try {
            applied = await Application.find({user: userId}, {__v: 0, createdAt: 0, updatedAt: 0}).sort({ createdAt: -1 })
            .populate({
                path: 'job',
                select: '-createdAt -updatedAt -description -requirements -__v'
            });

            res.status(200).json(applied);

        } catch (error) {
            res.status(500)
        }
    },

    getJobApplicants: async (req, res) => {
        const jobId = req.params.jobId;
        try {
            const applicants = await Application.find({ job: jobId }, { __v: 0 })
                .sort({ createdAt: -1 })
                .populate({
                    path: 'user',
                    select: 'username email profile location phone skills isAgent resume'
                });

            res.status(200).json(applicants);
        } catch (error) {
            console.error('Error getting job applicants:', error);
            res.status(500).json({ message: 'Error fetching applicants', error });
        }
    }
}