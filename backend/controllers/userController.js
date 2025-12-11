const User = require("../models/User");
const Agent = require("../models/Agent");
const Skill = require("../models/Skills");
const Resume = require("../models/Resume");
const CryptoJS = require("crypto-js");

module.exports = {
    updateUser: async (req, res) => {
        if (req.body.password) {
            req.body.password = CryptoJS.AES.encrypt(req.body.password, process.env.SECRET).toString();
        }
        
        try {
            // Extract skills from request body to handle separately
            const { skills, ...userUpdateData } = req.body;
            
            // Update user basic information (excluding skills)
            const updatedUser = await User.findByIdAndUpdate(
                req.user.id, {
                $set: userUpdateData
            }, { new: true });
            
            // Handle skills separately if provided
            if (skills && Array.isArray(skills)) {
                // Remove existing skills for this user
                await Skill.deleteMany({ userId: req.user.id });
                
                // Add new skills (filter out empty strings)
                const validSkills = skills.filter(skill => skill && skill.trim() !== '');
                for (const skillText of validSkills) {
                    const newSkill = new Skill({ 
                        userId: req.user.id, 
                        skill: skillText.trim() 
                    });
                    await newSkill.save();
                }
                
                // Update user's skills boolean flag
                await User.findByIdAndUpdate(req.user.id, { 
                    $set: { skills: validSkills.length > 0 } 
                });
            }
            
            const { password, __v, createdAt, ...others } = updatedUser._doc;
            res.status(200).json({ ...others });
        } catch (err) {
            console.error('Error updating user:', err);
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

    updateResume: async (req, res) => {
        try {
            const { resume } = req.body;

            if (!resume) {
                return res.status(400).json({ message: "Resume URL is required" });
            }

            const updatedUser = await User.findByIdAndUpdate(
                req.user.id,
                { $set: { resume } },
                { new: true }
            );

            const { password, __v, createdAt, ...others } = updatedUser._doc;
            res.status(200).json({ 
                message: "Resume updated successfully",
                resume: updatedUser.resume 
            });
        } catch (err) {
            console.error('Error updating resume:', err);
            res.status(500).json({ message: "Error updating resume", error: err });
        }
    },

    uploadResume: async (req, res) => {
        try {
            if (!req.file) {
                return res.status(400).json({ message: "No file uploaded" });
            }

            const resumeFileName = req.file.filename; // multer already created this
            const filePath = `/resumes/${resumeFileName}`;

            // Delete previous resume if exists
            const oldResume = await Resume.findOne({ userId: req.user.id });
            if (oldResume) {
                // Delete old file from disk
                const fs = require('fs');
                const path = require('path');
                const oldFilePath = path.join(__dirname, '../resumes', oldResume.fileName);
                if (fs.existsSync(oldFilePath)) {
                    fs.unlinkSync(oldFilePath);
                }
                // Delete from database
                await Resume.deleteMany({ userId: req.user.id });
            }

            // Create new resume document
            const newResume = new Resume({
                userId: req.user.id,
                fileName: resumeFileName,
                originalFileName: req.file.originalname,
                filePath: filePath
            });

            await newResume.save();

            // Also update user's resume field for quick access
            await User.findByIdAndUpdate(
                req.user.id,
                { $set: { resume: filePath } },
                { new: true }
            );

            res.status(200).json({ 
                message: "Resume uploaded successfully",
                resume: filePath,
                fileName: resumeFileName,
                resumeId: newResume._id
            });
        } catch (err) {
            console.error('Error uploading resume:', err);
            res.status(500).json({ message: "Error uploading resume", error: err });
        }
    },

    getResume: async (req, res) => {
        try {
            const resume = await Resume.findOne({ userId: req.user.id }).sort({ uploadedAt: -1 });
            
            if (!resume) {
                return res.status(404).json({ message: "No resume found" });
            }

            res.status(200).json(resume);
        } catch (err) {
            console.error('Error fetching resume:', err);
            res.status(500).json({ message: "Error fetching resume", error: err });
        }
    },

    downloadResume: async (req, res) => {
        try {
            const fileName = req.params.fileName;
            const path = require('path');
            const fs = require('fs');
            
            // Verify the file belongs to the user
            const resume = await Resume.findOne({ 
                userId: req.user.id, 
                fileName: fileName 
            });
            
            if (!resume) {
                return res.status(404).json({ message: "Resume not found or unauthorized" });
            }

            const filePath = path.join(__dirname, '../resumes', fileName);
            
            // Check if file exists
            if (!fs.existsSync(filePath)) {
                return res.status(404).json({ message: "File not found on server" });
            }

            // Send file as download
            res.download(filePath, resume.originalFileName, (err) => {
                if (err) {
                    console.error('Error downloading file:', err);
                    if (!res.headersSent) {
                        res.status(500).json({ message: "Error downloading file" });
                    }
                }
            });
        } catch (err) {
            console.error('Error in downloadResume:', err);
            res.status(500).json({ message: "Error downloading resume", error: err });
        }
    },

}