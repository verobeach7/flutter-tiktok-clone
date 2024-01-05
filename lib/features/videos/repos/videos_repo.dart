import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class VideosRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // upload a video file: Method
  // uid를 이용하여 storage에 폴더를 만들고 그 안에 동일 사용자의 비디오를 저장
  // 사용자 삭제 시 업로드한 모든 비디오를 한번에 삭제하여 storage를 효율적으로 이용 가능
  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef = _storage.ref().child(
        "/videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}");
    return fileRef.putFile(video);
  }

  // create a video document: Method
  Future<void> saveVideo(VideoModel data) async {
    await _db.collection("videos").add(data.toJson());
  }

  // Map<String, dynamic>: json 포맷으로 되어있음
  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos(
      // named parameter로 설정
      {int? lastItemCreatedAt}) {
    // NoSql은 정렬 먼저 해주고 어디서부터 가져올지를 정해줘야 함
    final query = _db
        .collection("videos")
        .orderBy("createdAt", descending: true)
        // 2개만 불러오도록 제한: 서버 사용을 절약할 수 있음
        .limit(2);
    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }

  Future<void> likeVideo(String videoId, String userId) async {
    /* // 유저가 이미 좋아요를 했는지 아닌지를 확인하기 위해 전체 db를 다 검색해야 함
    // 많은 서버 탐색 비용을 지출해야 함(NoSql의 한계)
    _db
        .collection("likes")
        .where("videoId", isEqualTo: videoId)
        .where("userId", isEqualTo: userId);
    await _db.collection("likes").add(
      {
        "videoId": videoId,
        "userId": userId,
      },
    ); */
    final query = _db.collection("likes").doc("${videoId}000$userId");
    final like = await query.get();

    if (!like.exists) {
      await query.set(
        {
          "createdAt": DateTime.now().millisecondsSinceEpoch,
        },
      );
    }
  }
}

final videosRepo = Provider((ref) => VideosRepository());
