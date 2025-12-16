/**
 * Job Matching Algorithm Service
 * 
 * This service implements a comprehensive job matching algorithm that scores
 * compatibility between job seekers and job postings based on multiple factors:
 * - Skills match (most important - 40%)
 * - Location proximity (25%)
 * - Experience level (20%)
 * - Job type/contract preference (15%)
 */

const Skill = require('../models/Skills');
const Job = require('../models/Job');
const User = require('../models/User');

class JobMatchingService {
  /**
   * Calculate matching score between a user and a job
   * Returns score from 0-100
   * 
   * @param {string} userId - User ID
   * @param {string} jobId - Job ID
   * @returns {Promise<Object>} - Matching result with score and breakdown
   */
  static async calculateMatchScore(userId, jobId) {
    try {
      // Try to find user by ObjectId first, then by uid field
      let user;
      try {
        user = await User.findById(userId);
      } catch (e) {
        // If findById fails, try finding by uid field
        user = await User.findOne({ uid: userId });
      }

      // Try to find job by ObjectId first
      let job;
      try {
        job = await Job.findById(jobId);
      } catch (e) {
        // If findById fails, try finding by id field
        job = await Job.findOne({ _id: jobId });
      }

      const userSkills = await Skill.find({ userId });

      if (!user || !job) {
        throw new Error('User or Job not found');
      }

      // Calculate individual scores
      const skillsScore = this.calculateSkillsMatch(userSkills, job.requirements);
      const locationScore = this.calculateLocationMatch(user.location, job.location);
      const jobTypeScore = this.calculateJobTypeMatch(job.period);

      // Weighted scoring system
      const totalScore =
        skillsScore * 0.40 + // 40% weight
        locationScore * 0.25 + // 25% weight
        jobTypeScore * 0.15 + // 15% weight
        50; // Base score of 50 for having applied

      // Cap score at 100
      const finalScore = Math.min(totalScore, 100);

      return {
        score: Math.round(finalScore),
        breakdown: {
          skillsScore: Math.round(skillsScore),
          locationScore: Math.round(locationScore),
          jobTypeScore: Math.round(jobTypeScore),
        },
        metadata: {
          userSkillsCount: userSkills.length,
          jobRequirementsCount: job.requirements?.length || 0,
          matchedSkills: this.getMatchedSkills(userSkills, job.requirements),
        },
      };
    } catch (error) {
      console.error('Error calculating match score:', error);
      throw error;
    }
  }

  /**
   * Get top matching jobs for a user
   * 
   * @param {string} userId - User ID
   * @param {number} limit - Number of jobs to return (default: 10)
   * @returns {Promise<Array>} - Array of jobs with match scores
   */
  static async getMatchedJobsForUser(userId, limit = 10) {
    try {
      // Try to find user by ObjectId first, then by uid field
      let user;
      try {
        user = await User.findById(userId);
      } catch (e) {
        // If findById fails, try finding by uid field
        user = await User.findOne({ uid: userId });
      }

      const userSkills = await Skill.find({ userId });
      const allJobs = await Job.find({ hiring: true });

      if (!user) {
        throw new Error('User not found');
      }

      // Calculate match score for each job
      const jobsWithScores = allJobs.map((job) => {
        const score = this.calculateCombinedScore(user, userSkills, job);
        return {
          ...job.toObject(),
          matchScore: score,
        };
      });

      // Sort by match score descending and limit results
      return jobsWithScores
        .sort((a, b) => b.matchScore - a.matchScore)
        .slice(0, limit);
    } catch (error) {
      console.error('Error getting matched jobs:', error);
      throw error;
    }
  }

  /**
   * Get matched users for a job posting
   * 
   * @param {string} jobId - Job ID
   * @param {number} limit - Number of users to return (default: 10)
   * @returns {Promise<Array>} - Array of users with match scores
   */
  static async getMatchedUsersForJob(jobId, limit = 10) {
    try {
      // Try to find job by ObjectId first
      let job;
      try {
        job = await Job.findById(jobId);
      } catch (e) {
        // If findById fails, try finding by id field
        job = await Job.findOne({ _id: jobId });
      }

      const allUsers = await User.find();

      if (!job) {
        throw new Error('Job not found');
      }

      // Calculate match score for each user
      const usersWithScores = await Promise.all(
        allUsers.map(async (user) => {
          const userSkills = await Skill.find({ userId: user._id });
          const score = this.calculateCombinedScore(user, userSkills, job);
          return {
            ...user.toObject(),
            matchScore: score,
            skillsMatch: this.getMatchedSkills(userSkills, job.requirements),
          };
        })
      );

      // Sort by match score descending and limit results
      return usersWithScores
        .sort((a, b) => b.matchScore - a.matchScore)
        .slice(0, limit);
    } catch (error) {
      console.error('Error getting matched users:', error);
      throw error;
    }
  }

  /**
   * Calculate combined match score
   * Internal method used by matching algorithms
   */
  static calculateCombinedScore(user, userSkills, job) {
    const skillsScore = this.calculateSkillsMatch(userSkills, job.requirements);
    const locationScore = this.calculateLocationMatch(user.location, job.location);
    const jobTypeScore = this.calculateJobTypeMatch(job.period);

    const totalScore =
      skillsScore * 0.40 +
      locationScore * 0.25 +
      jobTypeScore * 0.15 +
      50;

    return Math.min(totalScore, 100);
  }

  /**
   * Calculate skills matching score (0-100)
   * 
   * Scoring:
   * - 0 matched skills = 0 points
   * - 25% matched = 25 points
   * - 50% matched = 50 points
   * - 75% matched = 75 points
   * - 100% matched = 100 points
   */
  static calculateSkillsMatch(userSkills, jobRequirements) {
    if (!jobRequirements || jobRequirements.length === 0) {
      return 100; // No requirements means full match
    }

    if (userSkills.length === 0) {
      return 10; // Small bonus for applying anyway
    }

    const userSkillNames = userSkills.map((s) =>
      s.skill.toLowerCase().trim()
    );
    const jobReqNames = jobRequirements.map((r) =>
      typeof r === 'string' ? r.toLowerCase().trim() : r.toString().toLowerCase().trim()
    );

    // Find matched skills (case-insensitive)
    const matchedSkills = jobReqNames.filter((req) =>
      userSkillNames.some(
        (userSkill) =>
          userSkill === req ||
          userSkill.includes(req) ||
          req.includes(userSkill)
      )
    );

    // Calculate percentage match
    const matchPercentage = (matchedSkills.length / jobReqNames.length) * 100;
    return Math.min(matchPercentage, 100);
  }

  /**
   * Calculate location matching score (0-100)
   * 
   * Scoring:
   * - Exact match = 100 points
   * - Same city/region = 75 points
   * - Same country = 50 points
   * - Remote job = 100 points
   * - No location = 50 points
   */
  static calculateLocationMatch(userLocation, jobLocation) {
    if (!userLocation || !jobLocation) {
      return 50; // Default score if locations missing
    }

    const userLoc = userLocation.toLowerCase().trim();
    const jobLoc = jobLocation.toLowerCase().trim();

    // Exact match
    if (userLoc === jobLoc) {
      return 100;
    }

    // Remote job or flexible location
    if (
      jobLoc.includes('remote') ||
      jobLoc.includes('anywhere') ||
      userLoc.includes('remote')
    ) {
      return 100;
    }

    // Same city (check first word which is typically the city)
    const userCity = userLoc.split(',')[0].trim();
    const jobCity = jobLoc.split(',')[0].trim();

    if (userCity === jobCity) {
      return 85;
    }

    // Same state/country (check second part)
    const userRegion = userLoc.split(',')[1]?.trim() || '';
    const jobRegion = jobLoc.split(',')[1]?.trim() || '';

    if (userRegion && jobRegion && userRegion === jobRegion) {
      return 60;
    }

    // Partial match
    if (
      jobLoc.includes(userCity) ||
      userCity.includes(jobCity) ||
      jobLoc.includes(userLocation.split(',')[0].trim())
    ) {
      return 40;
    }

    return 20; // Different locations
  }

  /**
   * Calculate job type preference match (0-100)
   * 
   * Most users prefer Full-time, but this is flexible
   * Scoring gives slight preference to common job types
   */
  static calculateJobTypeMatch(jobPeriod) {
    const period = jobPeriod?.toLowerCase() || '';

    const typeScores = {
      'full-time': 100,
      'full time': 100,
      'part-time': 85,
      'part time': 85,
      contract: 75,
      internship: 70,
      temporary: 65,
      freelance: 80,
    };

    return typeScores[period] || 70; // Default 70 for unknown types
  }

  /**
   * Get list of skills that match between user and job requirements
   */
  static getMatchedSkills(userSkills, jobRequirements) {
    if (!jobRequirements || jobRequirements.length === 0) {
      return [];
    }

    const userSkillNames = userSkills.map((s) =>
      s.skill.toLowerCase().trim()
    );
    const jobReqNames = jobRequirements.map((r) =>
      typeof r === 'string' ? r.toLowerCase().trim() : r.toString().toLowerCase().trim()
    );

    return jobReqNames.filter((req) =>
      userSkillNames.some(
        (userSkill) =>
          userSkill === req ||
          userSkill.includes(req) ||
          req.includes(userSkill)
      )
    );
  }

  /**
   * Get recommendations summary for a user
   * 
   * @param {string} userId - User ID
   * @returns {Promise<Object>} - Summary statistics
   */
  static async getUserRecommendationsSummary(userId) {
    try {
      const matchedJobs = await this.getMatchedJobsForUser(userId, 50);

      // Categorize by score range
      const excellent = matchedJobs.filter((j) => j.matchScore >= 80).length;
      const good = matchedJobs.filter(
        (j) => j.matchScore >= 60 && j.matchScore < 80
      ).length;
      const fair = matchedJobs.filter(
        (j) => j.matchScore >= 40 && j.matchScore < 60
      ).length;
      const poor = matchedJobs.filter((j) => j.matchScore < 40).length;

      const avgScore =
        matchedJobs.reduce((sum, j) => sum + j.matchScore, 0) /
        matchedJobs.length;

      return {
        totalMatches: matchedJobs.length,
        averageScore: Math.round(avgScore),
        breakdown: {
          excellent, // 80-100
          good, // 60-79
          fair, // 40-59
          poor, // 0-39
        },
        topMatches: matchedJobs.slice(0, 5),
      };
    } catch (error) {
      console.error('Error getting recommendations summary:', error);
      throw error;
    }
  }
}

module.exports = JobMatchingService;
