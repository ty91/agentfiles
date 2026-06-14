---
name: share-to-theyworks
description: Upload a single HTML file or a static HTML directory to the theyworks-share S3 bucket via the theyworks-share-static-uploader Lambda and return the public URL. Use ONLY WHEN asked to share or publish HTML/static files to Theyworks.
---

# Share to Theyworks

Use this skill only when asked to share or publish an HTML file or static HTML directory to Theyworks.

Lambda URL:

```text
https://4yv7woafpb4gm6anvhpko46lla0cucns.lambda-url.ap-southeast-2.on.aws/
```

## Single HTML File

1. Request a presigned upload URL. This keeps backward-compatible single-file behavior:

```bash
curl -sS -X POST \
  -H 'content-type: application/json' \
  -d '{"key":"theyworks123!@#"}' \
  'https://4yv7woafpb4gm6anvhpko46lla0cucns.lambda-url.ap-southeast-2.on.aws/'
```

2. Save `upload.url`, `upload.headers`, and `url` from the JSON response.

3. Upload the HTML file with the exact headers from `upload.headers`. Do not omit headers returned by the Lambda.

```bash
curl -sS -X PUT \
  -H 'content-type: text/html; charset=utf-8' \
  -H 'cache-control: no-cache' \
  -H 'x-amz-server-side-encryption: AES256' \
  -H 'x-amz-tagging: theyworks-share-public=true' \
  --data-binary '@/path/to/index.html' \
  '<upload.url>'
```

4. Verify the returned public `url` responds with HTTP 200.

5. Give the public `url` to the user.

## Static Directory

Use this when the page needs local CSS, JS, images, fonts, or other assets. The directory must contain `index.html`. Relative references like `./assets/style.css`, `./assets/app.js`, and `./images/logo.png` will work when all files are uploaded under the same generated S3 prefix.

1. Build a relative file list from the directory.

   Exclude hidden/system/generated files by default, for example:

   - paths starting with `.`
   - `.DS_Store`
   - `node_modules/`
   - `.git/`
   - temporary/cache files

   Keep only regular files. Require `index.html` at the directory root.

2. Infer a content type for each file. Common mappings:

   - `.html` -> `text/html; charset=utf-8`
   - `.css` -> `text/css; charset=utf-8`
   - `.js`, `.mjs` -> `application/javascript; charset=utf-8`
   - `.json` -> `application/json; charset=utf-8`
   - `.svg` -> `image/svg+xml`
   - `.png` -> `image/png`
   - `.jpg`, `.jpeg` -> `image/jpeg`
   - `.gif` -> `image/gif`
   - `.webp` -> `image/webp`
   - `.ico` -> `image/x-icon`
   - `.woff` -> `font/woff`
   - `.woff2` -> `font/woff2`

3. Request presigned upload URLs by sending `files`:

```bash
curl -sS -X POST \
  -H 'content-type: application/json' \
  -d '{
    "key":"theyworks123!@#",
    "files":[
      {"path":"index.html","contentType":"text/html; charset=utf-8"},
      {"path":"assets/style.css","contentType":"text/css; charset=utf-8"},
      {"path":"assets/app.js","contentType":"application/javascript; charset=utf-8"},
      {"path":"images/logo.svg","contentType":"image/svg+xml"}
    ]
  }' \
  'https://4yv7woafpb4gm6anvhpko46lla0cucns.lambda-url.ap-southeast-2.on.aws/'
```

4. Save `uploads[]`, `baseUrl`, and `url` from the JSON response.

5. For each item in `uploads[]`, upload the corresponding local file to `item.upload.url` with the exact headers from `item.upload.headers`.

   Required headers currently include:

   - `content-type`
   - `cache-control`
   - `x-amz-server-side-encryption`
   - `x-amz-tagging`

   Example for one file:

```bash
curl -sS -X PUT \
  -H 'content-type: text/css; charset=utf-8' \
  -H 'cache-control: no-cache' \
  -H 'x-amz-server-side-encryption: AES256' \
  -H 'x-amz-tagging: theyworks-share-public=true' \
  --data-binary '@/path/to/site/assets/style.css' \
  '<item.upload.url>'
```

6. Verify the returned public `url` responds with HTTP 200.

7. For directory uploads, also verify important asset URLs respond with HTTP 200 by appending each relative path to `baseUrl`.

8. Give only the public `url` to the user unless they ask for more detail.

## Response Shape

The Lambda returns this shape:

```json
{
  "bucket": "theyworks-share",
  "prefix": "<uuid>",
  "baseUrl": "https://theyworks-share.s3.ap-southeast-2.amazonaws.com/<uuid>/",
  "url": "https://theyworks-share.s3.ap-southeast-2.amazonaws.com/<uuid>/index.html",
  "uploads": [
    {
      "path": "index.html",
      "key": "<uuid>/index.html",
      "s3Uri": "s3://theyworks-share/<uuid>/index.html",
      "url": "https://theyworks-share.s3.ap-southeast-2.amazonaws.com/<uuid>/index.html",
      "upload": {
        "method": "PUT",
        "url": "<presigned-put-url>",
        "expiresIn": 900,
        "headers": {
          "content-type": "text/html; charset=utf-8",
          "cache-control": "no-cache",
          "x-amz-server-side-encryption": "AES256",
          "x-amz-tagging": "theyworks-share-public=true"
        }
      }
    }
  ],
  "key": "<uuid>/index.html",
  "s3Uri": "s3://theyworks-share/<uuid>/index.html",
  "upload": "<same as uploads item for index.html, kept for single-file compatibility>"
}
```
