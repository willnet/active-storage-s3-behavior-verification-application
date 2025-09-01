# ActiveStorage S3 Behavior Verification Application

This application is a sample for verifying ActiveStorage's behavior with S3.
It specifically allows you to test signed URL behavior in public-read buckets and their expiration behavior.

## Setup

### 1. Start MinIO

```bash
# Start MinIO container (public-read bucket "test-bucket" will be created automatically)
docker compose up -d
```

### 2. Start the Application

```bash
bin/setup
```

### 3. Access in Browser

Access http://localhost:3000

## Verifiable Behaviors

### 1. File Upload
- You can upload files from the top page
- Files are stored in MinIO's public-read bucket using ActiveStorage

### 2. URL Behavior Verification

On each file's detail page, you can verify three types of URLs:

#### Regular Signed URL (Default)
```
http://localhost:9000/test-bucket/variants/xxx?X-Amz-Algorithm=...&X-Amz-Expires=300&...
```
- ActiveStorage's default behavior
- Expires in 5 minutes (300 seconds)
- Always accessible within the expiration time

#### Expiring Signed URL (Expires in 1 second)
```
http://localhost:9000/test-bucket/variants/xxx?X-Amz-Algorithm=...&X-Amz-Expires=1&...
```
- URL generated with expires_in: 1.second
- Returns 403 Forbidden when accessed after 1 second

#### Public URL (Without query parameters)
```
http://localhost:9000/test-bucket/variants/xxx
```
- URL with query parameters removed from signed URL
- Accessible via this URL because the bucket is public-read

## Experiment Procedure

1. Upload a file
2. Access the file's detail page
3. Click each URL to verify behavior:
   - **Signed URL**: Can access normally (200 OK)
   - **Expiring URL**: Can access immediately, but returns 403 Forbidden after a few seconds
   - **Public URL**: Always accessible (200 OK, because bucket is public-read)

## Verifiable ActiveStorage Behaviors

### Default Behavior
- ActiveStorage always generates signed URLs and redirects
- Expired signed URLs return 403 Forbidden

### Special Behavior in Public-read Buckets
- Even when signed URLs expire, you can access with 200 OK by removing query parameters
- This is because the bucket is set to public-read

## Technical Details

### MinIO Configuration
- Ports: 9000 (API), 9001 (Console)
- Admin panel: http://localhost:9001 (minioadmin / minioadmin)
- Bucket: test-bucket (public-read)

### ActiveStorage Configuration
- Storage service: minio (config/storage.yml)
- Endpoint: http://localhost:9000
- force_path_style: true (for MinIO compatibility)

## Troubleshooting

### If MinIO won't start
```bash
# Stop and remove containers, then restart
docker compose down
docker compose up -d
```

### If ActiveStorage errors occur
- Verify MinIO is running properly
- Verify bucket is created (can be checked in MinIO Console)
- Verify credentials configuration is correct