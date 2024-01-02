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
      // -i: input
      "-i",
      // ffmpeg가 경로를 참조하여 video를 다운로드 함
      video.fileUrl,
      // 영상의 시간대를 움직임
      "-ss",
      "00:00:01.000",
      // 첫 번째 프레임을 가져옴
      "-vframes",
      "1",
      // video filter를 사용하여 이미지 조절
      "-vf",
      // 가로는 150픽셀, 세로(-1)는 영상의 비율에 맞춰서 조정
      "scale=150:-1",
      // 결과물을 어디에 저장할지 설정
      // cloud functions는 임시 저장소를 가지고 있으며, Functions 실행이 끝나면 그 저장소는 삭제됨.
      `/tmp/${snapshot.id}.jpg`,
    ]);
    // 갓 모드: admin을 이용하여 firebase 모든 곳에 접근 가능
    const storage = admin.storage();
    // 임시 저장소에 있는 이미지 썸네일을 storage에 저장
    await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      destination: `thumbnails/${snapshot.id}.jpg`,
    });
  });
