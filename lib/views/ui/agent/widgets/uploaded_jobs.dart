import 'package:flutter/material.dart';
import 'package:jobhubv2_0/controllers/agents_provider.dart';
import 'package:jobhubv2_0/models/response/jobs/jobs_response.dart';
import 'package:jobhubv2_0/views/common/loader.dart';
import 'package:jobhubv2_0/views/common/pages_loader.dart';
import 'package:jobhubv2_0/views/ui/agent/widgets/uploaded_job_tile.dart';
import 'package:provider/provider.dart';

class UploadedJobs extends StatelessWidget {
  const UploadedJobs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AgentsNotifier>(
      builder: (context, agentNotifier, child) {
        agentNotifier.getJobsList(agentNotifier.agent.uid);
      
        return FutureBuilder<List<JobsResponse>>(
            future: agentNotifier.jobsList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const PageLoader();
              } else if (snapshot.hasError) {
                return Text("Error ${snapshot.error}");
              } else if (snapshot.data!.isEmpty) {
                return const NoSearchResults(text: "No Jobs to display");
              } else {
                final job = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: ListView.builder(
                      itemCount: job!.length,
                      itemBuilder: (context, index) {
                        final jobs = job[index];
                        return UploadedTile(
                          text:'agent',
                          job: jobs,
                        );
                      }),
                );
              }
            });
      },
    );
  }
}
