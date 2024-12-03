import 'package:ev_homes/components/unkown_error_page.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/admin_pages/app_dev_pages/app_dev_dashboard.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/post_sale_head_pages/post_sale_head_dashboard.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/post_sales_executive_pages/postsaleexecutive_dashboard.dart.dart';
import 'package:ev_homes/pages/admin_pages/pre_sales_pages/data_analyzer_pages/data_analyzer_dashboard.dart';
import 'package:ev_homes/pages/admin_pages/pre_sales_pages/pre_sales_executive_pages/pre_sales_executive_dashboard.dart';
import 'package:ev_homes/pages/admin_pages/sales_pages/closing_manager_pages/closing_manager_dashboard.dart';
import 'package:ev_homes/pages/admin_pages/sales_pages/sales_manager_pages/sales_manager_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  final String? id;
  const DashboardPage({super.key, this.id});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Widget getDashboard() {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    final loggedDesg = settingProvider.loggedAdmin?.designation?.id;

    if (loggedDesg == null) {
      return const UnknownErrorPage();
    }

    if (loggedDesg.toLowerCase() == "desg-data-analyzer") {
      return DataAnalyzerDashboard(id: widget.id);
    } else if (loggedDesg.toLowerCase() == "desg-senior-closing-manager" ||
        loggedDesg.toLowerCase() == "desg-site-head") {
      return ClosingManagerDashboard(id: widget.id);
    } else if (loggedDesg.toLowerCase() == "desg-pre-sales-executive") {
      return PreSalesExecutiveDashboard(id: widget.id);
    } else if (loggedDesg.toLowerCase() == "desg-app-developer") {
      return const AppDevDashboard();
    } else if (loggedDesg.toLowerCase() == "desg-post-sales-head") {
      return PostSaleHeadDashboard(id: widget.id);
    } else if (loggedDesg.toLowerCase() == "desg-sales-manager") {
      return SalesManagerDashboard(id: widget.id);
    } else if (loggedDesg.toLowerCase() == "desg-post-sales-executive") {
      return const PostsaleexcecutiveDashboard();
    }

    return const UnknownErrorPage();
  }

  @override
  Widget build(BuildContext context) {
    return getDashboard();
  }
}
