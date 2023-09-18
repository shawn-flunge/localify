# Localify

![Static Badge](https://img.shields.io/badge/pub-beta-blue)

Localify simplifies and accelerates the localization process by seamlessly converting collaboratively sourced data from tools like Google Sheets and Notion into app resource bundles (ARB), making the localization process easier.

## Installation
To use Localify, you need to add it as a dependency in your `pubspec.yaml` file:
```console
dart pub add --dev localify
```

## Configuration
To run Localify, you can create a configuration in two ways: by making a localify.yaml file or by adding configuration to your pubspec.yaml file. Here's an example configuration:

```yaml
localify:
  output_dir: # Specify the directory for output files. The default path is "./assets/i18n"
  output_extension: # Choose either "arb" or "json"
  google_sheets:    
    credential_json_path: # Path to your Google Sheets API credential JSON file
    spread_sheet_id: # ID of the Google Sheet you're working on
    sheet_name: # Name of the sheet you want to parse
  or
  notion_database:
    database_key: # Can find in url
    bearer_token: # Have to generate at https://www.notion.so/my-integrations
```

## Features
After creating the configuration, you can run Localify using the following command:
### generate
The generate command creates files that aid in your localization work. Run the following command to generate the files:
```console
dart run localify generate
```
There's also an option to generate compact files. This can be done using the -c flag:
```console
dart run localify generate -c
```
When using the -c option, your i18n files will be more concise, like this:

Without -c:
```json
"hello": "Hello, {name}",
"@hello": {
    "description": "say hello to 'name' in supported languages",
    "placeholders": {
        "name": {
            "example": "James",
            "type2": "text"
        },
    }
}
```
With -c:
```json
"hello": "Hello, {name}"
```


### check
This feature is coming soon. It will act as a checker, helping you notify key-value pairs that are not used in your project.

### Future Features
- [ ] Add a command `check`