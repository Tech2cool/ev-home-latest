class PaginationModel<T> {
  final int code;
  final String message;
  final int page;
  final int limit;
  final int totalPages;
  final int totalItems;
  final int pendingCount;
  final int contactedCount;
  final int followUpCount;
  final int assignedCount;
  final int registrationDone;
  final int eoiRecieved;
  final int cancelled;
  final int revenue;
  final int approvedCount;
  final int rejectedCount;
  final int visitCount;
  final int revisitCount;
  final int bookingCount;
  final List<T> data;

  PaginationModel({
    required this.code,
    required this.message,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalItems,
    required this.data,
    this.pendingCount = 0,
    this.contactedCount = 0,
    this.followUpCount = 0,
    this.assignedCount = 0,
    this.registrationDone = 0,
    this.eoiRecieved = 0,
    this.cancelled = 0,
    this.revenue = 0,
    this.approvedCount = 0,
    this.rejectedCount = 0,
    this.visitCount = 0,
    this.revisitCount = 0,
    this.bookingCount = 0,
  });
}
