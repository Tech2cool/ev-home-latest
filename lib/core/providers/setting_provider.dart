import 'package:dio/dio.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/channel_partner.dart';
import 'package:ev_homes/core/models/chart_model.dart';
import 'package:ev_homes/core/models/closing_manager_graph.dart';
import 'package:ev_homes/core/models/customer.dart';
import 'package:ev_homes/core/models/customer_payment.dart';
import 'package:ev_homes/core/models/department.dart';
import 'package:ev_homes/core/models/designation.dart';
import 'package:ev_homes/core/models/division.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/models/meetingSummary.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/models/pagination_model.dart';
import 'package:ev_homes/core/models/post_sale_lead.dart';
import 'package:ev_homes/core/models/site_visit.dart';
import 'package:ev_homes/core/models/target_model.dart';
import 'package:ev_homes/core/models/task.dart';
import 'package:ev_homes/core/models/team_section.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:ev_homes/core/services/shared_pref_service.dart';
import 'package:ev_homes/pages/login_pages/customer_otp_verification_page.dart';
import 'package:ev_homes/wrappers/cp_home_wrapper.dart';
import 'package:ev_homes/wrappers/customer_home_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final dio = Dio();
const storage = FlutterSecureStorage();

class SettingProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<MeetingSummary> _meeting = [];
  List<Designation> _designation = [];
  List<Division> _divisions = [];
  List<Payment> _payment = [];
  List<Department> _departments = [];
  List<Employee> _employees = [];
  List<Customer> _customer = [];
  List<Employee> _closingManagers = [];
  List<Employee> _salesManager = [];
  List<Employee> _dataEntryUsers = [];
  List<Employee> _postSalesExecutives = [];
  List<Employee> _employeeBydDesg = [];
  List<Employee> _preSaleExecutives = [];
  List<Employee> _reportingEmps = [];
  List<Employee> _seniorClosingManagers = [];

  List<ChannelPartner> _channelPartners = [];
  List<Employee> _teamLeaders = [];
  List<String> _requirements = [];

  List<Lead> _leads = [];
  List<int> _carryForwardsOptions = [];
  // List<PostSaleLead> _leadsPostSale = [];

  PaginationModel<Lead> _leadsTeamLeader = PaginationModel<Lead>(
    code: 404,
    message: '',
    page: 1,
    limit: 10,
    totalPages: 1,
    totalItems: 0,
    data: [],
  );
  PaginationModel<Lead> _leadsTeamLeaderReportingTo = PaginationModel<Lead>(
    code: 404,
    message: '',
    page: 1,
    limit: 10,
    totalPages: 1,
    totalItems: 0,
    data: [],
  );

  PaginationModel<Lead> _leadsPreSalesExectives = PaginationModel<Lead>(
    code: 404,
    message: '',
    page: 1,
    limit: 10,
    totalPages: 1,
    totalItems: 0,
    data: [],
  );
  PaginationModel<PostSaleLead> _leadsPostSalesExectives =
      PaginationModel<PostSaleLead>(
    code: 404,
    message: '',
    page: 1,
    limit: 10,
    totalPages: 1,
    totalItems: 0,
    data: [],
  );

  List<TeamSection> _teamSections = [];
  List<Task> _tasks = [];
  List<SiteVisit> _siteVisits = [];
  List<OurProject> _ourProject = [];
  List<ChannelPartner> _channelPartner = [];
  PaginationModel<PostSaleLead> _leadsPostSale = PaginationModel<PostSaleLead>(
    code: 404,
    message: '',
    page: 1,
    limit: 0,
    totalPages: 1,
    totalItems: 0,
    data: [],
  );
  List<ChartModel> leadsMonthly = [];
  List<ChartModel> leadsTeamLeaderGraphForDT = [];
  List<ChartModel> leadsPreSaleExecutiveGraphForTL = [];
  List<ChartModel> leadsTeamLeaderGraph = [];
  List<ChartModel> leadsChannelPartnerGraph = [];
  List<ChartModel> leadsFunnelGraph = [];

  PaginationModel<SiteVisit> _searchSiteVisit = PaginationModel<SiteVisit>(
    code: 404,
    message: '',
    page: 1,
    limit: 10,
    totalPages: 1,
    totalItems: 0,
    data: [],
  );
  PaginationModel<Lead> _searchLeads = PaginationModel<Lead>(
    code: 404,
    message: '',
    page: 1,
    limit: 10,
    totalPages: 1,
    totalItems: 0,
    data: [],
  );

  PaginationModel<Lead> _searchLeadsChannelPartner = PaginationModel<Lead>(
    code: 404,
    message: '',
    page: 1,
    limit: 10,
    totalPages: 1,
    totalItems: 0,
    data: [],
  );

  Employee? loggedAdmin;
  Customer? loggedCustomer;
  Customer? loggedPhone;
  OurProject? loggedProject;
  ChannelPartner? loggedChannelPartner;
  Lead? loggedPreSale;
  Target? myTarget;

  ClosingManagerGraph _closingManagerGraph = ClosingManagerGraph();
  List<Employee> get seniorClosingManagers => _seniorClosingManagers;

  ClosingManagerGraph get closingManagerGraph => _closingManagerGraph;
  List<Designation> get designations => _designation;
  List<int> get carryForwardsOptions => _carryForwardsOptions;
  List<Division> get divisions => _divisions;
  List<Payment> get payment => _payment;
  List<Department> get departments => _departments;
  List<Customer> get customer => _customer;
  List<Employee> get employees => _employees;
  List<Employee> get closingManagers => _closingManagers;
  List<Employee> get salesManager => _salesManager;
  List<Employee> get dataEntryUsers => _dataEntryUsers;
  List<Employee> get postSalesExecutives => _postSalesExecutives;
  List<TeamSection> get teamSections => _teamSections;
  List<Task> get tasks => _tasks;
  List<MeetingSummary> get meeting => _meeting;

  List<Employee> get employeeBydDesg => _employeeBydDesg;
  List<Employee> get reportingEmps => _reportingEmps;

  List<Employee> get preSaleExecutives => _preSaleExecutives;
  List<ChannelPartner> get channelPartners => _channelPartners;
  List<Lead> get leads => _leads;
  PaginationModel<PostSaleLead> get leadsPostSale => _leadsPostSale;
  PaginationModel<Lead> get leadsTeamLeader => _leadsTeamLeader;
  PaginationModel<Lead> get leadsTeamLeaderReportingTo =>
      _leadsTeamLeaderReportingTo;

  PaginationModel<Lead> get leadsPreSaleExecutive => _leadsPreSalesExectives;
  PaginationModel<PostSaleLead> get leadsPostSaleExecutive =>
      _leadsPostSalesExectives;
  List<SiteVisit> get siteVisits => _siteVisits;
  List<OurProject> get ourProject => _ourProject;
  List<ChannelPartner> get channelPartner => _channelPartner;
  PaginationModel<SiteVisit> get searchSiteVisit => _searchSiteVisit;
  PaginationModel<Lead> get searchLeads => _searchLeads;
  PaginationModel<Lead> get searchLeadsChannelPartner =>
      _searchLeadsChannelPartner;
  List<String> get requirements => _requirements;
  List<Employee> get teamLeaders => _teamLeaders;

  SettingProvider() {
    // getDesignation();
    // getDivision();
    // getDepartment();
    // getEmployess();
    // getCustomer();
    // getClosingManagers();
  }

  Future<void> getDesignation() async {
    final desgs = await _apiService.getDesignation();
    if (desgs.isNotEmpty) {
      _designation = desgs;
      notifyListeners();
    }
  }

  Future<void> getRequirements() async {
    final emps = await _apiService.getReuirements();
    if (emps.isNotEmpty) {
      print("got reqs");
      _requirements = emps;
      notifyListeners();
    }
    notifyListeners();
    print("notified reqs");
  }

  Future<void> getReportingToEmps(String rId) async {
    final emps = await _apiService.getReportingToEmps(rId);
    if (emps.isNotEmpty) {
      _reportingEmps = emps;
      notifyListeners();
    }
  }

  Future<void> getTeamLeaders() async {
    final emps = await _apiService.getTeamLeaders();
    if (emps.isNotEmpty) {
      _teamLeaders = emps;
      notifyListeners();
    }
  }

  Future<void> getTask(String id) async {
    final emps = await _apiService.getTasks(id);

    if (emps.isNotEmpty) {
      _tasks = emps;
      notifyListeners();
    }
  }

  Future<void> updateTaskStatus(String id, String status,
      [String remark = ""]) async {
    await _apiService.updateTask(id, {
      "status": status,
      "remark": remark,
    });
    notifyListeners();
  }

  Future<void> getSeniorClosingManagers() async {
    final emps = await _apiService.getSeniorClosingManagers();
    if (emps.isNotEmpty) {
      _seniorClosingManagers = emps;
      // print(_seniorClosingManagers);
      notifyListeners();
    }
  }

  Future<void> getCarryForwardOpt(String id) async {
    final emps = await _apiService.getCarryForwardOptions(id);
    if (emps.isNotEmpty) {
      _carryForwardsOptions = emps;
      notifyListeners();
    }
  }

  Future<void> getPreSaleExForTL(String teamLeaderId) async {
    final emps = await _apiService.getPreSalesExecutives(teamLeaderId);
    if (emps.isNotEmpty) {
      _preSaleExecutives = emps;
      notifyListeners();
    }
  }

  Future<void> getClosingManagerGraph(String id) async {
    final emps = await _apiService.getClosingManagerGraphLeads(id);
    if (emps == null) {
      notifyListeners();
      return;
    }
    _closingManagerGraph = emps;
    notifyListeners();
  }

  Future<void> getClientMeetingById(String id) async {
    final emps = await _apiService.getClientMeetingById(id);
    if (emps.isNotEmpty) {
      _meeting = emps;
      notifyListeners();
    }
  }

  Future<void> addSiteVisit(Map<String, dynamic> data) async {
    final resp = await _apiService.addSiteVisit(data);
    if (resp == null) return;
    await searchSiteVisits();
    notifyListeners();
  }

  Future<void> updateSiteVisit(String id, Map<String, dynamic> data) async {
    final resp = await _apiService.updateSiteVisit(id, data);
    if (resp == null) return;
    await searchSiteVisits();
    notifyListeners();
  }

  Future<void> getDivision() async {
    final divs = await _apiService.getDivision();
    if (divs.isNotEmpty) {
      _divisions = divs;
      notifyListeners();
    }
  }

  Future<void> getDepartment() async {
    final dps = await _apiService.getDepartment();
    if (dps.isNotEmpty) {
      _departments = dps;
      notifyListeners();
    }
  }

  Future<void> getTeamSections() async {
    final divs = await _apiService.getTeamSections();
    if (divs.isNotEmpty) {
      _teamSections = divs;
      notifyListeners();
    }
  }

  Future<void> getEmployess() async {
    final emps = await _apiService.getAllEmployees();
    if (emps.isNotEmpty) {
      _employees = emps;
      notifyListeners();
    }
  }

  Future<void> getPayment() async {
    final payment = await _apiService.getPayment();
    if (payment.isNotEmpty) {
      _payment = payment;
      notifyListeners();
    }
  }

  Future<void> getMeeetingSummary() async {
    final meeting = await _apiService.getMeetingSummary();
    if (meeting.isNotEmpty) {
      _meeting = meeting;
      notifyListeners();
    }
  }

  Future<void> deleteEmployeeeById(String id) async {
    final resp = await _apiService.deleteEmployeeById(id);
    if (resp == null) return;
    await getEmployess();
    notifyListeners();
  }

  Future<void> getReportingTo(String id) async {
    final resp = await _apiService.getReportingTo(id);
    if (resp == null) return;
    await getEmployess();
    notifyListeners();
  }

  Future<void> addEmployee(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final resp = await _apiService.addEmployee(data);

    if (resp == null) return;

    await getEmployess();
    notifyListeners();

    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> addMeetingSummary(Map<String, dynamic> data) async {
    final resp = await _apiService.addMeetingSummary(data);
    if (resp == null) return;
    await getMeeetingSummary();
    notifyListeners();
  }

  Future<void> getChannelPartners() async {
    final cps = await _apiService.getChannelPartners();
    if (cps.isNotEmpty) {
      _channelPartners = cps;
      notifyListeners();
    }
  }

  Future<void> getCustomer() async {
    final cust = await _apiService.getAllCustomer();
    if (cust.isNotEmpty) {
      _customer = cust;
    }
    notifyListeners();
  }

  Future<void> getOurProject() async {
    final projects = await _apiService.getOurProject();
    if (projects.isNotEmpty) {
      print("got projects");
      _ourProject = projects;
      notifyListeners();
    }
    notifyListeners();
    print("notified projects");
  }

  Future<void> deleteProject(String id) async {
    final resp = await _apiService.deleteProject(id);
    if (resp != null) {
      // Remove the project from the local list
      _ourProject.removeWhere((project) => project.id == id);
      notifyListeners();
    }
  }

  Future<void> getClosingManagers() async {
    final emps = await _apiService.getClosingManagers();
    if (emps.isNotEmpty) {
      _closingManagers = emps;
    }
    notifyListeners();
  }

  Future<void> getSalesManager() async {
    final emps = await _apiService.getSalesManager();
    if (emps.isNotEmpty) {
      _salesManager = emps;
      notifyListeners();
    }
  }

  Future<void> getDataEntryEmployess() async {
    final emps = await _apiService.getDataEntryEmployees();
    if (emps.isNotEmpty) {
      print("got entry emps");

      _dataEntryUsers = emps;
    }
    notifyListeners();
    print("notified entry emps");
  }

  Future<void> getPostSalesEx() async {
    final emps = await _apiService.getPostSalesExecutives();
    if (emps.isNotEmpty) {
      _postSalesExecutives = emps;
      notifyListeners();
    }
  }

  Future<void> addLead(Map<String, dynamic> data) async {
    final resp = await _apiService.addLead(data);
    if (resp == null) return;
    await searchLead();
    notifyListeners();
  }

  Future<void> getEmployeeByDesignation(String desgId) async {
    final emps = await _apiService.getEmployeeByDesignation(desgId);
    if (emps.isNotEmpty) {
      _employeeBydDesg = emps;
      notifyListeners();
    }
  }

  Future<PaginationModel<Lead>> getPreSalesExecutiveLeads(String id) async {
    final leads = await _apiService.getPreSalesExecutivesLeads(id);

    _leadsPreSalesExectives = leads;
    notifyListeners();
    return leads;
  }

  Future<PaginationModel<PostSaleLead>> getPostSalesExecutiveLeads(
    String id, [
    String query = '',
    int page = 1,
    int limit = 10,
  ]) async {
    final leads = await _apiService.getPostSalesExecutivesLeads(
      id,
      query,
      page,
      limit,
    );

    _leadsPostSalesExectives = leads;
    notifyListeners();
    return leads;
  }

  Future<PaginationModel<SiteVisit>> getClosingManagerSiteVisitById(String id,
      [String query = '',
      int page = 1,
      int limit = 10,
      String status = "all"]) async {
    final leads = await _apiService.getClosingManagerSiteVisitById(
      id,
      query,
      page,
      limit,
      status,
    );

    _searchSiteVisit = leads;
    notifyListeners();
    return leads;
  }

  Future<void> getMyTarget(String id) async {
    final targetResp = await _apiService.getMyTarget(id);
    if (targetResp != null) {
      myTarget = targetResp;
    }
    notifyListeners();
  }

  Future<void> updateCarryForward(String id, Map<String, dynamic> data) async {
    final targetResp = await _apiService.useCarryForward(id, data);
    if (targetResp != null) {
      myTarget = targetResp;
    }
    notifyListeners();
  }

// Future<void> getPreSalesExecutiveEmployee(String id) async {
//     final leads = await _apiService.getPreSalesExecutiveEmployee(id);
//     if (leads.isNotEmpty) {
//       _leadsPreSaleExecutive = leads;
//       notifyListeners();
//     }
//   }

  Future<PaginationModel<SiteVisit>> searchSiteVisits([
    String query = '',
    int page = 1,
    int limit = 10,
    String status = 'all',
    String? closingManagerId,
  ]) async {
    if (closingManagerId != null) {
      final visitclosing = await _apiService.getClosingManagerSiteVisitById(
          closingManagerId, query, page, limit, status);
      _searchSiteVisit = visitclosing;
      return visitclosing;
    }
    final visits =
        await _apiService.searchSiteVisits(query, page, limit, status);

    // if (visits) {
    _searchSiteVisit = visits;
    notifyListeners();
    return visits;
    // }
  }

  Future<PaginationModel<Lead>> searchLead([
    String query = '',
    int page = 1,
    int limit = 20,
    String? approvalStatus,
    String? stage,
    String? channelPartner,
  ]) async {
    final leads = await _apiService.searchLeads(
      query,
      page,
      limit,
      approvalStatus,
      stage,
      channelPartner,
    );
    // if (leads) {
    _searchLeads = leads;
    notifyListeners();

    return leads;
    // }
  }

  Future<PaginationModel<Lead>> searchLeadChannelPartner(
    String id, [
    String query = '',
    int page = 1,
    int limit = 20,
    String? approvalStatus,
    String? stage,
 
  ]) async {
    final leads = await _apiService.searchLeadsChannelPartner(
      id,
      query,
      page,
      limit,
      approvalStatus,
      stage,
    );
    // if (leads) {
    _searchLeadsChannelPartner = leads;
    notifyListeners();

    return leads;
    // }
  }

  Future<List<ChartModel>> leadForGraph([
    String interval = 'monthly',
    int? year,
    String? startDate,
    String? endDate,
  ]) async {
    final leads = await _apiService.getLeadsForGraph(
      interval,
      year,
      startDate,
      endDate,
    );
    // if (leads) {
    leadsMonthly = leads;
    notifyListeners();

    return leads;
    // }
  }

  Future<List<ChartModel>> leadsTeamLeaderGraphForDt([
    String interval = 'monthly',
    int? year,
    String? startDate,
    String? endDate,
    int? month,
  ]) async {
    final leads = await _apiService.teamLeaderGraphForDataAnalyser(
      interval,
      year,
      startDate,
      endDate,
      month,
    );
    // if (leads) {
    leadsTeamLeaderGraphForDT = leads;
    notifyListeners();

    return leads;
    // }
  }

  Future<List<ChartModel>> getleadsChannelPartnerGraph([
    String interval = 'monthly',
    int? year,
    String? startDate,
    String? endDate,
    int? month,
  ]) async {
    final leads = await _apiService.leadsChannelPartnerGraph(
      interval,
      year,
      startDate,
      endDate,
      month,
    );
    // if (leads) {
    leadsChannelPartnerGraph = leads;
    notifyListeners();

    return leads;
    // }
  }

  Future<List<ChartModel>> getLeadsFunnelGraph([
    String interval = 'yearly',
    int? year,
    String? startDate,
    String? endDate,
    int? month,
  ]) async {
    final leads = await _apiService.leadFunnelGraph(
      interval,
      year,
      startDate,
      endDate,
      month,
    );
    // if (leads) {
    leadsFunnelGraph = leads;
    notifyListeners();

    return leads;
    // }
  }

  Future<List<ChartModel>> getLeadsTeamLeaderGraph(
    String id, [
    String interval = 'monthly',
    int? year,
    String? startDate,
    String? endDate,
    int? month,
  ]) async {
    final leads = await _apiService.getTeamLeaderLeadsGraph(
      id,
      interval,
      year,
      startDate,
      endDate,
      month,
    );
    // if (leads) {
    leadsTeamLeaderGraph = leads;
    notifyListeners();

    return leads;
    // }
  }

  Future<List<ChartModel>> getLeadsPostSaleGraph(
    String id, [
    String interval = 'monthly',
    int? year,
    String? startDate,
    String? endDate,
    int? month,
  ]) async {
    final leads = await _apiService.getTeamLeaderLeadsGraph(
      id,
      interval,
      year,
      startDate,
      endDate,
      month,
    );
    // if (leads) {
    leadsTeamLeaderGraph = leads;
    notifyListeners();

    return leads;
    // }
  }

  Future<List<ChartModel>> getPreSaleExecutiveGraph([
    String interval = 'yearly',
    int? year,
    String? startDate,
    String? endDate,
    int? month,
  ]) async {
    final leads = await _apiService.getPreSaleExecutivesGraphForTL(
      interval,
      year,
      startDate,
      endDate,
      month,
    );
    // if (leads) {
    leadsPreSaleExecutiveGraphForTL = leads;
    notifyListeners();

    return leads;
    // }
  }

  //get leads
  Future<void> getLeads() async {
    final leads = await _apiService.getLeads();
    if (leads.isNotEmpty) {
      _leads = leads;
      notifyListeners();
    }
  }

  //get leads
  Future<PaginationModel<PostSaleLead>> getPostSaleLead([
    query = "",
    page = 1,
    limit = 10,
  ]) async {
    final leads = await _apiService.getPostSaleLead(
      query,
      page,
      limit,
    );
    // print(leads.data);
    _leadsPostSale = leads;
    notifyListeners();
    return leads;
  }

  //get leads
  Future<PaginationModel<Lead>> getTeamLeaderLeads(
    String id, [
    String query = '',
    int page = 1,
    int limit = 10,
    String? status,
  ]) async {
    final leads = await _apiService.getTeamLeaderLeads(
      id,
      query,
      page,
      limit,
      status,
    );
    _leadsTeamLeader = leads;
    notifyListeners();
    return leads;
  }

  //get leads
  Future<PaginationModel<Lead>> getTeamLeaderReportingToLeads(
    String id, [
    String query = '',
    int page = 1,
    int limit = 10,
    String? status,
  ]) async {
    final leads = await _apiService.getTeamLeaderReportingToLeads(
      id,
      query,
      page,
      limit,
      status,
    );
    _leadsTeamLeaderReportingTo = leads;
    notifyListeners();
    return leads;
  }

  Future<void> updateCallHistoryPreSales(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      Lead? updatedLead = await _apiService.updateCallHistoryPreSales(id, data);
      if (updatedLead != null) {
        await getPreSalesExecutiveLeads(id);

        notifyListeners();
      }
    } catch (e) {
      Helper.showCustomSnackBar('Error updating PreSales Executive lead: $e');
    }
  }

  //get site Visits
  Future<void> getSiteVisits() async {
    final visits = await _apiService.getSiteVisit();
    if (visits.isNotEmpty) {
      _siteVisits = visits;
      notifyListeners();
    }
  }

  Future<void> getChannelPartner() async {
    final partner = await _apiService.getChannelPartner();

    if (partner.isNotEmpty) {
      _channelPartner = partner;
      notifyListeners();
    }
  }

  Future<void> changePasswordChannelPartner(
      String id, String oldPassword, newPassword) async {
    await _apiService.changePasswordCp(
      id,
      oldPassword,
      newPassword,
    );
    notifyListeners();
  }

  Future<void> changePasswordClient(
    String id,
    String oldPassword,
    newPassword,
  ) async {
    await _apiService.changePasswordClient(
      id,
      oldPassword,
      newPassword,
    );
    notifyListeners();
  }

  Future<void> loginAdmin(context, String email, String password) async {
    print("pass 0.1");
    final resp = await _apiService.loginEmployee(
      email,
      password,
    );
    print("pass 0");
    if (resp == null) return;
    print("pass 1");

    loggedAdmin = resp;
    notifyListeners();
    await OneSignal.Notifications.requestPermission(true);
    print("pass 2");

    // final playerId = await OneSignal.User.getOnesignalId();
    String? playerId = OneSignal.User.pushSubscription.id;

    print("pass 3");
    await ApiService().saveOneSignalId(
      resp.id!,
      resp.role!,
      playerId!,
    );
    print("pass 4");

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const AdminLoginSection()),
    // );

    GoRouter.of(context).go("/admin-login-cards");
    print("pass 5");
  }

  void updateLoggedAdmin(Employee emp) {
    loggedAdmin = emp;
    notifyListeners();
  }

  void updateLoggedCustomer(Customer custo) {
    loggedCustomer = custo;
    notifyListeners();
  }

  void updateLoggedChannelParter(ChannelPartner cp) {
    loggedChannelPartner = cp;
    notifyListeners();
  }

  Future<void> loginCustomer(context, String email, String passsword) async {
    final resp = await _apiService.loginCutomer(
      email,
      passsword,
    );
    if (resp == null) return;

    loggedCustomer = resp;
    GoRouter.of(context).go("/customer-home-wrapper");
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const CustomerHomeWrapper()),
    // );
    notifyListeners();
  }

  Future<void> logoutUser(BuildContext context) async {
    try {
      await SharedPrefService.deleteUser();
      await storage.deleteAll();

      loggedCustomer = null;
      loggedAdmin = null;
      loggedChannelPartner = null;
    } catch (e) {
      // Optionally handle the error if needed
      // print("Error during logout: $e");
    } finally {
      if (context.mounted) {
        GoRouter.of(context).go("/first-page");
      }
    }
  }

  Future<void> loginChannelPartner(
      context, String email, String passsword) async {
    final resp = await _apiService.loginChannelPartner(
      email,
      passsword,
    );
    if (resp == null) return;
    loggedChannelPartner = resp;
    GoRouter.of(context).go("/cp-home-wrapper");
    notifyListeners();
  }

  Future<void> updateLeadById(String id, Map<String, dynamic> data) async {
    await _apiService.leadUpdateById(id, data);
    // if (resp == null) return;
    // await leads();
    notifyListeners();
  }

  Future<void> loginPhone(context, int phoneNumber) async {
    final resp = await _apiService.loginPhone(
      phoneNumber,
    );
    if (resp == null) {
      Helper.showCustomSnackBar('Invalid credentials or no response');
      return;
    }
    loggedPhone = resp;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OtpVerificationPage(),
      ),
    );
  }

  Future<void> addDesignation(String designation) async {
    final resp = await _apiService.addDesignation(designation);
    if (resp == null) return;
    await getDesignation();
    notifyListeners();
  }

  Future<PostSaleLead?> addPostSaleLead(Map<String, dynamic> data) async {
    final resp = await _apiService.addPostSaleLead(data);
    // if (resp == null) return null;
    await getPostSaleLead();
    notifyListeners();
    return resp;
  }

  Future<void> updatePostSaleLead(String id, Map<String, dynamic> data) async {
    // print('pass provider start');
    final resp = await _apiService.updatePostSaleLead(id, data);
    // print('pass provider update');
    if (resp == null) return;
    await getPostSaleLead();
    notifyListeners();
  }

  Future<void> editOurProject(String id, Map<String, dynamic> data) async {
    // print('pass provider start');
    final resp = await _apiService.editOurProject(id, data);
    // print('pass provider update');
    if (resp == null) return;
    await getOurProject();
    notifyListeners();
  }

  Future<void> updateDesignation(String id, String designation) async {
    final resp = await _apiService.updateDesignation(id, designation);
    if (resp == null) return;
    await getDesignation();
    notifyListeners();
  }

  Future<void> deleteDesignation(String id) async {
    final resp = await _apiService.deleteDesignation(id);
    if (resp == null) return;
    await getDesignation();
    notifyListeners();
  }

  Future<void> addDepartment(String department) async {
    final resp = await _apiService.addDepartment(department);
    if (resp == null) return;
    await getDepartment();
    notifyListeners();
  }

  Future<void> updateDepartment(String id, String designation) async {
    final resp = await _apiService.updateDepartment(id, designation);
    if (resp == null) return;
    await getDepartment();
    notifyListeners();
  }

  Future<void> deleteDepartment(String id) async {
    final resp = await _apiService.deleteDepartment(id);
    if (resp == null) return;
    await getDepartment();
    notifyListeners();
  }

  Future<void> addDivision(String division) async {
    final resp = await _apiService.addDivision(division);
    if (resp == null) return;
    await getDivision();
    notifyListeners();
  }

  Future<void> addChannelPartner(
      BuildContext context,
      String firstName,
      String lastName,
      String email,
      String gender,
      int phoneNumber,
      String password,
      String dateOfBirth,
      String homeAddress,
      String firmName,
      String firmAdress,
      String reraNumber,
      String reraCertificate) async {
    final resp = await _apiService.addChannelPartner(
      firstName,
      lastName,
      email,
      gender,
      phoneNumber,
      password,
      dateOfBirth,
      homeAddress,
      firmName,
      firmAdress,
      reraNumber,
      reraCertificate,
    );
    if (resp == null) return;
    await getChannelPartner();
    notifyListeners();
    Navigator.pop(context);
  }

  Future<void> addPayment(Map<String, dynamic> data) async {
    final resp = await _apiService.addPayment(data);
    if (resp == null) return;
    await getPayment();
    notifyListeners();
  }

  Future<void> deleteChannelPartner(String id) async {
    final resp = await _apiService.deleteChannelPartner(id);
    if (resp == null) return;
    await getChannelPartner();
    notifyListeners();
  }

  Future<void> addNewProject(OurProject project) async {
    final jsonProject = project.toJson();
    final resp = await _apiService.addNewProjects(jsonProject);
    if (resp == null) return;
    await getOurProject();
    notifyListeners();
  }

  Future<void> updateDivision(String id, String division) async {
    final resp = await _apiService.updateDivision(id, division);
    if (resp == null) return;
    await getDivision();
    notifyListeners();
  }

  Future<void> deleteDivision(String id) async {
    final resp = await _apiService.deleteDivision(id);
    if (resp == null) return;
    await getDivision();
    notifyListeners();
  }

  Future<void> leadApproveAndAssignTL(
    String id,
    String teamLeaderId, [
    String remark = "Approved",
  ]) async {
    await _apiService.leadApproveAndAssignTL(id, teamLeaderId, remark);
    notifyListeners();
  }

  Future<void> leadRejectDataAnalyzer(
    String id, [
    String remark = "rejected",
  ]) async {
    await _apiService.leadRejectByDataAnalyzer(id, remark);
    notifyListeners();
  }

  Future<void> leadAssignToPresaleExcutive(
    String id,
    String assignTo, [
    String remark = "assigned",
  ]) async {
    final resp = await _apiService.leadAssignToPreSaleExecutive(
      id,
      assignTo,
      remark,
    );
    if (resp == null) return;
    // await getTeamLeaderLeads(loggedAdmin!.id!);
    notifyListeners();
  }
}
