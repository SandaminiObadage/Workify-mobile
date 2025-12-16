/**
 * Job Matching Routes
 */

const express = require('express');
const router = express.Router();
const matchingController = require('../controllers/matchingController');

/**
 * Get recommended jobs for a user
 * GET /api/matching/jobs/:userId
 */
router.get('/jobs/:userId', matchingController.getRecommendedJobs);

/**
 * Get recommended candidates for a job
 * GET /api/matching/users/:jobId
 */
router.get('/users/:jobId', matchingController.getRecommendedUsers);

/**
 * Get match score between user and job
 * GET /api/matching/score/:userId/:jobId
 */
router.get('/score/:userId/:jobId', matchingController.getMatchScore);

/**
 * Get matching summary for a user
 * GET /api/matching/summary/:userId
 */
router.get('/summary/:userId', matchingController.getUserMatchSummary);

module.exports = router;
