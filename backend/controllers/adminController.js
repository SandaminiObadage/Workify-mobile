const User = require("../models/User");
const Job = require("../models/Job");
const Application = require("../models/Applications");
const Agent = require("../models/Agent");
const Bookmark = require("../models/Bookmark");

module.exports = {
    // Dashboard Statistics
    getDashboardStats: async (req, res) => {
        try {
            const totalUsers = await User.countDocuments({ isAdmin: false });
            const totalAgents = await User.countDocuments({ isAgent: true });
            const totalJobs = await Job.countDocuments();
            const totalApplications = await Application.countDocuments();
            const activeJobs = await Job.countDocuments({ hiring: true });
            const inactiveJobs = await Job.countDocuments({ hiring: false });

            // Get recent users (last 7 days)
            const sevenDaysAgo = new Date();
            sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
            const newUsersThisWeek = await User.countDocuments({
                createdAt: { $gte: sevenDaysAgo },
                isAdmin: false
            });

            // Get recent jobs (last 7 days)
            const newJobsThisWeek = await Job.countDocuments({
                createdAt: { $gte: sevenDaysAgo }
            });

            // Get recent applications (last 7 days)
            const newApplicationsThisWeek = await Application.countDocuments({
                createdAt: { $gte: sevenDaysAgo }
            });

            res.status(200).json({
                totalUsers,
                totalAgents,
                totalJobs,
                totalApplications,
                activeJobs,
                inactiveJobs,
                newUsersThisWeek,
                newJobsThisWeek,
                newApplicationsThisWeek
            });
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    },

    // User Management
    getAllUsers: async (req, res) => {
        const { page = 1, limit = 20, search = '' } = req.query;

        try {
            const query = { isAdmin: false };
            
            if (search) {
                query.$or = [
                    { username: { $regex: search, $options: 'i' } },
                    { email: { $regex: search, $options: 'i' } }
                ];
            }

            const users = await User.find(query, { password: 0, __v: 0 })
                .sort({ createdAt: -1 })
                .limit(limit * 1)
                .skip((page - 1) * limit);

            const count = await User.countDocuments(query);

            res.status(200).json({
                users,
                totalPages: Math.ceil(count / limit),
                currentPage: page,
                totalUsers: count
            });
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    },

    getUserById: async (req, res) => {
        try {
            const user = await User.findById(req.params.id, { password: 0, __v: 0 });
            
            if (!user) {
                return res.status(404).json({ message: "User not found" });
            }

            // Get user's applications
            const applications = await Application.find({ user: req.params.id })
                .populate('job', 'title company location')
                .sort({ createdAt: -1 });

            // Get user's bookmarks
            const bookmarks = await Bookmark.find({ userId: req.params.id })
                .populate('job', 'title company location')
                .sort({ createdAt: -1 });

            res.status(200).json({
                user,
                applications,
                bookmarks
            });
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    },

    updateUserStatus: async (req, res) => {
        const { isAgent } = req.body;

        try {
            const user = await User.findByIdAndUpdate(
                req.params.id,
                { $set: { isAgent } },
                { new: true, select: '-password -__v' }
            );

            if (!user) {
                return res.status(404).json({ message: "User not found" });
            }

            res.status(200).json(user);
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    },

    deleteUserById: async (req, res) => {
        try {
            const user = await User.findByIdAndDelete(req.params.id);

            if (!user) {
                return res.status(404).json({ message: "User not found" });
            }

            // Clean up related data
            await Application.deleteMany({ user: req.params.id });
            await Bookmark.deleteMany({ userId: req.params.id });

            res.status(200).json({ message: "User deleted successfully" });
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    },

    // Job Management
    getAllJobsAdmin: async (req, res) => {
        const { page = 1, limit = 20, search = '', status = 'all' } = req.query;

        try {
            const query = {};

            if (search) {
                query.$or = [
                    { title: { $regex: search, $options: 'i' } },
                    { company: { $regex: search, $options: 'i' } },
                    { location: { $regex: search, $options: 'i' } }
                ];
            }

            if (status === 'active') {
                query.hiring = true;
            } else if (status === 'inactive') {
                query.hiring = false;
            }

            const jobs = await Job.find(query)
                .sort({ createdAt: -1 })
                .limit(limit * 1)
                .skip((page - 1) * limit);

            const count = await Job.countDocuments(query);

            res.status(200).json({
                jobs,
                totalPages: Math.ceil(count / limit),
                currentPage: page,
                totalJobs: count
            });
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    },

    updateJobStatus: async (req, res) => {
        const { hiring } = req.body;

        try {
            const job = await Job.findByIdAndUpdate(
                req.params.id,
                { $set: { hiring } },
                { new: true }
            );

            if (!job) {
                return res.status(404).json({ message: "Job not found" });
            }

            res.status(200).json(job);
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    },

    deleteJobById: async (req, res) => {
        try {
            const job = await Job.findByIdAndDelete(req.params.id);

            if (!job) {
                return res.status(404).json({ message: "Job not found" });
            }

            // Clean up related data
            await Application.deleteMany({ job: req.params.id });
            await Bookmark.deleteMany({ job: req.params.id });

            res.status(200).json({ message: "Job deleted successfully" });
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    },

    // Application Management
    getAllApplications: async (req, res) => {
        const { page = 1, limit = 20 } = req.query;

        try {
            const applications = await Application.find()
                .populate('user', 'username email profile')
                .populate('job', 'title company location salary')
                .sort({ createdAt: -1 })
                .limit(limit * 1)
                .skip((page - 1) * limit);

            const count = await Application.countDocuments();

            res.status(200).json({
                applications,
                totalPages: Math.ceil(count / limit),
                currentPage: page,
                totalApplications: count
            });
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    },

    // Agent Management
    getAllAgents: async (req, res) => {
        const { page = 1, limit = 20 } = req.query;

        try {
            const agents = await User.find({ isAgent: true }, { password: 0, __v: 0 })
                .sort({ createdAt: -1 })
                .limit(limit * 1)
                .skip((page - 1) * limit);

            const count = await User.countDocuments({ isAgent: true });

            // Get job count for each agent
            const agentsWithJobCount = await Promise.all(
                agents.map(async (agent) => {
                    const jobCount = await Job.countDocuments({ agentId: agent.uid });
                    return {
                        ...agent._doc,
                        jobCount
                    };
                })
            );

            res.status(200).json({
                agents: agentsWithJobCount,
                totalPages: Math.ceil(count / limit),
                currentPage: page,
                totalAgents: count
            });
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    },

    // Analytics - User Growth
    getUserGrowthStats: async (req, res) => {
        try {
            const months = 6;
            const stats = [];

            for (let i = months - 1; i >= 0; i--) {
                const date = new Date();
                date.setMonth(date.getMonth() - i);
                const startOfMonth = new Date(date.getFullYear(), date.getMonth(), 1);
                const endOfMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0);

                const count = await User.countDocuments({
                    createdAt: { $gte: startOfMonth, $lte: endOfMonth },
                    isAdmin: false
                });

                stats.push({
                    month: startOfMonth.toLocaleString('default', { month: 'short', year: 'numeric' }),
                    count
                });
            }

            res.status(200).json(stats);
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    },

    // Analytics - Job Posting Trends
    getJobPostingStats: async (req, res) => {
        try {
            const months = 6;
            const stats = [];

            for (let i = months - 1; i >= 0; i--) {
                const date = new Date();
                date.setMonth(date.getMonth() - i);
                const startOfMonth = new Date(date.getFullYear(), date.getMonth(), 1);
                const endOfMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0);

                const count = await Job.countDocuments({
                    createdAt: { $gte: startOfMonth, $lte: endOfMonth }
                });

                stats.push({
                    month: startOfMonth.toLocaleString('default', { month: 'short', year: 'numeric' }),
                    count
                });
            }

            res.status(200).json(stats);
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    },

    // Analytics - Application Trends
    getApplicationStats: async (req, res) => {
        try {
            const months = 6;
            const stats = [];

            for (let i = months - 1; i >= 0; i--) {
                const date = new Date();
                date.setMonth(date.getMonth() - i);
                const startOfMonth = new Date(date.getFullYear(), date.getMonth(), 1);
                const endOfMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0);

                const count = await Application.countDocuments({
                    createdAt: { $gte: startOfMonth, $lte: endOfMonth }
                });

                stats.push({
                    month: startOfMonth.toLocaleString('default', { month: 'short', year: 'numeric' }),
                    count
                });
            }

            res.status(200).json(stats);
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    }
};
