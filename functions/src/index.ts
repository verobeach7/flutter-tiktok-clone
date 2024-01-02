// 갓 모드, Firebase의 모든 상황을 감지하여 하고 싶은 것들을 할 수 있음
// 관리자 모드라고 생각하면 됨

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const onVideoCreated = functions.firestore
  .document("videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    // snapshot: 방금 만들어진 영상 의미, ref를 사용하여 실제 document에 접근
    await snapshot.ref.update({ hello: "from functions" });
  });
