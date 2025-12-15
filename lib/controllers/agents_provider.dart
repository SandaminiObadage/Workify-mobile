import 'package:flutter/material.dart';
import 'package:jobhubv2_0/models/request/agents/agents.dart';
import 'package:jobhubv2_0/models/response/agent/getAgent.dart';
import 'package:jobhubv2_0/models/response/applied/applied.dart';
import 'package:jobhubv2_0/models/response/jobs/jobs_response.dart';
import 'package:jobhubv2_0/services/helpers/agents_helper.dart';
import 'package:jobhubv2_0/services/helpers/applied_helper.dart';

class AgentsNotifier extends ChangeNotifier {
  late Agents agent;
  late Map<String, dynamic> chat;
  late Future<List<Agents>> agentsList;
  late Future<List<JobsResponse>> jobsList;
  late Future<List<Applied>> appliedList;
  late Future<GetAgent> getAgent;
  
  // Cache agents to avoid refetching on every rebuild
  Future<List<Agents>>? _cachedAgentsList;

  Future<List<Agents>> getAgents() {
    // Return cached future if it already exists
    if (_cachedAgentsList != null) {
      return _cachedAgentsList!;
    }
    
    // Otherwise fetch and cache
    _cachedAgentsList = AngenciesHelper.getsAgents();
    agentsList = _cachedAgentsList!;

    return _cachedAgentsList!;
  }

  Future<List<JobsResponse>> getJobsList(String agentId) {
    jobsList = AngenciesHelper.getJobs(agentId);

    return jobsList;
  }

  Future<List<Applied>> getAppliedList() {
    appliedList = AppliedHelper.getApplied();

    return appliedList;
  }



  Future<GetAgent> getAgencyInfo(String uid) {
    getAgent = AngenciesHelper.getAgencyInfo(uid);
    return getAgent;
  }



  
}
