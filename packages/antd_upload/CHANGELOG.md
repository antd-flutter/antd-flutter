# Changelog

## 1.0.0

Initial stable release of the standalone `antd_upload` package.

### Features

- `AntUpload<T>` renders an upload trigger and a generic file list with text, picture, and picture-card presentations.
- Files are supplied by `onSelectFiles`; the component performs no file picking and no network I/O.
- `customRequest` receives each file together with an `updateFile` callback for publishing progress, completion, and errors.
- Controlled `fileList` and uncontrolled `defaultFileList` modes are supported, with `onChange` reporting the changed file and the current list.
- `AntUploadFile<T>` carries `uid`, `name`, status, size, URLs, percentage, response, and a typed `extra` payload; `copyWith` preserves the payload.
- Removal is gated by `onRemove`, which can cancel the operation by returning false; a file marked `removed` leaves the visible list and is ignored by the `maxCount` calculation.
- `maxCount`, `multiple`, `disabled`, and `showUploadList` control selection capacity and interaction.
- `onPreview` exposes row activation, and `itemBuilder` can replace the default row rendering with business-specific content.
- Uploading, done, error, and removed states drive the progress overlay, error icon, and list membership.
- Added the `AntUploadStatus` and `AntUploadListType` enums and the `AntUploadItemBuilder` typedef.
