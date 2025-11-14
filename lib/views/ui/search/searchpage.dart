import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhubv2_0/controllers/search_provider.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/loader.dart';
import 'package:jobhubv2_0/views/common/pages_loader.dart';
import 'package:jobhubv2_0/views/ui/jobs/widgets/job_tile.dart';
import 'package:jobhubv2_0/views/ui/search/widgets/custom_field.dart';
import 'package:jobhubv2_0/views/ui/search/widgets/advanced_search.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController search = TextEditingController();
  bool _showSuggestions = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(kLight.value),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Color(kLight.value)),
        title: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          child: CustomField(
            hintText: " Search For Jobs",
            controller: search,
            onEditingComplete: () {
              if (search.text.trim().isNotEmpty) {
                context.read<SearchNotifier>().searchJobs(search.text);
                setState(() {
                  _showSuggestions = false;
                });
              }
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: Color(kDark.value)),
            onPressed: () {
              _showAdvancedSearch(context);
            },
          ),
        ],
        elevation: 0,
      ),
      body: Consumer<SearchNotifier>(
        builder: (context, searchNotifier, child) {
          if (search.text.isEmpty || _showSuggestions) {
            // Show suggestions when no search term
            return _buildSearchSuggestions(searchNotifier);
          }

          if (searchNotifier.isSearching) {
            return const PageLoader();
          }

          if (searchNotifier.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Color(kDarkGrey.value),
                  ),
                  SizedBox(height: 16),
                  Text(
                    searchNotifier.errorMessage,
                    style: appStyle(16, Color(kDarkGrey.value), FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      searchNotifier.searchJobs(search.text);
                    },
                    child: Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (searchNotifier.searchResults.isEmpty) {
            return const NoSearchResults(text: "No jobs found for your search");
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${searchNotifier.searchResults.length} jobs found",
                  style: appStyle(14, Color(kDarkGrey.value), FontWeight.w500),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: searchNotifier.searchResults.length,
                    itemBuilder: (context, index) {
                      final job = searchNotifier.searchResults[index];
                      return VerticalTileWidget(job: job);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchSuggestions(SearchNotifier searchNotifier) {
    final suggestions = searchNotifier.getSearchSuggestions();
    
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Popular Searches",
            style: appStyle(18, Color(kDark.value), FontWeight.w600),
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    search.text = suggestions[index];
                    searchNotifier.searchJobs(suggestions[index]);
                    setState(() {
                      _showSuggestions = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(kLightGrey.value),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(kLightGrey.value)),
                    ),
                    child: Center(
                      child: Text(
                        suggestions[index],
                        style: appStyle(12, Color(kDark.value), FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAdvancedSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AdvancedSearchBottomSheet(),
    );
  }
}
