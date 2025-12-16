/**
 * Job Matching Controller
 * 
 * Handles API endpoints for job matching algorithm
 */

const JobMatchingService = require('../services/jobMatchingService');

module.exports = {
  /**
   * GET /api/matching/jobs/:userId
   * Get recommended jobs for a specific user
   */
  getRecommendedJobs: async (req, res) => {
    try {
      const { userId } = req.params;
      const { limit = 10 } = req.query;

      const matchedJobs = await JobMatchingService.getMatchedJobsForUser(
        userId,
        parseInt(limit)
      );

      res.status(200).json({
        success: true,
        message: 'Recommended jobs fetched successfully',
        totalJobs: matchedJobs.length,
        jobs: matchedJobs,
      });
    } catch (error) {
      console.error('Error fetching recommended jobs:', error);
      res.status(500).json({
        success: false,
        message: 'Error fetching recommended jobs',
        error: error.message,
      });
    }
  },

  /**
   * GET /api/matching/users/:jobId
   * Get recommended candidates for a specific job
   */
  getRecommendedUsers: async (req, res) => {
    try {
      const { jobId } = req.params;
      const { limit = 10 } = req.query;

      const matchedUsers = await JobMatchingService.getMatchedUsersForJob(
        jobId,
        parseInt(limit)
      );

      res.status(200).json({
        success: true,
        message: 'Recommended candidates fetched successfully',
        totalUsers: matchedUsers.length,
        users: matchedUsers,
      });
    } catch (error) {
      console.error('Error fetching recommended users:', error);
      res.status(500).json({
        success: false,
        message: 'Error fetching recommended users',
        error: error.message,
      });
    }
  },

  /**
   * GET /api/matching/score/:userId/:jobId
   * Calculate match score between a user and a job
   */
  getMatchScore: async (req, res) => {
    try {
      const { userId, jobId } = req.params;

      const result = await JobMatchingService.calculateMatchScore(userId, jobId);

      res.status(200).json({
        success: true,
        message: 'Match score calculated successfully',
        data: result,
      });
    } catch (error) {
      console.error('Error calculating match score:', error);
      res.status(500).json({
        success: false,
        message: 'Error calculating match score',
        error: error.message,
      });
    }
  },

  /**
   * GET /api/matching/summary/:userId
   * Get matching summary and statistics for a user
   */
  getUserMatchSummary: async (req, res) => {
    try {
      const { userId } = req.params;

      const summary = await JobMatchingService.getUserRecommendationsSummary(userId);

      res.status(200).json({
        success: true,
        message: 'Recommendation summary fetched successfully',
        data: summary,
      });
    } catch (error) {
      console.error('Error fetching user summary:', error);
      res.status(500).json({
        success: false,
        message: 'Error fetching recommendation summary',
        error: error.message,
      });
    }
  },
};
