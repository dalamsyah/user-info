import 'package:user_info_mobile/data/models/user_model.dart';

class UserListResponseModel {
  final bool status;
  final UserPaginationModel data;

  UserListResponseModel({required this.status, required this.data});

  factory UserListResponseModel.fromJson(Map<String, dynamic> json) {
    return UserListResponseModel(
      status: json['status'],
      data: UserPaginationModel.fromJson(json['data']),
    );
  }
}

class UserPaginationModel {
  final int currentPage;
  final List<UserModel> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<LinkModel> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  UserPaginationModel({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory UserPaginationModel.fromJson(Map<String, dynamic> json) {
    return UserPaginationModel(
      currentPage: json['current_page'],
      data: List<UserModel>.from(
        json['data'].map((x) => UserModel.fromJson(x)),
      ),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: List<LinkModel>.from(
        json['links'].map((x) => LinkModel.fromJson(x)),
      ),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }
}

class LinkModel {
  final String? url;
  final String label;
  final bool active;

  LinkModel({this.url, required this.label, required this.active});

  factory LinkModel.fromJson(Map<String, dynamic> json) {
    return LinkModel(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }
}
