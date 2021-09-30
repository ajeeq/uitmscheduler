// To parse this JSON data, do
//
//     final detail = detailFromJson(jsonString);

import 'dart:convert';

Detail detailFromJson(String str) => Detail.fromJson(json.decode(str));

String detailToJson(Detail data) => json.encode(data.toJson());

class Detail {
    Detail({
        required this.details,
    });

    List<DetailElement> details;

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        details: List<DetailElement>.from(json["details"].map((x) => DetailElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
    };
}

class DetailElement {
    DetailElement({
        required this.campus,
        required this.course,
        required this.group,
        required this.start,
        required this.end,
        required this.day,
        required this.mode,
        required this.status,
        required this.room,
    });

    String campus;
    String course;
    String group;
    String start;
    String end;
    String day;
    String mode;
    String status;
    String room;

    factory DetailElement.fromJson(Map<String, dynamic> json) => DetailElement(
        campus: json["campus"],
        course: json["course"],
        group: json["group"],
        start: json["start"],
        end: json["end"],
        day: json["day"],
        mode: json["mode"],
        status: json["status"],
        room: json["room"],
    );

    Map<String, dynamic> toJson() => {
        "campus": campus,
        "course": course,
        "group": group,
        "start": start,
        "end": end,
        "day": day,
        "mode": mode,
        "status": status,
        "room": room,
    };
}
