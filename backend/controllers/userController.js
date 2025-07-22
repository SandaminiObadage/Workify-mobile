const User = require("../models/User");
const Agent = require("../models/Agent");
const Skill = require("../models/Skills");

module.exports = {
    updateUser: async (req, res) => {
        if (req.body.password) {
            req.body.password = CryptoJS.AES.encrypt(req.body.password, process.env.SECRET).toString();
        }
        try {
            const updatedUser = await User.findByIdAndUpdate(
                req.user.id, {
                $set: req.body
            }, { new: true });
            const { password, __v, createdAt, ...others } = updatedUser._doc;

            res.status(200).json({ ...others });
        } catch (err) {
            res.status(500).json(err)
        }
    },

    deleteUser: async (req, res) => {
        try {
            await User.findByIdAndDelete(req.user.id)
            res.status(200).json("Successfully Deleted")
        } catch (error) {
            res.status(500).json(error)
        }
    },

    addSkills: async (req, res) => {
        const newSkill = new Skill({ userId: req.user.id, skill: req.body.skill });
    
        try {
            await newSkill.save();
    
            // Update the user's "skills" field to true
            await User.findByIdAndUpdate(req.user.id, { $set: { skills: true } });
    
            res.status(200).json({ status: true });
        } catch (err) {
            res.status(500).json(err);
        }
    },

    getSkills: async (req, res) => {
        const userId = req.user.id;

        try {
            const skills = await Skill.find({userId: userId}, {__v: 0, userId: 0});

            if (skills.length === 0 ) {
                return res.status(200).json([]);
            }
            res.status(200).json(skills);
        } catch (error) {
            res.status(500).json(error)
        }
    },

    deleteSkill: async (req, res) => {
        const id = req.params.id;
        try {
            await Skill.findByIdAndDelete(id)
            res.status(200).json({status: true});
        } catch (error) {
            res.status(500).json(error)
        }
    },

    getUser: async (req, res) => {
        try {
            const user = await User.findById(req.user.id);
            const { password, __v, createdAt, ...userdata } = user._doc;
            res.status(200).json(userdata)
        } catch (error) {
            res.status(500).json(error)
        }
    },


    getAgents: async (req, res) => {
        try {
            const agents = await User.aggregate([
                { $match: { isAgent: true } }, // Filter by isAgent: true
                { $sample: { size: 7 } },     // Sample 7 random documents
                {
                    $project: {
                        _id: 0,                   // Exclude _id from the result
                        username: 1,              // Include username
                        profile: 1,
                        uid: 1,                // Include profile
                    }
                }
            ]);

            res.status(200).json(agents);
        } catch (error) {
            res.status(500).json(error)
        }
    },

    postAgent: async (req, res) => {
        console.log(req.user.id);
        const newAgent = new Agent({
            company: req.body.company,
            hq_address: req.body.hq_address,
            working_hrs: req.body.working_hrs,
            userId: req.user.id,
            uid: req.body.uid
        });
        try {
            
            await newAgent.save();
            await User.findByIdAndUpdate(req.user.id, { $set: { isAgent: true } });
            res.status(200).json({ status: true });
        } catch (err) {
            res.status(500).json(err)
        }
    },

    updateAgent: async (req, res) => {
       
        const newAgent = new Agent({
            company: req.body.company,
            hq_address: req.body.hq_address,
            working_hrs: req.body.working_hrs,
            userId: req.user.id,
            uid: req.body.uid
        });

        try {
            
            await newAgent.save();
            res.status(200).json({ status: true });
        } catch (err) {
            res.status(500).json(err)
        }
    },

    getAgent: async (req, res) => {

        try {
            const agent = await Agent.find({ uid: req.params.uid }, {createdAt: 0, updatedAt: 0, __v: 0});
            const newAgent = agent[0];
            res.status(200).json(newAgent);
        } catch (err) {
            res.status(500).json(err)
        }
    },


    getAllUsers: async (req, res) => {
        try {
            const allUser = await User.find();

            res.status(200).json(allUser)
        } catch (error) {
            res.status(500).json(error)
        }
    },



}