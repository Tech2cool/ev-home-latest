import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageProjectsPage extends StatefulWidget {
  const ManageProjectsPage({super.key});

  @override
  State<ManageProjectsPage> createState() => _ManageProjectsPageState();
}

class _ManageProjectsPageState extends State<ManageProjectsPage> {
  String searchQuery = '';
  bool isLoading = false;

  Future<void> getPorjects() async {
    try {
      final settingProvider = context.read<SettingProvider>();
      setState(() {
        isLoading = true;
      });
      await settingProvider.getOurProject();
    } catch (e) {
      // print(e);
      Helper.showCustomSnackBar("Unkown Error for Fetch Projects $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPorjects();
  }

  @override
  Widget build(BuildContext context) {
    // Filter projects based on the search query
    final settingProvider = Provider.of<SettingProvider>(context);
    final filteredProjects = settingProvider.ourProject.where((project) {
      final nameLower = project.name.toLowerCase();
      final searchLower = searchQuery.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Manage Projects'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search field
                TextField(
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search Project',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                // List of projects
                Expanded(
                  child: filteredProjects.isEmpty
                      ? const Center(
                          child: Text('No projects found.'),
                        )
                      : RefreshIndicator(
                          onRefresh: getPorjects,
                          child: ListView.builder(
                            itemCount: filteredProjects.length,
                            itemBuilder: (context, index) {
                              final project = filteredProjects[index];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 5),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 20,
                                  child: ClipOval(
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Image.network(
                                        project.showCaseImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // child: Text(
                                  //   project.name[0].toUpperCase(),
                                  //   style: const TextStyle(color: Colors.white),
                                  // ),
                                ),
                                title: Text(project.name),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'Edit') {
                                      _editProject(project);
                                    } else if (value == 'Delete') {
                                      _deleteProject(project);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'Edit',
                                      child: Text('Edit'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'Delete',
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                  icon: const Icon(Icons.more_vert_rounded),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }

  // Function to handle edit action
  void _editProject(OurProject project) {
    //TODO: Edit Project
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => EditNewProjectPage(ourProj: project),
    //   ),
    // );
  }

  // Function to handle delete action
  void _deleteProject(OurProject project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Are you sure you want to delete this project?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                // projects.removeWhere((p) => p['id'] == project['id']);
              });
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
