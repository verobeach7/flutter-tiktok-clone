// 갓 모드, Firebase의 모든 상황을 감지하여 하고 싶은 것들을 할 수 있음
// 관리자 모드라고 생각하면 됨

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const onVideoCreated = functions.firestore
  .document("videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    const spawn = require("child-process-promise").spawn;
    // 업로드된 영상의 데이터베이스 데이터를 가져옮
    const video = snapshot.data();
    // ffmpeg와 parameters를 줄 수 있음
    await spawn("ffmpeg", [
      "-i", // -i: input
      video.fileUrl, // ffmpeg가 경로를 참조하여 video를 다운로드 함
      "-ss", // 영상의 시간대를 움직임
      "00:00:01.000",
      "-vframes", // 첫 번째 프레임을 가져옴
      "1",
      "-vf", // video filter를 사용하여 이미지 조절
      "scale=150:-1", // 가로는 150픽셀, 세로(-1)는 영상의 비율에 맞춰서 조정
      `/tmp/${snapshot.id}.jpg`, // 결과물을 어디에 저장할지 설정      // cloud functions는 임시 저장소를 가지고 있으며, Functions 실행이 끝나면 그 저장소는 삭제됨.
    ]);

    // 갓 모드: admin을 이용하여 firebase 모든 곳에 접근 가능
    const storage = admin.storage();
    // 임시 저장소에 있는 이미지 썸네일을 storage에 저장
    // file에만 관심이 있기 때문에 뒤에 것은 '_'로 처리
    const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      destination: `thumbnails/${snapshot.id}.jpg`,
    });

    // file을 공개시킴
    await file.makePublic();
    await snapshot.ref.update({ thumbnailUrl: file.publicUrl() });

    /* db를 불러와서 모든 비디오에서 사용자가 올린 비디오를 다 찾을 수도 있으나
    ** 너무 많은 비디오가 존재하면 이는 서버에 많은 부하를 주게 됨. 
    const db = admin.firestore();
    db.collection("videos").where("creatorUid","==", 123); */

    // 인덱스를 만들어서 유저프로필 페이지에 바로 영상 썸네일이 빠르게 보여질 수 있도록 함
    const db = admin.firestore();
    db.collection("users")
      .doc(video.creatorUid)
      .collection("videos")
      .doc(snapshot.id)
      .set({
        thumbnailUrl: file.publicUrl(),
        videoId: snapshot.id,
      });
  });

export const onLikedCreated = functions.firestore
  .document("likes/{likeId}")
  .onCreate(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, _] = snapshot.id.split("000");
    await db
      .collection("videos")
      .doc(videoId)
      // admin 갓 모드를 사용하여 해당하는 필드의 값을 1 올리라고 명령
      .update({ likes: admin.firestore.FieldValue.increment(1) });
  });

export const onLikedRemoved = functions.firestore
  .document("likes/{likeId}")
  .onDelete(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, _] = snapshot.id.split("000");
    await db
      .collection("videos")
      .doc(videoId)
      // admin 갓 모드를 사용하여 해당하는 필드의 값을 1 올리라고 명령
      .update({ likes: admin.firestore.FieldValue.increment(-1) });
  });
