```markdown
# Disaster Recovery Plan

## Backup Strategy

1. **Cloud SQL**: Automated daily backups with 7-day retention
2. **Cloud Storage**: Versioning enabled for static files bucket
3. **Container Images**: Stored in Container Registry with immutable tags

## Recovery Procedures

### Database Recovery
1. Identify the most recent backup from Cloud SQL backups
2. Create a new instance from backup:
   ```bash
   gcloud sql instances create recovery-instance \
     --backup-instance=original-instance \
     --backup-start-time=YYYY-MM-DDTHH:MM:SSZ
