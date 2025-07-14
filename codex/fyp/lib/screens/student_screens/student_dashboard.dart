import 'package:flutter/material.dart';
import 'package:fyp/screens/Course_Screens/Student_View/Category_course_screen.dart';
import 'package:fyp/screens/Course_Screens/Student_View/Free_Courses.dart';
import 'package:fyp/screens/Course_Screens/Teacher_View/FreeCourse_dashboard.dart';
import 'package:fyp/utils/app_colors.dart';
import 'package:fyp/custom_widgets/container.dart';

class StudentDashboardScreen extends StatefulWidget {
  @override
  _StudentDashboardScreen createState() => _StudentDashboardScreen();
}

class _StudentDashboardScreen extends State<StudentDashboardScreen> {
  final List<String> _categories = [
    'App Development',
    'Web Development',
    'E-commerce',
    'Amazon',
    'Computer Science',
    'Math',
    'Physics',
    'English',
    'Chemistry',
    'Other'
  ];

  final List<String> _categoryImages = [
    'assets/app_development.png',
    'assets/web_development.png',
    'assets/ecommerence.png',
    'assets/amazon.png',
    'assets/computerscience.png',
    'assets/math.png',
    'assets/physics.png',
    'assets/english.png',
    'assets/chemistry.png',
    'assets/others.png',
  ];

  String _searchQuery = ''; // Track the search query

  @override
  Widget build(BuildContext context) {
    // Filter categories based on the search query
    final filteredCategories = _categories
        .asMap()
        .entries
        .where((entry) =>
            entry.value.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: Column(
        children: [
          mycontainer(
            height: 200,
            width: 450,
            borderRadius: 20,
            color: Mycolors.primary_cyan,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Welcome to\nStudyBuddy',
                        style: TextStyle(
                          color: Mycolors.Text_white,
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                        ),
                      ),
                      Icon(
                        Icons.notifications,
                        color: Mycolors.Text_white,
                        size: 35,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value; // Update search query
                      });
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Mycolors.secondary_grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fillColor: Mycolors.Text_white,
                      filled: true,
                      hintText: 'Search Your Topic',
                      hintStyle:
                          const TextStyle(color: Mycolors.secondary_grey),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12.0, top: 12.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Explore Categories',
                    style: TextStyle(
                      color: Mycolors.Text_black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0), // Adjusted padding
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                        const Size(15, 20)), // Set minimum size
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FreeCoursesScreen()));
                  },
                  child: Text(
                    "Free Courses".toUpperCase(),
                    style: const TextStyle(
                        fontSize: 12), // Reduced font size to 12
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1, // Adjusted to make the cards larger
              ),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final categoryIndex = filteredCategories[index].key;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryCoursesScreen(
                          category: _categories[categoryIndex],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          _categoryImages[categoryIndex],
                          height: 80, // Increased height
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _categories[categoryIndex],
                          style: const TextStyle(
                            fontSize: 16, // Increased font size
                            fontWeight: FontWeight.bold,
                            color: Mycolors.Text_black,
                          ),
                        ),
                      ],
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
}
