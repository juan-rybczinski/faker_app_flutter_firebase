import * as admin from "firebase-admin"
import * as logger from "firebase-functions/logger"
import * as functions from "firebase-functions/v2"

admin.initializeApp()

export const makeJobTitleUppercase = functions.firestore.onDocumentWritten("/users/{uid}/jobs/{jobId}", (event) => {
  const change = event.data
  if (change === undefined) {
    return
  }

  const data = change.after.data()
  if (data === undefined) {
    return
  }

  const uppercase = data.title.toUpperCase()
  if (uppercase === data.title) {
    return
  }

  logger.log(`Uppercasing ${change.after.ref.path}: ${data.title} => ${uppercase}`)
  return change.after.ref.set({ title: uppercase }, { merge: true })
})

export const deleteAllUserJobs = functions.https.onCall(async (context: functions.https.CallableRequest) => {
  const uid = context.auth?.uid
  if (uid === undefined) {
    throw new functions.https.HttpsError("unauthenticated", "You need to be authenticated to perform this action")
  }
  const firestore = admin.firestore()
  const collectionRef = firestore.collection(`/users/${uid}/jobs`)
  const docRefs = await collectionRef.listDocuments()
  for (const docRef of docRefs) {
    await docRef.delete()
  }
  logger.log(`Deleted ${docRefs.length} docs at ${collectionRef.path}`)
  return { "count": docRefs.length }
})
