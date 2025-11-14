import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhubv2_0/controllers/search_provider.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/custom_btn.dart';

import 'package:provider/provider.dart';

class AdvancedSearchBottomSheet extends StatefulWidget {
  const AdvancedSearchBottomSheet({super.key});

  @override
  State<AdvancedSearchBottomSheet> createState() => _AdvancedSearchBottomSheetState();
}

class _AdvancedSearchBottomSheetState extends State<AdvancedSearchBottomSheet> {
  final TextEditingController _searchTermController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  String _selectedContract = '';
  String _selectedPeriod = '';

  final List<String> _contractTypes = [
    'All',
    'Full-time',
    'Part-time',
    'Contract',
    'Freelance',
    'Internship',
    'Temporary'
  ];

  final List<String> _periodTypes = [
    'All',
    'Full-time',
    'Part-time',
    'Remote',
    'Hybrid',
    'On-site'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Color(kLight.value),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Advanced Search",
                  style: appStyle(20, Color(kDark.value), FontWeight.w600),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Color(kDarkGrey.value)),
                ),
              ],
            ),
            
            Divider(color: Color(kLightGrey.value)),
            SizedBox(height: 20.h),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Term
                    Text(
                      "Job Title or Keywords",
                      style: appStyle(14, Color(kDark.value), FontWeight.w500),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _searchTermController,
                      decoration: InputDecoration(
                        hintText: "e.g., Software Developer, Marketing",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(kLightGrey.value)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(kLightGrey.value)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(kLight.value)),
                        ),
                        filled: true,
                        fillColor: Color(kLightGrey.value),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    
                    SizedBox(height: 20.h),

                    // Location
                    Text(
                      "Location",
                      style: appStyle(14, Color(kDark.value), FontWeight.w500),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: "e.g., New York, London, Remote",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(kLightGrey.value)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(kLightGrey.value)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(kLight.value)),
                        ),
                        filled: true,
                        fillColor: Color(kLightGrey.value),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Contract Type
                    Text(
                      "Employment Type",
                      style: appStyle(14, Color(kDark.value), FontWeight.w500),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _contractTypes.map((contract) {
                        bool isSelected = _selectedContract == contract;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedContract = isSelected ? '' : contract;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Color(kLight.value) : Color(kLightGrey.value),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? Color(kLight.value) : Color(kLightGrey.value),
                              ),
                            ),
                            child: Text(
                              contract,
                              style: appStyle(
                                12,
                                isSelected ? Colors.white : Color(kDark.value),
                                FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 20.h),

                    // Work Schedule
                    Text(
                      "Work Schedule",
                      style: appStyle(14, Color(kDark.value), FontWeight.w500),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _periodTypes.map((period) {
                        bool isSelected = _selectedPeriod == period;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPeriod = isSelected ? '' : period;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Color(kLight.value) : Color(kLightGrey.value),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? Color(kLight.value) : Color(kLightGrey.value),
                              ),
                            ),
                            child: Text(
                              period,
                              style: appStyle(
                                12,
                                isSelected ? Colors.white : Color(kDark.value),
                                FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _searchTermController.clear();
                      _locationController.clear();
                      setState(() {
                        _selectedContract = '';
                        _selectedPeriod = '';
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(kLightGrey.value)),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Clear",
                      style: appStyle(14, Color(kDarkGrey.value), FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  flex: 2,
                  child: CustomButton(
                    onTap: () {
                      // Perform advanced search
                      final searchNotifier = context.read<SearchNotifier>();
                      
                      searchNotifier.advancedSearch(
                        searchTerm: _searchTermController.text.trim().isEmpty 
                            ? null 
                            : _searchTermController.text.trim(),
                        location: _locationController.text.trim().isEmpty 
                            ? null 
                            : _locationController.text.trim(),
                        contract: _selectedContract == 'All' || _selectedContract.isEmpty 
                            ? null 
                            : _selectedContract,
                        period: _selectedPeriod == 'All' || _selectedPeriod.isEmpty 
                            ? null 
                            : _selectedPeriod,
                      );
                      
                      Navigator.pop(context);
                    },
                    text: "Search Jobs",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchTermController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}