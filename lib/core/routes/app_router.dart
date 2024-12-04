import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/models/post_sale_lead.dart';
import 'package:ev_homes/pages/admin_pages/admin_forms/add_channer_partner_page.dart';
import 'package:ev_homes/pages/admin_pages/admin_forms/add_new_project_page.dart';
import 'package:ev_homes/pages/admin_pages/admin_forms/add_payment.dart';
import 'package:ev_homes/pages/admin_pages/admin_forms/add_postsale_lead.dart';
import 'package:ev_homes/pages/admin_pages/admin_forms/add_site_visit_form_page.dart';
import 'package:ev_homes/pages/admin_pages/admin_forms/admin_client_tagging_form.dart';
import 'package:ev_homes/pages/admin_pages/admin_forms/edit_new_project_page.dart';
import 'package:ev_homes/pages/admin_pages/admin_management/manage_channel_partners.dart';
import 'package:ev_homes/pages/admin_pages/admin_management/manage_department.dart';
import 'package:ev_homes/pages/admin_pages/admin_management/manage_designation_page.dart';
import 'package:ev_homes/pages/admin_pages/admin_management/manage_division.dart';
import 'package:ev_homes/pages/admin_pages/admin_management/manage_employee.dart';
import 'package:ev_homes/pages/admin_pages/admin_management/manage_projects_page.dart';
import 'package:ev_homes/pages/admin_pages/admin_management/manage_site_visit_page.dart';
import 'package:ev_homes/pages/admin_pages/admin_profile_page.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/post_sale_head_pages/post_sale_head__tagging_list_page.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/post_sale_head_pages/post_sale_head_assigned.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/post_sales_executive_pages/postsaleexecutive_tagging_list_page.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/postsale_internal_tagging_details.dart';
import 'package:ev_homes/pages/admin_pages/pre_sales_pages/data_analyzer_pages/data_analyzer_lead_details_page.dart';
import 'package:ev_homes/pages/admin_pages/pre_sales_pages/data_analyzer_pages/data_analyzer_lead_list_page.dart';
import 'package:ev_homes/pages/admin_pages/pre_sales_pages/data_analyzer_pages/data_analyzer_review_page.dart';
import 'package:ev_homes/pages/admin_pages/pre_sales_pages/pre_sales_executive_pages/pre_sales_executive_details_page.dart';
import 'package:ev_homes/pages/admin_pages/pre_sales_pages/pre_sales_executive_pages/pre_sales_executive_lead_list_page.dart';
import 'package:ev_homes/pages/admin_pages/sales_pages/closing_manager_pages/closing_manager_lead_details_page.dart';
import 'package:ev_homes/pages/admin_pages/sales_pages/closing_manager_pages/closing_manager_lead_list_page.dart';
import 'package:ev_homes/pages/admin_pages/sales_pages/sales_manager_pages/sales_manager_lead_details_page.dart';
import 'package:ev_homes/pages/admin_pages/sales_pages/sales_manager_pages/sales_manager_lead_list_page.dart';
import 'package:ev_homes/pages/admin_pages/view_payment.dart';
import 'package:ev_homes/pages/login_pages/admin_forgot_password_page.dart';
import 'package:ev_homes/pages/login_pages/admin_register_page.dart';
import 'package:ev_homes/pages/splash_screen.dart';
import 'package:ev_homes/pages/starter_page.dart';
import 'package:ev_homes/wrappers/admin_home_wrapper.dart';
import 'package:ev_homes/wrappers/auth_wrapper.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static GoRouter router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      GoRoute(
        path: '/first-page',
        builder: (context, state) {
          return const StarterPage();
        },
      ),

      //wrappers
      GoRoute(
        path: '/auth-wrapper',
        builder: (context, state) {
          return const AuthWrapper();
        },
      ),
      GoRoute(
        path: '/admin-home-wrapper',
        builder: (context, state) {
          return const AdminHomeWrapper();
        },
      ),
      //pages
      GoRoute(
        path: '/add-client-tagging-lead',
        builder: (context, state) {
          return const AdminClientTaggingForm();
        },
      ),

      GoRoute(
        path: '/data-analyzer-lead-list/:status',
        builder: (context, state) {
          final status = state.pathParameters['status'] ?? '';
          return DataAnalyzerLeadListPage(status: status);
        },
      ),

      GoRoute(
        path: '/data-analyzer-lead-details',
        builder: (context, state) {
          final lead = state.extra as Lead;
          return DataAnalyzerLeadDetailsPage(lead: lead);
        },
      ),
      GoRoute(
        path: '/data-analyzer-lead-review',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null || !extra.containsKey('lead')) {
            throw Exception('No lead data provided in GoRouter state.extra');
          }

          final lead = extra['lead'] as Lead;
          final similarLeads = extra['similarLeads'] as List<Lead>;
          return DataAnalyzerReviewPage(
            lead: lead,
            similarLeads: similarLeads,
          );
        },
      ),
      GoRoute(
        path: '/add-booking',
        builder: (context, state) {
          return const AddPostsaleLead();
        },
      ),
      GoRoute(
        path: '/add-payment-info',
        builder: (context, state) {
          return const AddPayment();
        },
      ),
      GoRoute(
        path: '/view-payment-info',
        builder: (context, state) {
          return const ViewPayment();
        },
      ),
      // employee routes
      GoRoute(
        path: '/manage-employee',
        builder: (context, state) {
          return const ManageEmployee();
        },
      ),
      //channel partner routes
      GoRoute(
        path: '/manage-channel-partners',
        builder: (context, state) {
          return const ManageChannelPartners();
        },
      ),
      GoRoute(
        path: '/add-channel-partner',
        builder: (context, state) {
          return const AddChannerPartnerPage();
        },
      ),

      // project routes
      GoRoute(
        path: '/add-project',
        builder: (context, state) {
          return const AddNewProjectPage();
        },
      ),
      GoRoute(
        path: '/manage-projects',
        builder: (context, state) {
          return const ManageProjectsPage();
        },
      ),
      GoRoute(
        path: '/edit-project',
        builder: (context, state) {
          final project = state.extra as OurProject;
          return EditNewProjectPage(ourProj: project);
        },
      ),
      // org routes
      GoRoute(
        path: '/manage-division',
        builder: (context, state) {
          return const ManageDivision();
        },
      ),
      GoRoute(
        path: '/manage-designation',
        builder: (context, state) {
          return const ManageDesignationPage();
        },
      ),
      GoRoute(
        path: '/manage-department',
        builder: (context, state) {
          return const ManageDepartment();
        },
      ),

      // site visit routes
      GoRoute(
        path: '/manage-site-visit',
        builder: (context, state) {
          return const ManageSiteVisitPage();
        },
      ),
      GoRoute(
        path: '/add-site-visit',
        builder: (context, state) {
          return const AddSiteVisitFormPage();
        },
      ),
      GoRoute(
        path: '/admin-profile',
        builder: (context, state) {
          return const AdminProfilePage();
        },
      ),
      GoRoute(
        path: '/admin-register',
        builder: (context, state) {
          return const AdminRegisterPage();
        },
      ),
      GoRoute(
        path: '/admin-forgot-password',
        builder: (context, state) {
          return const AdminForgotPasswordPage();
        },
      ),

      GoRoute(
        path: '/closing-manager-lead-list/:status/:id',
        builder: (context, state) {
          final status = state.pathParameters['status'] ?? '';
          final id = state.pathParameters['id'];
          return ClosingManagerLeadListPage(
            status: status,
            id: id,
          );
        },
      ),
      GoRoute(
        path: '/closing-manager-lead-details',
        builder: (context, state) {
          final lead = state.extra as Lead;
          return ClosingManagerLeadDetailsPage(lead: lead);
        },
      ),
      GoRoute(
        path: '/closing-manager-follow-up-list/:status/:id',
        builder: (context, state) {
          final status = state.pathParameters['status'] ?? '';
          final id = state.pathParameters['id'];
          return ClosingManagerLeadListPage(
            status: status,
            id: id,
          );
        },
      ),

      GoRoute(
        path: '/sales-manager-lead-list/:status/:id',
        builder: (context, state) {
          final status = state.pathParameters['status'] ?? '';
          final id = state.pathParameters['id'];
          return SalesManagerLeadListPage(
            status: status,
            id: id,
          );
        },
      ),
      GoRoute(
        path: '/sales-manager-lead-details',
        builder: (context, state) {
          final lead = state.extra as Lead;
          return SalesManagerLeadDetailsPage(lead: lead);
        },
      ),

      // pre sale executives
      GoRoute(
        path: '/pre-sales-executive-lead-list/:status/:id',
        builder: (context, state) {
          final status = state.pathParameters['status'] ?? '';
          final id = state.pathParameters['id'];
          return PreSalesExecutiveLeadListPage(
            status: status,
            id: id,
          );
        },
      ),

      GoRoute(
        path: '/pre-sales-executive-lead-details',
        builder: (context, state) {
          final lead = state.extra as Lead;
          return PreSalesExecutiveDetailsPage(lead: lead);
        },
      ),
      //post sale
      GoRoute(
        path: '/post-sale-head-lead-list/:status',
        builder: (context, state) {
          final status = state.pathParameters['status'] ?? '';

          return PostSaleHeadTaggingListPage(
            status: status,
          );
        },
      ),
      GoRoute(
        path: '/post-sale-head-assign-lead/:status',
        builder: (context, state) {
          final status = state.pathParameters['status'] ?? '';

          return PostSaleHeadAssigned(
            status: status,
          );
        },
      ),
      GoRoute(
        path: '/post-sales-lead-details',
        builder: (context, state) {
          final lead = state.extra as PostSaleLead;

          return PostsaleInternalTaggingDetails(lead: lead);
        },
      ),
      GoRoute(
        path: '/post-sales-executive-lead-list/:status/:id',
        builder: (context, state) {
          final status = state.pathParameters['status'] ?? '';
          final id = state.pathParameters['id'];
          return PostsaleexecutiveTaggingListPage(
            status: status,
            id: id,
          );
        },
      ),
    ],
  );
}
