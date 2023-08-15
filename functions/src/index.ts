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
    return change.after.ref.set({title: uppercase}, {merge: true})
})