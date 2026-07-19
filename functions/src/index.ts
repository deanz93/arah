import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

admin.initializeApp()
const db = admin.firestore()

// ── Auto-expire reports ───────────────────────────────────────────
// Runs every 15 minutes — marks expired reports as inactive
export const expireReports = functions.pubsub
  .schedule('every 15 minutes')
  .onRun(async () => {
    const now = admin.firestore.Timestamp.now()

    const expired = await db
      .collection('reports')
      .where('active', '==', true)
      .where('expires_at', '<=', now)
      .get()

    if (expired.empty) return

    const batch = db.batch()
    expired.docs.forEach((doc) => {
      batch.update(doc.ref, { active: false })
    })

    await batch.commit()
    functions.logger.info(`Expired ${expired.size} reports`)
  })

// ── Auto-clear reports voted off ─────────────────────────────────
// Triggered when a report's downvotes field is updated
export const autoRemoveVotedOffReport = functions.firestore
  .document('reports/{reportId}')
  .onUpdate(async (change) => {
    const after = change.after.data()

    // Remove if downvotes exceed upvotes by 3 or more
    if (after.active && after.downvotes - after.upvotes >= 3) {
      await change.after.ref.update({ active: false })
      functions.logger.info(`Report ${change.after.id} removed by community votes`)
    }
  })

// ── Increment user report_count on new report ─────────────────────
export const onReportCreated = functions.firestore
  .document('reports/{reportId}')
  .onCreate(async (snap) => {
    const report = snap.data()
    const userHash = report.user_hash as string

    // We store user_hash (anonymised), so we track by uid in a separate field
    // during creation via the API Gateway (which knows the real uid)
    const uid = report.uid as string | undefined
    if (!uid) return

    await db
      .collection('users')
      .doc(uid)
      .update({
        report_count: admin.firestore.FieldValue.increment(1),
      })
  })
