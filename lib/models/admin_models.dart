class AdminStats {
  final int totalUsers;
  final int totalAgents;
  final int totalJobs;
  final int totalApplications;
  final int activeJobs;
  final int inactiveJobs;
  final int newUsersThisWeek;
  final int newJobsThisWeek;
  final int newApplicationsThisWeek;

  AdminStats({
    required this.totalUsers,
    required this.totalAgents,
    required this.totalJobs,
    required this.totalApplications,
    required this.activeJobs,
    required this.inactiveJobs,
    required this.newUsersThisWeek,
    required this.newJobsThisWeek,
    required this.newApplicationsThisWeek,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      totalUsers: json['totalUsers'] ?? 0,
      totalAgents: json['totalAgents'] ?? 0,
      totalJobs: json['totalJobs'] ?? 0,
      totalApplications: json['totalApplications'] ?? 0,
      activeJobs: json['activeJobs'] ?? 0,
      inactiveJobs: json['inactiveJobs'] ?? 0,
      newUsersThisWeek: json['newUsersThisWeek'] ?? 0,
      newJobsThisWeek: json['newJobsThisWeek'] ?? 0,
      newApplicationsThisWeek: json['newApplicationsThisWeek'] ?? 0,
    );
  }
}

class AdminUser {
  final String id;
  final String username;
  final String email;
  final String? location;
  final String? phone;
  final bool isAgent;
  final String profile;
  final DateTime createdAt;

  AdminUser({
    required this.id,
    required this.username,
    required this.email,
    this.location,
    this.phone,
    required this.isAgent,
    required this.profile,
    required this.createdAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      location: json['location'],
      phone: json['phone'],
      isAgent: json['isAgent'] ?? false,
      profile: json['profile'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class AdminJob {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final bool hiring;
  final DateTime createdAt;

  AdminJob({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.hiring,
    required this.createdAt,
  });

  factory AdminJob.fromJson(Map<String, dynamic> json) {
    return AdminJob(
      id: json['_id'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      salary: json['salary'],
      hiring: json['hiring'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ChartData {
  final String month;
  final int count;

  ChartData({required this.month, required this.count});

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      month: json['month'],
      count: json['count'] ?? 0,
    );
  }
}
