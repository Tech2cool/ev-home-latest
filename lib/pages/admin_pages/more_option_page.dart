import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/admin_pages/admin_management/my_site_visit_page.dart';
import 'package:ev_homes/pages/admin_pages/app_dev_pages/app_dev_dashboard.dart';
import 'package:ev_homes/pages/admin_pages/upload_shorts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MoreOptionPage extends StatefulWidget {
  const MoreOptionPage({super.key});

  @override
  State<MoreOptionPage> createState() => _MoreOptionPageState();
}

class _MoreOptionPageState extends State<MoreOptionPage> {
  // Parent dropdown values
  String? selectedParent;

  // Child dropdown values
  String? selectedChild;

  // Data linking parent to child
  final Map<String, List<String>> parentChildData = {
    'Fruits': ['Apple', 'Banana', 'Orange'],
    'Vehicles': ['Car', 'Bike', 'Truck'],
    'Countries': ['USA', 'India', 'Germany'],
  };

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final loggedDesg = settingProvider.loggedAdmin?.designation;

    return Scaffold(
      appBar: AppBar(
        title: const Text("More Options"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (loggedDesg!.id == "desg-post-sales-head" ||
                loggedDesg!.id == "desg-app-developer" ||
                loggedDesg!.id == "desg-site-head") ...[
              ListTile(
                onTap: () {
                  GoRouter.of(context).push("/manage-employee");
                },
                leading: const Icon(
                  Icons.account_circle_outlined,
                  size: 30,
                  color: Colors.deepPurple,
                ),
                title: const Text(
                  "Employees",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                subtitle: const Text(
                  "Manage Employee",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
              ),
            ],
            if (loggedDesg!.id == "desg-post-sales-head" ||
                loggedDesg!.id == "desg-app-developer" ||
                loggedDesg!.id == "desg-site-head")
              ListTile(
                onTap: () {
                  GoRouter.of(context).push("/manage-channel-partners");
                },
                leading: const Icon(
                  Icons.account_circle_outlined,
                  size: 30,
                  color: Colors.deepPurple,
                ),
                title: const Text(
                  "Associated Channel Partner",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                subtitle: const Text(
                  "Manage Channel Partners",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
              ),
            if (loggedDesg!.id == "desg-post-sales-head" ||
                loggedDesg!.id == "desg-app-developer" ||
                loggedDesg!.id == "desg-site-head")
              ExpansionTile(
                leading: const Icon(
                  Icons.business_rounded,
                  color: Colors.deepPurple,
                ),
                title: const Text('Projects'),
                subtitle: const Text('Manage Projects'),
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      GoRouter.of(context).push("/add-project");
                    },
                    leading: Icon(
                      Icons.create_new_folder_outlined,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text(
                      "Add New Project",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      //TODO:// manage Project
                      GoRouter.of(context).push("/manage-projects");
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => const ManageProjectsPage(),
                      //   ),
                      // );
                    },
                    leading: Icon(
                      Icons.list_alt,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text(
                      "Manage Projects",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                    ),
                  ),
                ],
              ),
            if (loggedDesg!.id == "desg-post-sales-head" ||
                loggedDesg!.id == "desg-app-developer" ||
                loggedDesg!.id == "desg-site-head")
              ExpansionTile(
                leading: const Icon(
                  Icons.business_rounded,
                  color: Colors.deepPurple,
                ),
                title: const Text('Organization'),
                subtitle: const Text('Manage Organization settings'),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.home_work,
                        color: Theme.of(context).primaryColor),
                    title: const Text('Divisions'),
                    subtitle: const Text('Manage Divisions'),
                    onTap: () {
                      GoRouter.of(context).push("/manage-division");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.apartment,
                        color: Theme.of(context).primaryColor),
                    title: const Text('Departments'),
                    subtitle: const Text('Manage Departments'),
                    onTap: () {
                      GoRouter.of(context).push("/manage-department");
                    },
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.work, color: Theme.of(context).primaryColor),
                    title: const Text('Designations'),
                    subtitle: const Text('Manage Designations'),
                    onTap: () {
                      GoRouter.of(context).push("/manage-designation");
                    },
                  ),
                ],
              ),
            if (loggedDesg!.id == "desg-post-sales-head" ||
                loggedDesg!.id == "desg-app-developer" ||
                loggedDesg!.id == "desg-site-head" ||
                loggedDesg!.id == "desg-floor-manager")
              ListTile(
                onTap: () {
                  GoRouter.of(context).push("/manage-site-visit");
                },
                leading: const Icon(
                  Icons.account_circle_outlined,
                  size: 30,
                  color: Colors.deepPurple,
                ),
                title: const Text(
                  "Site Visits",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                subtitle: const Text(
                  "Manage Site Visit",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
              ),
            if (loggedDesg!.id == "desg-post-sales-head" ||
                loggedDesg!.id == "desg-app-developer" ||
                loggedDesg!.id == "desg-site-head" ||
                loggedDesg!.id == "desg-senior-closing-manager")
              ListTile(
                onTap: () {
                  GoRouter.of(context).push("/my-site-visit");
                },
                leading: const Icon(
                  Icons.account_circle_outlined,
                  size: 30,
                  color: Colors.deepPurple,
                ),
                title: const Text(
                  "Site Visits",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                subtitle: const Text(
                  "My Site Visit",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
              ),
            if (loggedDesg!.id == "desg-post-sales-head" ||
                loggedDesg!.id == "desg-app-developer" ||
                loggedDesg!.id == "desg-site-head")
              ListTile(
                onTap: () {
                  TODO: // Upload Shorts

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UploadShorts()));
                },
                leading: Icon(
                  Icons.create_new_folder_outlined,
                  size: 30,
                  color: Colors.deepPurple,
                ),
                title: const Text(
                  "Upload Files",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
              ),
            if (loggedDesg!.id == "desg-post-sales-head" ||
                loggedDesg!.id == "desg-app-developer" ||
                loggedDesg!.id == "desg-site-head")
              ListTile(
                onTap: () {
                  //TODO:// manage Project
                  // GoRouter.of(context).push("/manage-projects");
                  if (loggedDesg!.id == "desg-post-sales-head" ||
                      loggedDesg!.id == "desg-app-developer" ||
                      loggedDesg!.id == "desg-site-head")
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AppDevDashboard(),
                      ),
                    );
                },
                leading: Icon(
                  Icons.list_alt,
                  size: 30,
                  color: Theme.of(context).primaryColor,
                ),
                title: const Text(
                  "Super Admin Dashboard",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
