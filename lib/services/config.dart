class Config {
  //static const apiUrl = "jobhub-v2-production.up.railway.app";
  static const apiUrl = "localhost:5002"; // Use localhost for web/Chrome
  static const String baseUrl = "http://localhost:5002"; // Complete URL with protocol for API calls
  static const String loginUrl = "/api/login";
  static const String signupUrl = "/api/register";
  static const String jobs = "/api/jobs";
  static const String search = "/api/jobs/search";
  static const String job = "/api/jobs";
  static const String profileUrl = "/api/users/profile";
  static const String skills = "/api/users/skills";
  static const String getprofileUrl = "/api/users/profile";
  static const String getAgents = "/api/users/agents";
  static const String bookmarkUrl = "/api/bookmarks";
  static const String singleBookmarkUrl = "/api/bookmarks/bookmark/";
  static const String applied = "/api/applied";
}
