const Job = require("../models/Job");

module.exports = {
    createJob: async (req, res) => {
        console.log('Creating job with data:', req.body);
        
        try {
            // Validate and clean the data
            const jobData = { ...req.body };
            
            // Ensure period is not empty
            if (!jobData.period || jobData.period.trim() === '') {
                return res.status(400).json({
                    status: false,
                    message: 'Period is required. Please specify job period (e.g., Full-time, Part-time, Contract)'
                });
            }
            
            // Filter out empty requirements
            if (jobData.requirements && Array.isArray(jobData.requirements)) {
                jobData.requirements = jobData.requirements.filter(req => req && req.trim() !== '');
            }
            
            // Validate required fields
            const requiredFields = ['title', 'location', 'company', 'description', 'salary', 'period', 'contract'];
            for (const field of requiredFields) {
                if (!jobData[field] || (typeof jobData[field] === 'string' && jobData[field].trim() === '')) {
                    return res.status(400).json({
                        status: false,
                        message: `${field.charAt(0).toUpperCase() + field.slice(1)} is required and cannot be empty`
                    });
                }
            }
            
            const newJob = new Job(jobData);
            await newJob.save();
            
            res.status(201).json({status: true, message: 'Job successfully created'})
        } catch (error) {
            console.error('Error creating job:', error);
            
            if (error.name === 'ValidationError') {
                const validationErrors = Object.values(error.errors).map(err => ({
                    field: err.path,
                    message: err.message
                }));
                
                return res.status(400).json({
                    status: false,
                    message: 'Validation failed',
                    errors: validationErrors
                });
            }
            
            res.status(500).json({
                status: false,
                message: 'Error creating job',
                error: error.message || error
            })
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
            const searchKey = req.params.key;
            
            // Create a flexible search query using regex for multiple fields
            const searchQuery = {
                $or: [
                    { title: { $regex: searchKey, $options: 'i' } },
                    { company: { $regex: searchKey, $options: 'i' } },
                    { location: { $regex: searchKey, $options: 'i' } },
                    { description: { $regex: searchKey, $options: 'i' } },
                    { contract: { $regex: searchKey, $options: 'i' } },
                    { period: { $regex: searchKey, $options: 'i' } },
                    { requirements: { $elemMatch: { $regex: searchKey, $options: 'i' } } }
                ]
            };

            const results = await Job.find(searchQuery, {
                __v: 0, 
                createdAt: 0, 
                updatedAt: 0
            }).sort({ createdAt: -1 });

            res.status(200).json(results);
        } catch (err) {
            console.error('Search error:', err);
            res.status(500).json({ 
                error: 'Search failed', 
                message: err.message 
            });
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

    advancedSearch: async (req, res) => {
        try {
            const { 
                searchTerm, 
                location, 
                contract, 
                period, 
                minSalary, 
                maxSalary 
            } = req.body;

            let query = {};
            let conditions = [];

            // Text search across multiple fields
            if (searchTerm && searchTerm.trim() !== '') {
                conditions.push({
                    $or: [
                        { title: { $regex: searchTerm, $options: 'i' } },
                        { company: { $regex: searchTerm, $options: 'i' } },
                        { description: { $regex: searchTerm, $options: 'i' } },
                        { requirements: { $elemMatch: { $regex: searchTerm, $options: 'i' } } }
                    ]
                });
            }

            // Location filter
            if (location && location.trim() !== '') {
                conditions.push({
                    location: { $regex: location, $options: 'i' }
                });
            }

            // Contract type filter
            if (contract && contract.trim() !== '') {
                conditions.push({
                    contract: { $regex: contract, $options: 'i' }
                });
            }

            // Period filter
            if (period && period.trim() !== '') {
                conditions.push({
                    period: { $regex: period, $options: 'i' }
                });
            }

            // Salary range filter (basic implementation)
            if (minSalary || maxSalary) {
                let salaryCondition = {};
                if (minSalary) {
                    // This is a basic implementation - you might want to improve salary parsing
                    salaryCondition.$gte = minSalary;
                }
                if (maxSalary) {
                    salaryCondition.$lte = maxSalary;
                }
                // Note: This requires salary to be stored as numbers for proper comparison
                // Currently salary is stored as string, so this is a placeholder
            }

            // Combine all conditions
            if (conditions.length > 0) {
                query.$and = conditions;
            }

            // Only show active jobs
            query.hiring = true;

            const results = await Job.find(query, {
                __v: 0, 
                createdAt: 0, 
                updatedAt: 0
            }).sort({ createdAt: -1 });

            res.status(200).json({
                success: true,
                count: results.length,
                jobs: results
            });

        } catch (error) {
            console.error('Advanced search error:', error);
            res.status(500).json({
                success: false,
                error: 'Advanced search failed',
                message: error.message
            });
        }
    }

}