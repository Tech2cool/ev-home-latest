import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ev_homes/core/constant/constant.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/attendance.dart';
import 'package:ev_homes/core/models/channel_partner.dart';
import 'package:ev_homes/core/models/chart_model.dart';
import 'package:ev_homes/core/models/closing_manager_graph.dart';
import 'package:ev_homes/core/models/customer.dart';
import 'package:ev_homes/core/models/customer_payment.dart';
import 'package:ev_homes/core/models/department.dart';
import 'package:ev_homes/core/models/designation.dart';
import 'package:ev_homes/core/models/division.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/models/meetingSummary.dart';
import 'package:ev_homes/core/models/otp.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/models/pagination_model.dart';
import 'package:ev_homes/core/models/post_sale_lead.dart';
import 'package:ev_homes/core/models/site_visit.dart';
import 'package:ev_homes/core/models/target_model.dart';
import 'package:ev_homes/core/models/task.dart';
import 'package:ev_homes/core/models/team_section.dart';
import 'package:ev_homes/core/models/upload_file.dart';
import 'package:ev_homes/core/services/shared_pref_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/employee.dart';

const storage = FlutterSecureStorage();

// final dio = Dio();

// const baseUrl = "http://192.168.1.168:8082";
const baseUrl = "https://api.evhomes.tech";

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;

  ApiService._internal() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
    _dio.interceptors.add(_AuthInterceptor());
    _dio.interceptors.add(_ResponseInterceptor());
  }

  CancelToken? loginCancelToken;

  Future<ChannelPartner?> getChannelPartnerById(String id) async {
    try {
      final Response response = await _dio.get('/channel-partner/$id');
      final Map<String, dynamic> data = response.data["data"];
      final ChannelPartner channelPartner = ChannelPartner.fromMap(data);

      return channelPartner;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';
      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  // Future<List<MeetingSummary>> getClientMeetingById(String id) async {
  //   try {
  //     final Response response = await _dio.get('/meeting-client-id/$id');
  //     final Map<String, dynamic> data = response.data["data"];
  //     final MeetingSummary meeting = MeetingSummary.fromMap(data);
  //     return meeting[];
  //   } on DioException catch (e) {
  //     String errorMessage = 'Something went wrong';
  //     print("pass1");
  //     if (e.response != null) {
  //       errorMessage = e.response?.data['message'] ?? errorMessage;
  //     } else {
  //       errorMessage = e.message.toString();
  //     }print("pass2");
  //     Helper.showCustomSnackBar(errorMessage);
  //     return null;
  //   }
  // }

  Future<List<MeetingSummary>> getClientMeetingById(String id) async {
    try {
      final Response response = await _dio.get(
        '/meeting-client-id/$id',
      );
      // print("yes 1");
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }

      // print("yes 2");
      final List<dynamic> dataList = response.data["data"];

      // print("yes 3");
      final List<MeetingSummary> meeting = dataList.map((data) {
        return MeetingSummary.fromMap(data);
      }).toList();
      return meeting;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<PaginationModel<Lead>> searchLeads([
    String query = '',
    int page = 1,
    int limit = 20,
    String? approvalStatus,
    String? stage,
    String? channelPartner,
  ]) async {
    try {
      var url = '/search-lead?query=$query&page=$page&limit=$limit';
      if (approvalStatus != null) {
        url += '&approvalStatus=$approvalStatus';
      }
      if (stage != null) {
        url += '&stage=$stage';
      }
      if (channelPartner != null) {
        url += '&channelPartner=$channelPartner';
      }

      final Response response = await _dio.get(url);
      final Map<String, dynamic> data = response.data;
      if (response.data["code"] != 200) {
        final emptyPagination = PaginationModel<Lead>(
          code: 404,
          message: '',
          page: page,
          limit: limit,
          totalPages: 1,
          totalItems: 0,
          data: [],
        );

        return emptyPagination;
      }
      final items = data['data'] as List<dynamic>? ?? [];

      List<Lead> leads = [];
      if (items.isNotEmpty) {
        leads = items.map((emp) => Lead.fromJson(emp)).toList();
      }
      final newPagination = PaginationModel<Lead>(
        code: data['code'],
        message: data['message'],
        page: data['page'],
        limit: data['limit'],
        totalPages: data['totalPages'],
        totalItems: data['totalItems'],
        pendingCount: response.data["pendingCount"],
        approvedCount: response.data["approvedCount"],
        rejectedCount: response.data["rejectedCount"],
        // assignedCount: response.data["assignedCount"],
        data: leads,
      );

      return newPagination;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      final emptyPagination = PaginationModel<Lead>(
        code: 404,
        message: '',
        page: page,
        limit: limit,
        totalPages: 1,
        totalItems: 0,
        data: [],
      );
      return emptyPagination;
    }
  }

  Future<PaginationModel<Lead>> searchLeadsChannelPartner(
    String id, [
    String query = '',
    int page = 1,
    int limit = 20,
    String? approvalStatus,
    String? stage,
  ]) async {
    try {
      var url =
          '/search-lead-channel-partner/$id?query=$query&page=$page&limit=$limit';
      if (approvalStatus != null) {
        url += '&approvalStatus=$approvalStatus';
      }
      // print("pass1");
      if (stage != null) {
        url += '&stage=$stage';
      }
      // print(url);
      // print("pass2");
      final Response response = await _dio.get(url);

      print(response.data);
      if (response.data["code"] != 200) {
        final emptyPagination = PaginationModel<Lead>(
          code: 404,
          message: '',
          page: page,
          limit: limit,
          totalPages: 1,
          totalItems: 0,
          data: [],
        );

        print("pass3");

        return emptyPagination;
      }
      // print(response.data['data']);
      final items = response.data['data'] as List<dynamic>;
      // print("pass4");
      List<Lead> leads = [];
      if (items.isNotEmpty) {
        // print("yes");
        leads = items.map((emp) => Lead.fromJson(emp)).toList();
        // print("whj");
      }
      final newPagination = PaginationModel<Lead>(
        code: response.data['code'],
        message: response.data['message'],
        page: response.data['page'],
        limit: response.data['limit'],
        totalPages: response.data['totalPages'],
        totalItems: response.data['totalItems'],
        pendingCount: response.data["pendingCount"],
        approvedCount: response.data["approvedCount"],
        rejectedCount: response.data["rejectedCount"],
        // assignedCount: response.data["assignedCount"],
        data: leads,
      );

      // print("pass5");
      return newPagination;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      // print("pass6");
      Helper.showCustomSnackBar(errorMessage);
      final emptyPagination = PaginationModel<Lead>(
        code: 404,
        message: '',
        page: page,
        limit: limit,
        totalPages: 1,
        totalItems: 0,
        data: [],
      );
      return emptyPagination;
    }
  }

  Future<List<Lead>> getLeadsForExport(Map<String, dynamic> datas) async {
    try {
      final Response response = await _dio.post(
        '/lead-by-start-end-date',
        data: datas,
      );
      final Map<String, dynamic> data = response.data;
      if (response.data["code"] != 200) {
        return [];
      }
      final items = data['data'] as List<dynamic>? ?? [];

      List<Lead> leads = [];
      if (items.isNotEmpty) {
        leads = items.map((emp) => Lead.fromJson(emp)).toList();
      }

      return leads;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }
      print(e);
      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<List<ChartModel>> getLeadsForGraph([
    String interval = 'monthly',
    int? year,
    String? startDate,
    String? endDate,
  ]) async {
    try {
      var url = '/lead-count?interval=$interval';
      if (year != null) {
        url += '&year=$year';
      }

      if (startDate != null) {
        url += '&startDate=$startDate';
      }

      if (endDate != null) {
        url += '&endDate=$endDate';
      }

      final Response response = await _dio.get(url);

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final List<dynamic> dataList = response.data['data'];
      final List<ChartModel> datas = dataList.map((data) {
        return ChartModel(
          category: data['month'],
          value: double.parse(data['count'].toString()),
        );
      }).toList();

      return datas;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return [];
    }
  }

  Future<List<ChartModel>> teamLeaderGraphForDataAnalyser([
    String interval = 'monthly',
    int? year,
    String? startDate,
    String? endDate,
    int? month,
  ]) async {
    try {
      var url =
          '/lead-count-pre-sale-team-leader-for-data-analyser?interval=$interval';
      if (year != null) {
        url += '&year=$year';
      }
      if (month != null) {
        url += '&month=$month';
      }

      if (startDate != null) {
        url += '&startDate=$startDate';
      }

      if (endDate != null) {
        url += '&endDate=$endDate';
      }

      final Response response = await _dio.get(url);

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final List<dynamic> dataList = response.data['data'];
      final List<ChartModel> datas = dataList.map((data) {
        return ChartModel(
          category: data['teamLeader'],
          value: double.parse(data['count'].toString()),
        );
      }).toList();

      return datas;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return [];
    }
  }

  Future<List<ChartModel>> leadsChannelPartnerGraph([
    String interval = 'monthly',
    int? year,
    String? startDate,
    String? endDate,
    int? month,
  ]) async {
    try {
      var url = '/lead-count-channel-partners?interval=$interval';
      if (year != null) {
        url += '&year=$year';
      }
      if (month != null) {
        url += '&month=$month';
      }

      if (startDate != null) {
        url += '&startDate=$startDate';
      }

      if (endDate != null) {
        url += '&endDate=$endDate';
      }

      final Response response = await _dio.get(url);

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final List<dynamic> dataList = response.data['data'];
      final List<ChartModel> datas = dataList.map((data) {
        return ChartModel(
          category: data['channelPartner'],
          value: double.parse(data['count'].toString()),
        );
      }).toList();

      return datas;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return [];
    }
  }

  Future<List<ChartModel>> leadFunnelGraph([
    String interval = 'yearly',
    int? year,
    String? startDate,
    String? endDate,
    int? month,
  ]) async {
    try {
      var url = '/lead-count-funnel?interval=$interval';
      if (year != null) {
        url += '&year=$year';
      }
      if (month != null) {
        url += '&month=$month';
      }

      if (startDate != null) {
        url += '&startDate=$startDate';
      }

      if (endDate != null) {
        url += '&endDate=$endDate';
      }

      final Response response = await _dio.get(url);

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final List<dynamic> dataList = response.data['data'];
      final List<ChartModel> datas = dataList.map((data) {
        return ChartModel(
          category: data['status'],
          value: double.parse(data['count'].toString()),
        );
      }).toList();

      return datas;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return [];
    }
  }

  // team leaders graph
  Future<List<ChartModel>> getTeamLeaderLeadsGraph(
    String id, [
    String interval = 'monthly',
    int? year,
    String? startDate,
    String? endDate,
    int? month,
  ]) async {
    try {
      var url = '/lead-count-pre-sale-team-leader/$id?interval=$interval';
      if (year != null) {
        url += '&year=$year';
      }
      if (month != null) {
        url += '&month=$month';
      }

      if (startDate != null) {
        url += '&startDate=$startDate';
      }

      if (endDate != null) {
        url += '&endDate=$endDate';
      }

      final Response response = await _dio.get(url);

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final List<dynamic> dataList = response.data['data'];
      final List<ChartModel> datas = dataList.map((data) {
        return ChartModel(
          category: data['month'],
          value: double.parse(data['count'].toString()),
        );
      }).toList();

      return datas;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return [];
    }
  }

  Future<List<ChartModel>> getleadsChannelPartnerGraphById(
    String id, [
    String interval = 'monthly',
    int? year,
    String? startDate,
    String? endDate,
    int? month,
  ]) async {
    print("yes");
    try {
      var url = '/lead-count-channel-partners-id/$id?interval=$interval';
      if (year != null) {
        url += '&year=$year';
      }
      if (month != null) {
        url += '&month=$month';
      }

      if (startDate != null) {
        url += '&startDate=$startDate';
      }

      if (endDate != null) {
        url += '&endDate=$endDate';
      }
      print("pass1");
      final Response response = await _dio.get(url);

      print(response.data);
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final List<dynamic> dataList = response.data['data'];
      final List<ChartModel> datas = dataList.map((data) {
        return ChartModel(
          category: data['month'],
          value: double.parse(data['count'].toString()),
        );
      }).toList();

      print("pass2");
      return datas;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      print("pass3");
      Helper.showCustomSnackBar(errorMessage);

      return [];
    }
  }

  Future<List<ChartModel>> getPreSaleExecutivesGraphForTL([
    String interval = 'yearly',
    int? year,
    String? startDate,
    String? endDate,
    int? month,
  ]) async {
    try {
      var url =
          '/lead-count-pre-sale-executive-for-pre-sale-tl?interval=$interval';
      if (year != null) {
        url += '&year=$year';
      }
      if (month != null) {
        url += '&month=$month';
      }

      if (startDate != null) {
        url += '&startDate=$startDate';
      }

      if (endDate != null) {
        url += '&endDate=$endDate';
      }

      final Response response = await _dio.get(url);

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final List<dynamic> dataList = response.data['data'];
      final List<ChartModel> datas = dataList.map((data) {
        return ChartModel(
          category: data['preSalesExecutive'],
          value: double.parse(data['count'].toString()),
        );
      }).toList();

      return datas;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return [];
    }
  }

  Future<List<ChartModel>> getLeadsFunnelForTLGraph([
    String interval = 'yearly',
    int? year,
    String? startDate,
    String? endDate,
    int? month,
  ]) async {
    try {
      var url = '/lead-count-funnel-pre-sales-tl?interval=$interval';
      if (year != null) {
        url += '&year=$year';
      }
      if (month != null) {
        url += '&month=$month';
      }

      if (startDate != null) {
        url += '&startDate=$startDate';
      }

      if (endDate != null) {
        url += '&endDate=$endDate';
      }

      final Response response = await _dio.get(url);

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final List<dynamic> dataList = response.data['data'];
      final List<ChartModel> datas = dataList.map((data) {
        return ChartModel(
          category: data['status'],
          value: double.parse(data['count'].toString()),
        );
      }).toList();

      return datas;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return [];
    }
  }

  Future<ClosingManagerGraph?> getClosingManagerGraphLeads(String id) async {
    try {
      var url = '/leads-team-leader-graph/$id';
      final Response response = await _dio.get(url);

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      final data = response.data['data'];
      final parsedData = ClosingManagerGraph.fromMap(data);
      return parsedData;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return null;
    }
  }

  Future<List<ChannelPartner>> getChannelPartners() async {
    try {
      final Response response = await _dio.get('/channel-partner');
      final Map<String, dynamic> data = response.data;
      final items = data['data'] as List<dynamic>? ?? [];

      List<ChannelPartner>? cpItems;
      if (items.isNotEmpty) {
        cpItems = items.map((cp) => ChannelPartner.fromMap(cp)).toList();
      }

      return cpItems ?? [];
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<List<Payment>> getPayment() async {
    try {
      final Response response = await _dio.get('/payment');
      final Map<String, dynamic> data = response.data;
      final items = data['data'] as List<dynamic>? ?? [];

      List<Payment>? payItems;
      if (items.isNotEmpty) {
        payItems = items.map((cp) => Payment.fromMap(cp)).toList();
      }
      return payItems ?? [];
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<List<Task>> getTasks(String id) async {
    try {
      final Response response = await _dio.get('/task/$id');
      final Map<String, dynamic> data = response.data;
      final items = data['data'] as List<dynamic>? ?? [];

      List<Task> payItems = [];
      if (items.isNotEmpty) {
        payItems = items.map((cp) => Task.fromMap(cp)).toList();
      }
      return payItems;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<Lead?> addLead(Map<String, dynamic> data) async {
    try {
      print('pass 1');
      final Response response = await _dio.post(
        '/leads-add',
        data: data,
      );
      print('pass 2');
      if (response.data['code'] != 200) {
        print(response.data['message']);
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      print('pass 3');
      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      final paresedLead = Lead.fromJson(response.data['data']);
      print('pass 4');
      return paresedLead;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      print(e);

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<Payment?> getPaymentbyFlat(String flatNo) async {
    try {
      final Response response =
          await _dio.get('/get-payment-by-flat?flatNo=$flatNo');
      final Map<String, dynamic> data = response.data;
      final items = data['data'];

      return Payment.fromMap(items);
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      print(e);

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<PostSaleLead?> getPostSaleLeadByFlat(String unitNo) async {
    try {
      final Response response =
          await _dio.get('/post-sale-lead-by-flat?unitNo=$unitNo');
      final Map<String, dynamic> data = response.data;
      final items = data['data'];

      return PostSaleLead.fromJson(items);
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<PostSaleLead?> getBookingByFlat(String flatNo) async {
    try {
      final Response response = await _dio.get('/post-sale-lead-by-id/$flatNo');
      final Map<String, dynamic> data = response.data;
      final items = data['data'];

      return PostSaleLead.fromJson(items);
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  // Search channel partner by query
  Future<PaginationModel<ChannelPartner>?> searchChannelPartner(
      [String query = '', int page = 1, int limit = 10]) async {
    try {
      final Response response = await _dio.get('/search-channel-partner');
      final Map<String, dynamic> data = response.data;
      final items = data['items'] as List<dynamic>? ?? [];
      List<ChannelPartner>? cpItems;
      if (items.isNotEmpty) {
        cpItems = items.map((cp) => ChannelPartner.fromMap(cp)).toList();
      }
      final newPagination = PaginationModel<ChannelPartner>(
        code: data['code'],
        message: data['message'],
        page: data['page'],
        limit: data['limit'],
        totalPages: data['totalPages'],
        totalItems: data['totalItems'],
        data: cpItems!,
      );

      return newPagination;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<Employee?> getEmployeesById(String id) async {
    try {
      final Response response = await _dio.get('/employee/$id');

      final Map<String, dynamic> data = response.data["data"];
      final Employee employee = Employee.fromMap(data);
      return employee;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<Employee?> getReportingTo(String id) async {
    try {
      final Response response = await _dio.get('/employee-reporting/$id');
      final Map<String, dynamic> data = response.data["data"];
      final Employee employee = Employee.fromMap(data);
      return employee;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';
      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<String?> deleteEmployeeById(String id) async {
    try {
      final Response response = await _dio.delete('/employee/$id');

      Helper.showCustomSnackBar(response.data['message'], Colors.green);

      return response.data['message'];
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<PaginationModel<Employee>?> searchEmployee(
      [String query = '', int page = 1, int limit = 10]) async {
    try {
      final Response response = await _dio.get('/search-employee');
      final Map<String, dynamic> data = response.data;
      final items = data['items'] as List<dynamic>? ?? [];

      List<Employee>? empItems;
      if (items.isNotEmpty) {
        empItems = items.map((emp) => Employee.fromMap(emp)).toList();
      }
      final newPagination = PaginationModel<Employee>(
        code: data['code'],
        message: data['message'],
        page: data['page'],
        limit: data['limit'],
        totalPages: data['totalPages'],
        totalItems: data['totalItems'],
        data: empItems ?? [],
      );

      return newPagination;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<List<Employee>> getAllEmployees() async {
    try {
      final Response response = await _dio.get('/employee');
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final Map<String, dynamic> data = response.data;
      final items = data['data'] as List<dynamic>? ?? [];

      List<Employee> empItems = [];
      if (items.isNotEmpty) {
        empItems = items.map((emp) => Employee.fromMap(emp)).toList();
      }
      return empItems;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<List<Customer>> getAllCustomer() async {
    try {
      final Response response = await _dio.get('/client');
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final Map<String, dynamic> data = response.data;
      final items = data['data'] as List<dynamic>? ?? [];

      List<Customer> custItems = [];
      if (items.isNotEmpty) {
        custItems = items.map((emp) => Customer.fromMap(emp)).toList();
      }
      return custItems;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<List<Employee>> getClosingManagers() async {
    try {
      final Response response = await _dio.get('/employee-closing-manager');
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final Map<String, dynamic> data = response.data;
      final items = data['data'] as List<dynamic>? ?? [];
      List<Employee> empItems = [];
      if (items.isNotEmpty) {
        empItems = items.map((emp) => Employee.fromMap(emp)).toList();
      }

      return empItems;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<List<Employee>> getDataEntryEmployees() async {
    try {
      final Response response = await _dio.get('/employee-visit-allowed-staff');
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final Map<String, dynamic> data = response.data;
      final items = data['data'] as List<dynamic>? ?? [];
      List<Employee> empItems = [];
      if (items.isNotEmpty) {
        empItems = items.map((emp) => Employee.fromMap(emp)).toList();
      }

      return empItems;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<List<Employee>> getPostSalesExecutives() async {
    try {
      final Response response = await _dio.get(
        '/employee-post-sales-executive',
      );

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final Map<String, dynamic> data = response.data;
      final items = data['data'] as List<dynamic>? ?? [];
      List<Employee> empItems = [];
      if (items.isNotEmpty) {
        empItems = items.map((emp) => Employee.fromMap(emp)).toList();
      }

      return empItems;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<List<Employee>> getEmployeeByDesignation(String id) async {
    try {
      final Response response = await _dio.get('/employee-by-designation/$id');

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final Map<String, dynamic> data = response.data;
      final items = data['data'] as List<dynamic>? ?? [];
      List<Employee> empItems = [];
      if (items.isNotEmpty) {
        empItems = items.map((emp) => Employee.fromMap(emp)).toList();
      }

      return empItems;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<List<ChannelPartner>> getChannelPartner() async {
    try {
      final Response response = await _dio.get('/channel-partner');
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);

        return [];
      }
      final Map<String, dynamic> data = response.data;
      final items = data['data'] as List<dynamic>? ?? [];

      List<ChannelPartner> chItems = [];
      if (items.isNotEmpty) {
        chItems = items.map((emp) => ChannelPartner.fromMap(emp)).toList();
      }
      // Helper.showCustomSnackBar(response.data['message'], Colors.green);

      return chItems;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<Employee?> loginEmployee(String email, String password) async {
    try {
      loginCancelToken?.cancel("duplicate request cancelled");
      loginCancelToken = CancelToken();
      final Response response = await _dio.post(
        '/employee-login',
        data: {
          'email': email,
          'password': password,
        },
        cancelToken: loginCancelToken,
      );

      if (response.data['code'] != 200 && response.data['data'] == null) {
        Helper.showCustomSnackBar(response.data['message']);

        return null;
      }

      await storage.write(
        key: "accessToken",
        value: response.data['accessToken'],
      );
      await storage.write(
        key: "refreshToken",
        value: response.data['refreshToken'],
      );
      await SharedPrefService.storeUser(
        SharedPrefService.key,
        response.data['data'],
      );

      final user = Employee.fromMap(response.data['data']);
      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      return user;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<Employee?> addEmployee(Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(
        '/employee-register',
        data: data,
        // cancelToken: loginCancelToken,
      );

      if (response.data['code'] != 200 && response.data['data'] == null) {
        Helper.showCustomSnackBar(response.data['message']);

        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      return null;

      //
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<Employee?> updateEmployee(String id, Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(
        '/employee-edit/$id',
        data: data,
        // cancelToken: loginCancelToken,
      );

      if (response.data['code'] != 200 && response.data['data'] == null) {
        Helper.showCustomSnackBar(response.data['message']);

        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      return null;

      //
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<ChannelPartner?> updateChannelPartner(
      String id, Map<String, dynamic> data) async {
    try {
      // loginCancelToken?.cancel("duplicate request cancelled");
      // loginCancelToken = CancelToken();
      final Response response = await _dio.post(
        '/channel-partner-edit/$id',
        data: data,
        // cancelToken: loginCancelToken,
      );

      if (response.data['code'] != 200 && response.data['data'] == null) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      return null;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<Lead?> updateCallHistoryPreSales(
      String id, Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(
        '/lead-update-caller/$id',
        data: data,
      );

      // Check for a successful response
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }

      Helper.showCustomSnackBar(response.data['message'], Colors.green);

      // Parse the JSON data into a Lead object
      final updatedLead = Lead.fromJson(response.data['data']);
      return updatedLead;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<ChannelPartner?> changePasswordCp(
      String id, String oldPassword, String newPassword) async {
    final Response response = await _dio.post('/channel-partner-pw/$id', data: {
      "password": oldPassword,
      "newPassword": newPassword,
    });
    if (response.data['code'] != 200) {
      Helper.showCustomSnackBar(response.data['message']);
      return null;
    }
    Helper.showCustomSnackBar(response.data['message'], Colors.green);

    return ChannelPartner.fromMap(response.data['data']);
  }

  Future<Customer?> changePasswordClient(
      String id, String oldPassword, String newPassword) async {
    final Response response =
        await _dio.post('/client-new-password/$id', data: {
      "password": oldPassword,
      "newPassword": newPassword,
    });
    if (response.data['code'] != 200) {
      Helper.showCustomSnackBar(response.data['message']);
      return null;
    }
    Helper.showCustomSnackBar(response.data['message'], Colors.green);

    return Customer.fromMap(response.data['data']);
  }

  Future<ChannelPartner?> loginChannelPartner(
      String email, String password) async {
    try {
      loginCancelToken?.cancel("duplicate request cancelled");
      loginCancelToken = CancelToken();
      final Response response = await _dio.post(
        '/channel-partner-login',
        data: {
          'email': email,
          'password': password,
        },
        cancelToken: loginCancelToken,
      );
      if (response.data['code'] != 200 && response.data['data'] == null) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      await storage.write(
          key: "accessToken", value: response.data['accessToken']);
      await storage.write(
          key: "refreshToken", value: response.data['refreshToken']);
      await SharedPrefService.storeUser(
        SharedPrefService.key,
        response.data['data'],
      );

      final user = ChannelPartner.fromMap(response.data['data']);

      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      return user;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<ChannelPartner?> addChannelPartner(
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
    String reraCertificate,
  ) async {
    final Response response = await _dio.post(
      '/channel-partner-register',
      data: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "gender": gender,
        "phoneNumber": phoneNumber,
        "dateOfBirth": dateOfBirth,
        "homeAddress": homeAddress,
        "firmName": firmName,
        "firmAddress": firmAdress,
        "reraNumber": reraNumber,
        "reraCertificate": reraCertificate,
      },
    );
    if (response.data['code'] != 200) {
      Helper.showCustomSnackBar(response.data['message']);
      return null;
    }
    Helper.showCustomSnackBar(response.data['message'], Colors.green);
    // return null;
    return ChannelPartner.fromMap(response.data['data']);
  }

  Future<Customer?> loginCutomer(String email, String password) async {
    try {
      loginCancelToken?.cancel("duplicate request cancelled");
      loginCancelToken = CancelToken();
      final Response response = await _dio.post(
        '/client-login',
        data: {
          'email': email,
          'password': password,
        },
        cancelToken: loginCancelToken,
      );
      if (response.data['code'] != 200 && response.data['data'] == null) {
        Helper.showCustomSnackBar(response.data['message']);

        return null;
      }
      await storage.write(
          key: "accessToken", value: response.data['accessToken']);
      await storage.write(
          key: "refreshToken", value: response.data['refreshToken']);
      await SharedPrefService.storeUser(
          SharedPrefService.key, response.data['data']);
      final user = Customer.fromMap(
        response.data['data'],
      );
      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      return user;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<Customer?> loginPhone(int phoneNumber) async {
    try {
      loginCancelToken?.cancel("duplicate request cancelled");
      loginCancelToken = CancelToken();
      final Response response = await _dio.post(
        '/client-phoneLogin',
        data: {
          'phoneNumber': phoneNumber,
        },
        cancelToken: loginCancelToken,
      );
      if (response.data['code'] != 200 && response.data['data'] == null) {
        Helper.showCustomSnackBar(response.data['message']);

        return null;
      }

      await storage.write(
          key: "accessToken", value: response.data['accessToken']);
      await storage.write(
          key: "refreshToken", value: response.data['refreshToken']);
      await SharedPrefService.storeUser(
          SharedPrefService.key, response.data['data']);
      final user = Customer.fromMap(response.data['data']);

      Helper.showCustomSnackBar(response.data['message'], Colors.green);

      return user;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<String> leadUpdateById(String id, Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(
        '/lead-update/$id',
        data: data,
      );
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return response.data['message'];
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);

      return response.data['message'];
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return errorMessage;
    }
  }

  // designation
  Future<List<Designation>> getDesignation() async {
    try {
      final Response response = await _dio.get('/designation');
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final List<dynamic> dataList = response.data["data"];
      final List<Designation> designations = dataList.map((data) {
        return Designation.fromMap(data as Map<String, dynamic>);
      }).toList();
      return designations;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<Designation?> addDesignation(String designation) async {
    final Response response = await _dio.post(
      '/designation-add',
      data: {
        "designation": designation,
      },
    );
    if (response.data['code'] != 200) {
      Helper.showCustomSnackBar(response.data['message']);
      return null;
    }
    Helper.showCustomSnackBar(response.data['message'], Colors.green);
    // return null;
    return Designation.fromMap(response.data['data']);
  }

  Future<Designation?> updateDesignation(String id, String designation) async {
    final Response response = await _dio.post('/designation-update/$id', data: {
      "designation": designation,
    });
    if (response.data['code'] != 200) {
      Helper.showCustomSnackBar(response.data['message']);
      return null;
    }
    Helper.showCustomSnackBar(response.data['message'], Colors.green);

    return Designation.fromMap(response.data['data']);
  }

  Future<String?> deleteDesignation(String id) async {
    final Response response = await _dio.delete('/designation/$id');

    if (response.data['code'] != 200) {
      Helper.showCustomSnackBar(response.data['message']);
      return null;
    }
    Helper.showCustomSnackBar(response.data['message'], Colors.green);

    return response.data['message'];
  }

  Future<String?> deleteChannelPartner(String id) async {
    final Response response = await _dio.delete('/channel-partner/$id');

    if (response.data['code'] != 200) {
      Helper.showCustomSnackBar(response.data['message']);
      return null;
    }
    Helper.showCustomSnackBar(response.data['message'], Colors.green);

    return response.data['message'];
  }

  //department
  Future<List<Department>> getDepartment() async {
    try {
      final Response response = await _dio.get('/department');
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final List<dynamic> dataList = response.data["data"];

      final List<Department> departments = dataList.map((data) {
        return Department.fromMap(data as Map<String, dynamic>);
      }).toList();
      return departments;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<List<MeetingSummary>> getMeetingSummary() async {
    try {
      final Response response = await _dio.get('/meeting');
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }

      print("pass 1");
      final List<dynamic> dataList = response.data["data"];
      print(response.data);
      final meeting = dataList.map((data) {
        return MeetingSummary.fromMap(data);
      }).toList();
      print("pass 3");
      return meeting;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      print("pass 2");
      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<MeetingSummary?> addMeetingSummary(Map<String, dynamic> data) async {
    final Response response = await _dio.post(
      '/meeting-add',
      data: data,
    );
    // print(response);
    print("pass1");
    if (response.data['code'] != 200) {
      print(response.data['message']);
      Helper.showCustomSnackBar(response.data['message']);
      return null;
    }
    print(response.data);
    print("pass2");
    Helper.showCustomSnackBar(response.data['message'], Colors.green);
    // return null;
    return MeetingSummary.fromMap(response.data['data']);
  }

  Future<Department?> addDepartment(String department) async {
    final Response response = await _dio.post(
      '/department-add',
      data: {
        "department": department,
      },
    );
    if (response.data['code'] != 200) {
      Helper.showCustomSnackBar(response.data['message']);
      return null;
    }
    Helper.showCustomSnackBar(response.data['message'], Colors.green);

    return Department.fromMap(response.data['data']);
  }

  Future<Department?> updateDepartment(String id, String department) async {
    final Response response = await _dio.post(
      '/department-update/$id',
      data: {
        "department": department,
      },
    );
    if (response.data['code'] != 200) {
      Helper.showCustomSnackBar(response.data['message']);
      return null;
    }
    Helper.showCustomSnackBar(response.data['message'], Colors.green);

    return Department.fromMap(response.data['data']);
  }

  Future<String?> deleteDepartment(String id) async {
    final Response response = await _dio.delete('/department/$id');

    if (response.data['code'] != 200) {
      Helper.showCustomSnackBar(response.data['message']);
      return null;
    }
    Helper.showCustomSnackBar(response.data['message'], Colors.green);

    return response.data['message'];
  }

  // division
  Future<List<Division>> getDivision() async {
    try {
      final Response response = await _dio.get('/division');
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final List<dynamic> dataList = response.data["data"];
      final List<Division> divisions = dataList.map((data) {
        return Division.fromMap(data as Map<String, dynamic>);
      }).toList();

      return divisions;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return [];
    }
  }

  Future<Division?> addDivision(String division) async {
    final Response response = await _dio.post(
      '/division-add',
      data: {
        "division": division,
      },
    );
    if (response.data['code'] != 200) {
      Helper.showCustomSnackBar(response.data['message']);
      return null;
    }
    Helper.showCustomSnackBar(response.data['message'], Colors.green);
    return Division.fromMap(response.data['data']);
  }

  Future<Division?> updateDivision(String id, String division) async {
    final Response response = await _dio.post(
      '/division-update/$id',
      data: {
        "division": division,
      },
    );
    if (response.data['code'] != 200) {
      Helper.showCustomSnackBar(response.data['message']);
      return null;
    }
    Helper.showCustomSnackBar(response.data['message'], Colors.green);

    return Division.fromMap(response.data['data']);
  }

  Future<OurProject?> addNewProjects(Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(
        '/ourProjects-add',
        data: data,
      );
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      return OurProject.fromJson(response.data['data']);
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return null;
    }
  }

  Future<Payment?> addPayment(Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(
        '/payment-add',
        data: data,
      );
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      return Payment.fromMap(response.data['data']);
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';
      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<String?> deleteDivision(String id) async {
    final Response response = await _dio.delete('/division/$id');

    if (response.data['code'] != 200) {
      Helper.showCustomSnackBar(response.data['message']);
      return null;
    }
    Helper.showCustomSnackBar(response.data['message'], Colors.green);

    return response.data['message'];
  }

  // SiteVisits
  Future<List<SiteVisit>> getSiteVisit() async {
    try {
      final Response response = await _dio.get('/siteVisit');

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final List<dynamic> dataList = response.data["data"];
      final List<SiteVisit> siteVisits = dataList.map((data) {
        return SiteVisit.fromMap(data as Map<String, dynamic>);
      }).toList();
      return siteVisits;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  // Leads
  Future<List<Lead>> getLeads() async {
    try {
      final Response response = await _dio.get('/leads');

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }

      final List<dynamic> dataList = response.data["data"];

      final List<Lead> leads = dataList.map((data) {
        return Lead.fromJson(data as Map<String, dynamic>);
      }).toList();

      return leads;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return [];
    }
  }

  // Leads
  Future<PaginationModel<PostSaleLead>> getPostSaleLead([
    String query = '',
    int page = 1,
    int limit = 10,
  ]) async {
    try {
      var url = '/post-sale-leads?query=$query&page=$page&limit=$limit';

      final Response response = await _dio.get(url);

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        final emptyPagination = PaginationModel<PostSaleLead>(
          code: 404,
          message: '',
          page: 1,
          limit: 0,
          totalPages: 1,
          totalItems: 0,
          data: [],
        );

        return emptyPagination;
      }

      final List<dynamic> dataList = response.data["data"];
      final List<PostSaleLead> leads = dataList.map((data) {
        return PostSaleLead.fromJson(data as Map<String, dynamic>);
      }).toList();

      return PaginationModel<PostSaleLead>(
        code: response.data['code'],
        message: response.data['message'],
        page: response.data['page'],
        limit: response.data['limit'],
        totalPages: response.data['totalPages'],
        totalItems: response.data['totalItems'],
        registrationDone: response.data['registrationDone'],
        eoiRecieved: response.data['eoiRecieved'],
        cancelled: response.data['cancelled'],
        data: leads,
      );
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return PaginationModel<PostSaleLead>(
        code: 500,
        message: '',
        page: 1,
        limit: 0,
        totalPages: 1,
        totalItems: 0,
        data: [],
      );
    }
  }

  Future<List<Employee>> getSalesManager() async {
    try {
      final Response response = await _dio.get('/employee-sales-manager');
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }

      final Map<String, dynamic> data = response.data;
      final items = data['data'] as List<dynamic>? ?? [];
      List<Employee> empItems = [];
      if (items.isNotEmpty) {
        empItems = items.map((emp) => Employee.fromMap(emp)).toList();
      }

      return empItems;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<PostSaleLead?> addPostSaleLead(Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(
        '/post-sale-lead-add',
        data: data,
      );

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }

      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      final paresdData = PostSaleLead.fromJson(response.data['data']);

      return paresdData;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return null;
    }
  }

  Future<String?> updateLeadStatus(String id, Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(
        '/lead-update-status/$id',
        data: data,
      );

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }

      Helper.showCustomSnackBar(response.data['message'], Colors.green);

      return response.data['message'];
      // return null;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return null;
    }
  }

  Future<PostSaleLead?> updatePostSaleLead(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final Response response = await _dio.post(
        '/post-sale-lead-update/$id',
        data: data,
      );
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      return PostSaleLead.fromJson(response.data['data']);
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return null;
    }
  }

  Future<OurProject?> editOurProject(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final Response response = await _dio.post(
        '/ourProjects-update/$id',
        data: data,
      );
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      return OurProject.fromJson(response.data['data']);
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return null;
    }
  }

  Future<Target?> useCarryForward(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final Response response = await _dio.post(
        '/use-carry-forward/$id',
        data: data,
      );
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      return Target.fromMap(response.data['data']);
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return null;
    }
  }

  // Leads for teamleader
  Future<PaginationModel<Lead>> getTeamLeaderLeads(
    String id, [
    String query = '',
    int page = 1,
    int limit = 10,
    String? status,
  ]) async {
    try {
      var url = '/leads-team-leader/$id?query=$query&page=$page&limit=$limit';
      if (status != null) {
        url += '&status=$status';
      }

      final Response response = await _dio.get(url);
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        final emptyPagination = PaginationModel<Lead>(
          code: 404,
          message: '',
          page: page,
          limit: limit,
          totalPages: 1,
          totalItems: 0,
          data: [],
        );

        return emptyPagination;
      }

      final List<dynamic> dataList = response.data["data"];

      final List<Lead> leads = dataList.map((data) {
        return Lead.fromJson(data as Map<String, dynamic>);
      }).toList();
      print(response.data["visit2Count"]);
      return PaginationModel<Lead>(
        code: 404,
        message: response.data["message"],
        page: page,
        limit: limit,
        totalPages: response.data["totalPages"],
        totalItems: response.data["totalItems"],
        pendingCount: response.data["pendingCount"],
        visitCount: response.data["visitCount"],
        visit2Count: response.data["visit2Count"],
        revisitCount: response.data["revisitCount"],
        bookingCount: response.data["bookingCount"],
        assignedCount: response.data["assignedCount"],
        followUpCount: response.data["followUpCount"],
        contactedCount: response.data["contactedCount"],
        data: leads,
      );
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return PaginationModel<Lead>(
        code: 500,
        message: e.response?.data['message'] ?? errorMessage,
        page: page,
        limit: limit,
        totalPages: 1,
        totalItems: 0,
        data: [],
      );
    }
  }

  // Leads for teamleader
  Future<PaginationModel<Lead>> getTeamLeaderReportingToLeads(
    String id, [
    String query = '',
    int page = 1,
    int limit = 10,
    String? status,
  ]) async {
    try {
      var url =
          '/leads-team-leader-reporting/$id?query=$query&page=$page&limit=$limit';
      if (status != null) {
        url += '&status=$status';
      }

      final Response response = await _dio.get(url);
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        final emptyPagination = PaginationModel<Lead>(
          code: 404,
          message: '',
          page: page,
          limit: limit,
          totalPages: 1,
          totalItems: 0,
          data: [],
        );

        return emptyPagination;
      }

      final List<dynamic> dataList = response.data["data"];

      final List<Lead> leads = dataList.map((data) {
        return Lead.fromJson(data as Map<String, dynamic>);
      }).toList();

      return PaginationModel<Lead>(
        code: 404,
        message: response.data["message"],
        page: page,
        limit: limit,
        totalPages: response.data["totalPages"],
        totalItems: response.data["totalItems"],
        pendingCount: response.data["pendingCount"],
        visitCount: response.data["visitCount"],
        visit2Count: response.data["visit2Count"],
        revisitCount: response.data["revisitCount"],
        bookingCount: response.data["bookingCount"],
        assignedCount: response.data["assignedCount"],
        followUpCount: response.data["followUpCount"],
        contactedCount: response.data["contactedCount"],
        data: leads,
      );
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return PaginationModel<Lead>(
        code: 500,
        message: e.response?.data['message'] ?? errorMessage,
        page: page,
        limit: limit,
        totalPages: 1,
        totalItems: 0,
        data: [],
      );
    }
  }

  // Leads for pre sales exe
  Future<PaginationModel<Lead>> getPreSalesExecutivesLeads(
    String id, [
    String query = '',
    int page = 1,
    int limit = 10,
    String? status,
  ]) async {
    try {
      var url =
          '/leads-pre-sales-executive/$id?query=$query&page=$page&limit=$limit';
      final Response response = await _dio.get(url);
      if (status != null) {
        url += '&status=$status';
      }
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        final emptyPagination = PaginationModel<Lead>(
          code: 404,
          message: '',
          page: page,
          limit: limit,
          totalPages: 1,
          totalItems: 0,
          data: [],
        );

        return emptyPagination;
      }

      final List<dynamic> dataList = response.data["data"];

      final List<Lead> leads = dataList.map((data) {
        return Lead.fromJson(data as Map<String, dynamic>);
      }).toList();

      return PaginationModel<Lead>(
        code: 404,
        message: response.data["message"],
        page: page,
        limit: limit,
        totalPages: response.data["totalPages"],
        totalItems: response.data["totalItems"],
        pendingCount: response.data["pendingCount"],
        // assignedCount: response.data["assignedCount"],
        followUpCount: response.data["followUpCount"],
        contactedCount: response.data["contactedCount"],
        data: leads,
      );
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return PaginationModel<Lead>(
        code: 500,
        message: e.response?.data['message'] ?? errorMessage,
        page: page,
        limit: limit,
        totalPages: 1,
        totalItems: 0,
        data: [],
      );
    }
  }

  // Leads for pre sales exe
  Future<PaginationModel<PostSaleLead>> getPostSalesExecutivesLeads(
    String id, [
    String query = '',
    int page = 1,
    int limit = 10,
    String? status,
  ]) async {
    try {
      var url =
          '/post-sale-leads-for-pse/$id?query=$query&page=$page&limit=$limit';
      final Response response = await _dio.get(url);
      if (status != null) {
        url += '&status=$status';
      }
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        final emptyPagination = PaginationModel<PostSaleLead>(
          code: 404,
          message: '',
          page: page,
          limit: limit,
          totalPages: 1,
          totalItems: 0,
          data: [],
        );

        return emptyPagination;
      }

      final List<dynamic> dataList = response.data["data"];

      final List<PostSaleLead> leads = dataList.map((data) {
        return PostSaleLead.fromJson(data as Map<String, dynamic>);
      }).toList();

      return PaginationModel<PostSaleLead>(
        code: 404,
        message: response.data["message"],
        page: page,
        limit: limit,
        totalPages: response.data["totalPages"],
        totalItems: response.data["totalItems"],
        // pendingCount: response.data["pendingCount"],
        // assignedCount: response.data["assignedCount"],
        // followUpCount: response.data["followUpCount"],
        // contactedCount: response.data["contactedCount"],
        data: leads,
      );
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return PaginationModel<PostSaleLead>(
        code: 500,
        message: e.response?.data['message'] ?? errorMessage,
        page: page,
        limit: limit,
        totalPages: 1,
        totalItems: 0,
        data: [],
      );
    }
  }

  Future<PaginationModel<SiteVisit>> getClosingManagerSiteVisitById(
    String id, [
    String query = '',
    int page = 1,
    int limit = 10,
    String? status,
  ]) async {
    try {
      // print("pass 0");
      var url =
          '/site-visit-closing-manager/$id?query=$query&page=$page&limit=$limit';
      if (status != null) {
        url += '&status=$status';
      }

      // print("pass 1");

      final Response response = await _dio.get(url);
      // print("pass 2");
      // print(response.data);

      final Map<String, dynamic> data = response.data;
      // print("pass 3");

      if (response.data["code"] != 200) {
        final emptyPagination = PaginationModel<SiteVisit>(
          code: 404,
          message: '',
          page: page,
          limit: limit,
          totalPages: 1,
          totalItems: 0,
          data: [],
        );

        return emptyPagination;
      }
      // print("pass 4");

      final items = data['data'] as List<dynamic>? ?? [];
      // print("pass 5");

      List<SiteVisit> siteVisitsList = [];
      if (items.isNotEmpty) {
        siteVisitsList = items.map((emp) => SiteVisit.fromMap(emp)).toList();
      }
      // print("pass 6");

      final newPagination = PaginationModel<SiteVisit>(
        code: data['code'],
        message: data['message'],
        page: data['page'],
        limit: data['limit'],
        totalPages: data['totalPages'],
        totalItems: data['totalItems'],
        data: siteVisitsList,
      );

      return newPagination;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return PaginationModel<SiteVisit>(
        code: 500,
        message: e.response?.data['message'] ?? errorMessage,
        page: page,
        limit: limit,
        totalPages: 1,
        totalItems: 0,
        data: [],
      );
    }
  }

  Future<List<Employee>> getPreSalesExecutives(String tlId) async {
    try {
      final Response response = await _dio.get(
        '/employee-pre-sale-executive?id=$tlId',
      );

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final List<dynamic> dataList = response.data["data"];

      final List<Employee> employees = dataList.map((data) {
        return Employee.fromMap(data);
      }).toList();
      return employees;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<List<int>> getCarryForwardOptions(String tlId) async {
    try {
      final Response response = await _dio.get(
        '/get-carry-forward-opt/$tlId',
      );

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final dataList = response.data["data"];
      return (dataList as List).map((e) => (e as num).toInt()).toList();
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  // Leads
  Future<String?> leadApproveAndAssignTL(
    String id,
    String teamLeaderId, [
    String remark = "Approved",
  ]) async {
    try {
      final Response response = await _dio.post(
        '/lead-assign-tl/$id',
        data: {
          "teamLeaderId": teamLeaderId,
          "remark": remark,
        },
      );
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);

      // final Map<String, dynamic> data2 = response.data["data"];
      // final Lead lead = Lead.fromJson(data2);
      return response.data['message'];
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return null;
    }
  }

  // Leads
  Future<String?> leadRejectByDataAnalyzer(
    String id, [
    String remark = "rejected",
  ]) async {
    try {
      final Response response = await _dio.post(
        '/lead-reject/$id',
        data: {
          "remark": remark,
        },
      );
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);

      return response.data['message'];
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return null;
    }
  }

  // Leads
  Future<String?> leadAssignToPreSaleExecutive(
    String id,
    String assignTo, [
    String remark = "assigned",
  ]) async {
    try {
      final Response response = await _dio.post(
        '/lead-assign-pre-sale-executive/$id',
        data: {
          "remark": remark,
          "assignTo": assignTo,
        },
      );
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      return response.data['message'];
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return null;
    }
  }

  Future<Lead?> preSaleExecutiveLead(String id, [remarks = "Approved"]) async {
    try {
      final Response response = await _dio.post(
        '/leads-pre-sales-executive/$id',
        data: {"remarks": remarks},
      );
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      final Map<String, dynamic> data2 = response.data["data"];
      final Lead lead = Lead.fromJson(data2);
      return lead;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return null;
    }
  }

  // Similar Leads
  Future<List<Lead>> getSimilarLeads(String id) async {
    try {
      final Response response = await _dio.get('/similar-leads/$id');

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final List<dynamic> dataList = response.data["data"];

      final List<Lead> leads = dataList.map((data) {
        return Lead.fromJson(data as Map<String, dynamic>);
      }).toList();

      return leads;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);

      return [];
    }
  }

  Future<PaginationModel<SiteVisit>> searchSiteVisits(
      [String query = '',
      int page = 1,
      int limit = 10,
      String status = "all"]) async {
    try {
      final Response response = await _dio.get(
        '/siteVisits-search?query=$query&page=$page&limit=$limit&status=$status',
      );
      final Map<String, dynamic> data = response.data;
      if (response.data["code"] != 200) {
        final emptyPagination = PaginationModel<SiteVisit>(
          code: 404,
          message: '',
          page: page,
          limit: limit,
          totalPages: 1,
          totalItems: 0,
          data: [],
        );

        return emptyPagination;
      }
      final items = data['data'] as List<dynamic>? ?? [];
      List<SiteVisit> siteVisitsList = [];
      if (items.isNotEmpty) {
        siteVisitsList = items.map((emp) => SiteVisit.fromMap(emp)).toList();
      }
      final newPagination = PaginationModel<SiteVisit>(
        code: data['code'],
        message: data['message'],
        page: data['page'],
        limit: data['limit'],
        totalPages: data['totalPages'],
        totalItems: data['totalItems'],
        data: siteVisitsList,
      );

      return newPagination;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      final emptyPagination = PaginationModel<SiteVisit>(
        code: 404,
        message: '',
        page: page,
        limit: limit,
        totalPages: 1,
        totalItems: 0,
        data: [],
      );

      return emptyPagination;
    }
  }

  Future<Customer?> registerCustomerAndSiteVisit(
      BuildContext context, Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(
        '/client-register',
        data: data,
        // cancelToken: loginCancelToken,
      );
      if (response.data['code'] == 200) {
        Helper.showCustomSnackBar(response.data['message'], Colors.green);
      }
      Helper.showCustomSnackBar(response.data['message']);
      final Response response2 = await _dio.post(
        '/siteVisits-add',
        data: data,
      );

      if (response2.data['code'] == 200) {
        Helper.showCustomSnackBar(response2.data['message'], Colors.green);
      }
      Helper.showCustomSnackBar(response2.data['message']);

      return null;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<List<OurProject>> getOurProject() async {
    try {
      final Response response = await _dio.get('/ourProjects');
      final List<dynamic> dataList = response.data["data"];
      final List<OurProject> ourProject = dataList.map((data) {
        return OurProject.fromJson(data as Map<String, dynamic>);
      }).toList();
      return ourProject;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<UploadFile?> uploadFile(File file) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final Response response = await _dio.post(
        '/upload',
        data: formData,
        onSendProgress: (sent, total) {
          // Optionally handle progress
        },
      );

      if (response.statusCode != 200) {
        // Handle non-200 status codes
        Helper.showCustomSnackBar(response.data["message"]);
        return null;
      }

      final data = response.data;
      return UploadFile.fromMap(data);
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);

      return null;
    }
  }

  Future<List<UploadFile>> uploadMultipleFile(List<File> files) async {
    try {
      FormData formData = FormData();
      for (var file in files) {
        formData.files.add(MapEntry(
          "files", // This should match the key used in the server-side code
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ));
      }

      final Response response = await _dio.post(
        '/uploads',
        data: formData,
        onSendProgress: (sent, total) {
          // setState(() {
          //   _progress = sent / total;
          //   // Update progress
          // });
        },
      );

      if (response.data["code"] != 200) {
        Helper.showCustomSnackBar(response.data["message"]);
      }

      final List<dynamic> dataList = response.data["data"];
      final List<UploadFile> uploads = dataList.map((data) {
        return UploadFile.fromMap(data);
      }).toList();

      return uploads;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<SiteVisit?> addSiteVisit(Map<String, dynamic> data) async {
    try {
      final Response response2 = await _dio.post(
        '/siteVisits-add',
        data: data,
      );
      if (response2.data['code'] != 200) {
        Helper.showCustomSnackBar(response2.data['message']);
        return null;
      }
      Helper.showCustomSnackBar(response2.data['message'], Colors.green);

      return SiteVisit.fromMap(response2.data['code']);
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<SiteVisit?> updateSiteVisit(
      String id, Map<String, dynamic> data) async {
    try {
      final Response response2 = await _dio.post(
        '/siteVisit-update/$id',
        data: data,
      );
      if (response2.data['code'] != 200) {
        Helper.showCustomSnackBar(response2.data['message']);
        return null;
      }
      Helper.showCustomSnackBar(response2.data['message'], Colors.green);

      return SiteVisit.fromMap(response2.data['code']);
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  //
  // division
  Future<void> saveOneSignalId(
    String id,
    String role,
    String playerId,
  ) async {
    try {
      // final Response response =
      await _dio.post('/save-player-id', data: {
        "docId": id,
        "role": role,
        "playerId": playerId,
      });
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }
      // Helper.showCustomSnackBar(errorMessage);
    }
  }

  Future<List<Employee>> getTeamLeaders() async {
    try {
      final Response response = await _dio.get('/employee-team-leader');
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final Map<String, dynamic> data = response.data;
      final items = data['data'] as List<dynamic>? ?? [];

      List<Employee> empItems = [];
      if (items.isNotEmpty) {
        empItems = items.map((emp) => Employee.fromMap(emp)).toList();
      }

      return empItems;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<List<Employee>> getReportingToEmps(String rId) async {
    try {
      final Response response = await _dio.get('/employee-reporting/$rId');

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final Map<String, dynamic> data = response.data;
      final items = data['data'] as List<dynamic>? ?? [];

      List<Employee> empItems = [];
      if (items.isNotEmpty) {
        empItems = items.map((emp) => Employee.fromMap(emp)).toList();
      }

      return empItems;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<Task?> addTask(String assigneId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/assign-task/$assigneId', data: data);

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }

      Helper.showCustomSnackBar(response.data['message'], Colors.green);

      final parsedTarget = Task.fromMap(response.data['data']);
      return parsedTarget;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<String?> sendCustomNotification(Map<String, dynamic> data) async {
    try {
      print("req start");
      final response = await _dio.post('/send-notification', data: data);
      print("req done");

      if (response.data['code'] != 200) {
        print(" 200 code error");
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      print("req done");

      Helper.showCustomSnackBar(response.data['message'], Colors.green);

      final parsedTarget = response.data['message'];
      return parsedTarget;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }
      print(e);

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<Task?> updateTask(String taskId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/update-task/$taskId', data: data);

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }

      final parsedTarget = Task.fromMap(response.data['data']);
      return parsedTarget;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  // Leads
  Future<List<String>> getReuirements() async {
    try {
      final Response response = await _dio.get('/requirements');

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }

      final List<dynamic> dataList = response.data["data"];

      final List<String> leads = dataList.map((data) {
        return data['requirement'] as String;
      }).toList();
      return leads;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<void> initServer() async {
    try {
      // final Response response =
      await _dio.get('/ping');
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }
      // Helper.showCustomSnackBar(errorMessage);
    }
  }

  Future<Target?> addTarget(String id) async {
    try {
      final response = await _dio.post('/add-target', data: {
        "staffId": id,
      });

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }

      final parsedTarget = Target.fromMap(response.data['data']);
      return parsedTarget;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<Target?> getMyTarget(String id) async {
    try {
      final response = await _dio.get('/get-target/$id');

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }

      final parsedTarget = Target.fromMap(response.data['data']);
      return parsedTarget;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<Map<String, dynamic>?> forgotPasswordEmployee(String email) async {
    try {
      // loginCancelToken?.cancel("duplicate request cancelled");
      // loginCancelToken = CancelToken();
      final Response response = await _dio.post(
        '/employee-forgot-password',
        data: {
          "email": email,
        },
        // cancelToken: loginCancelToken,
      );

      if (response.data['code'] != 200 && response.data['data'] == null) {
        Helper.showCustomSnackBar(response.data['message']);

        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      return response.data['data'];

      //
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<Map<String, dynamic>?> resetPasswordEmployee(
      String email, String otp, String newPassword) async {
    try {
      // loginCancelToken?.cancel("duplicate request cancelled");
      // loginCancelToken = CancelToken();
      final Response response = await _dio.post(
        '/employee-reset-password',
        data: {
          "email": email,
          "otp": otp,
          "password": newPassword,
        },
        // cancelToken: loginCancelToken,
      );

      if (response.data['code'] != 200 && response.data['data'] == null) {
        Helper.showCustomSnackBar(response.data['message']);

        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      return response.data['data'];

      //
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<List<TeamSection>> getTeamSections() async {
    try {
      final Response response = await _dio.get('/team-sections');
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final Map<String, dynamic> data = response.data;
      final items = data['data'] as List<dynamic>? ?? [];

      List<TeamSection> empItems = [];
      if (items.isNotEmpty) {
        empItems = items.map((emp) => TeamSection.fromMap(emp)).toList();
      }

      return empItems;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }
      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<List<Employee>> getSeniorClosingManagers() async {
    try {
      final Response response = await _dio.get('/employee-closing-manager-s');
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      final Map<String, dynamic> data = response.data;
      final items = data['data'] as List<dynamic>? ?? [];
      List<Employee> empItems = [];
      if (items.isNotEmpty) {
        empItems = items.map((emp) => Employee.fromMap(emp)).toList();
      }

      return empItems;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';
      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<Otp?> sentOtpSiteVisit(Map<String, dynamic> data) async {
    try {
      // loginCancelToken?.cancel("duplicate request cancelled");
      // loginCancelToken = CancelToken();
      final Response response = await _dio.post(
        '/site-visit-generate-otp',
        data: data,
      );

      if (response.data['code'] != 200 && response.data['data'] == null) {
        Helper.showCustomSnackBar(response.data['message']);

        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      return Otp.fromMap(response.data['data']);
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }
      print(e);

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<bool> verifySiteVisitOtp(
    String phoneNumber,
    String otp, [
    String? email,
  ]) async {
    try {
      // loginCancelToken?.cancel("duplicate request cancelled");
      // loginCancelToken = CancelToken();
      final Response response = await _dio.post(
        '/site-visit-otp-verify',
        data: {
          "otp": otp,
          "phoneNumber": phoneNumber,
          "email": email,
        },
      );

      if (response.data['code'] != 200 && response.data['data'] == null) {
        Helper.showCustomSnackBar(response.data['message']);

        return false;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);
      return true;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return false;
    }
  }

  //Attendance
  Future<Attendance?> checkInAttendance(Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post('/check-in', data: data);
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);

      // return null;
      return Attendance.fromJson(response.data['data']);
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<Attendance?> getCheckInAttendance(String id) async {
    try {
      final Response response = await _dio.get('/get-check-in/$id');
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      // Helper.showCustomSnackBar(response.data['message'], Colors.green);

      // return null;
      return Attendance.fromJson(response.data['data']);
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  //Attendance
  Future<Attendance?> checkOutAttendance(Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post('/check-out', data: data);
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);

      // return null;
      return Attendance.fromJson(response.data['data']);
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }

  Future<List<Attendance>> getAllAttendanceById(String id) async {
    try {
      final Response response = await _dio.get('/attendance/$id');
      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return [];
      }
      print("pass 200");

      List<Attendance> att = [];
      final data = response.data['data'] as List<dynamic>;
      if (data.isNotEmpty) {
        att = data.map((el) => Attendance.fromJson(el)).toList();
      }
      print(att.length);
      return att;
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        // Backend response error message
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        // Other types of errors (network, etc.)
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return [];
    }
  }

  Future<String?> deleteProject(String id) async {
    try {
      final Response response = await _dio.delete('/ourProjects/$id');

      if (response.data['code'] != 200) {
        Helper.showCustomSnackBar(response.data['message']);
        return null;
      }
      Helper.showCustomSnackBar(response.data['message'], Colors.green);

      return response.data['message'];
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message.toString();
      }

      Helper.showCustomSnackBar(errorMessage);
      return null;
    }
  }
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final accessToken = await storage.read(key: 'accessToken');
      final refreshToken = await storage.read(key: 'refreshToken');
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
      if (refreshToken != null) {
        options.headers['x-refresh-token'] = 'Bearer $refreshToken';
      }
    } catch (e) {
      await storage.deleteAll();
      await SharedPrefService.deleteUser();
    }
    handler.next(options);
  }
}

class _ResponseInterceptor extends Interceptor {
  _ResponseInterceptor();
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final accessToken = response.headers.value('Authorization');
    final refreshToken = response.headers.value('x-refresh-token');
    try {
      if (accessToken != null && accessToken.startsWith('Bearer ')) {
        final newToken = accessToken.split(" ")[1];
        await storage.write(key: "accessToken", value: newToken);
      }
      if (refreshToken != null && refreshToken.startsWith('Bearer ')) {
        final newToken = refreshToken.split(" ")[1];
        await storage.write(key: "refreshToken", value: newToken);
      }
    } catch (e) {
      //
    }
    handler.next(response);
  }
}
