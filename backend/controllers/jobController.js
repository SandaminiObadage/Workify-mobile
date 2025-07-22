const Job = require("../models/Job");

module.exports = {
    createJob: async (req, res) => {
        const newJob = new Job(req.body);

        try {
             await newJob.save();
            
            res.status(201).json({status: true, message: 'Job successfully created'})
        } catch (error) {
            res.status(500).json(error)
        }
    },


    updateJob: async (req, res)=> {
        const jobId = req.params.id; 
        const updates = req.body; 
    
        try {
            const updatedJob = await Job.findByIdAndUpdate(jobId, updates, { new: true });
    
            if (!updatedJob) {
                return res.status(404).json({ status: false, message: 'Job not found.' });
            }
    
            res.status(200).json({ status: true, message: 'Job successfully updated' });
        } catch (error) {
            res.status(500).json(error);
        }
    },

    deleteJob: async (req, res) => {
        try {
            await Job.findByIdAndDelete(req.params.id)
            res.status(200).json({status: true, message: "Job Successfully Deleted"})
        } catch (error) {
            res.status(500).json(error)
        }
    },

    getJob: async (req, res) => {
        const jobId = req.params.id
        try {
            const job = await Job.findById({_id: jobId}, {__v: 0, createdAt: 0});
            
            res.status(200).json(job)
        } catch (error) {
            res.status(500).json(error)
        }
    },


    getAllJobs: async (req, res) => {
        const recent = req.query.new;
        try {
            let jobs;
            if (recent) {
                jobs = await Job.find({}, {__v: 0, createdAt: 0, updatedAt: 0}).sort({ createdAt: -1 }).limit(2)
            } else {
                jobs = await Job.find({}, {__v: 0, createdAt: 0, updatedAt: 0})
            }
            res.status(200).json(jobs)
        } catch (error) {
            res.status(500).json(error)
        }
    },

    searchJobs: async (req, res) => {
        try {
            const results = await Job.aggregate(
                [
                    {
                        $search: {
                            index: "jobsearch",
                            text: {
                                query: req.params.key,
                                path: {
                                    wildcard: "*"
                                }
                            }
                        }
                    }
                ]
            )
            res.status(200).send(results);
        } catch (err) {
            res.status(500).json(err);
        }
    },

    getAgentJobs: async (req, res) => {
        const uid = req.params.id
        try {
            const jobs = await Job.find({agentId: uid}, {__v: 0, createdAt: 0, updateAt: 0}).sort({ createdAt: -1 })
            
            res.status(200).json(jobs)
        } catch (error) {
            res.status(500).json(error)
        }
    },


}