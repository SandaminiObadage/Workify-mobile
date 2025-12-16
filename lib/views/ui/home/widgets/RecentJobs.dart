import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:jobhubv2_0/controllers/jobs_provider.dart';
import 'package:jobhubv2_0/views/common/vertical_shimmer.dart';
import 'package:jobhubv2_0/views/common/vertical_tile.dart';
import 'package:jobhubv2_0/views/ui/jobs/job_page.dart';
import 'package:provider/provider.dart';

class RecentJobs extends StatefulWidget {
  const RecentJobs({
    super.key,
  });

  @override
  State<RecentJobs> createState() => _RecentJobsState();
}

class _RecentJobsState extends State<RecentJobs> {
  late Timer _refreshTimer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    // Fetch recent jobs when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobsNotifier>(context, listen: false).getRecentJobs(limit: 3);
    });

    // Set up periodic refresh every 30 seconds to check for new jobs
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        _refreshRecentJobs();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  void _refreshRecentJobs() {
    if (!_isRefreshing && mounted) {
      setState(() => _isRefreshing = true);
      Provider.of<JobsNotifier>(context, listen: false).getRecentJobs(limit: 3);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _isRefreshing = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsNotifier>(
      builder: (context, jobNotifier, child) {
        return FutureBuilder(
            future: jobNotifier.recentJobsList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const VerticalShimmer();
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text("Error loading recent jobs: ${snapshot.error}"),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshRecentJobs,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Text('No recent jobs available')),
                );
              } else {
                final recentJobs = snapshot.data!;
                return Column(
                  children: [
                    // Add refresh button
                    if (_isRefreshing)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentJobs.length,
                      itemBuilder: (context, index) {
                        final job = recentJobs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => JobPage(
                                  title: job.company,
                                  id: job.id,
                                  agentName: job.agentName));
                            },
                            child: VerticalTile(job: job),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
            });
      },
    );
  }
}

