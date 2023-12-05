// To parse this JSON data, do
//
//     final group = groupFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Group groupFromJson(String str) => Group.fromJson(json.decode(str));

String groupToJson(Group data) => json.encode(data.toJson());

class Group {
    Group({
        required this.statusCode,
        required this.groups,
    });

    int statusCode;
    List<GroupElement> groups;

    factory Group.fromJson(Map<String, dynamic> json) => Group(
        statusCode: json["statusCode"],
        groups: List<GroupElement>.from(json["groups"].map((x) => GroupElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "groups": List<dynamic>.from(groups.map((x) => x.toJson())),
    };
}

class GroupElement {
    GroupElement({
        required this.group,
        required this.id,
    });

    String group;
    int id;

    factory GroupElement.fromJson(Map<String, dynamic> json) => GroupElement(
        group: json["group"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "group": group,
        "id": id,
    };
}
