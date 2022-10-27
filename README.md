# Bucksapp

[![Pub Package](https://img.shields.io/pub/v/table_calendar.svg?style=flat-square)](https://pub.dev/packages/flutter_bucksapp_sdk)

## Features

* Dashboard
* Transactions
* Budget
* Recurring
* Reports

## Usage

### Installation

Add the following line to `pubspec.yaml`:

```yaml
dependencies:
  flutter_bucksapp_sdk: ^0.0.10
```

### Basic setup

**Bucksapp** requires you to provide `apiKey` and `uuid`

* `apiKey` is an key provided to access the service
* `uuid` is the id of the user for consulting his data.
* `environment` is the environment of the implementation.
* `language` is the language of the implementation of the service.

```dart
Bucksapp(
    apiKey: '<API_KEY>',
    uuid: '<UUID>',
    environment: 'development',
    language: 'en'
)
```
