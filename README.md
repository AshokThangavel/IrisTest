# IrisTest - Unit Test Report Generation 🚀

IrisTest is a light weight, powerful, user-friendly tool designed to simplify unit test report generation. It includes an interactive shell 🖥️ and API 🔌 to facilitate communication, allowing developers to easily manage and generate reports for their test runs in various formats. Whether you're debugging or creating detailed reports for analysis, IrisTest makes the process smooth and efficient!

---

## Table of Contents 📝

* [Overview](#overview)
* [Shell Commands](#shell-commands)
* [Usage](#usage)
* [Report Formats](#report-formats)
* [Installation](#installation)
* [Configuration](#configuration)
* [Examples](#examples)
* [Commands](#commands)
* [Contributing](#contributing)
* [License](#license)

---

## Overview 💡

**IrisTest** is a command-line tool that helps you generate detailed unit test reports across multiple formats. With an easy-to-use interactive shell 🖥️ and API support 🔧, you can automate or manually generate various reports and track test case results efficiently.

### Key Features 🌟

* Generate **detailed test reports** in multiple formats 📊
* **Interactive shell** for manual operations 🖥️
* **API** support for automated report generation 🔌
* **Easy configuration** and setup ⚙️
* **History tracking** of executed commands 🕒

---

## Shell Commands 🖥️

IrisTest provides an **interactive shell** where you can easily execute commands to run tests, view results, and manage your test cases.

### Sample Interactive Shell:

```bash
═══════════════════════════════════════════════════════════════════════════════════════════
|| Welcome to iristest shell 0.1.0                                                        ||
|| Enter 'q' or 'quit' to exit the shell. Enter '?' or 'help' to view available commands  ||
||                                                                                        ||
|| ➤ Instance      : IRISHEALTH2025COM                                                    ||
|| ➤ System        : C1V3W44                                                              ||
|| ➤ System Mode   : DEVELOPMENT                                                          ||
|| ➤ Logged in     : _SYSTEM                                                              ||
|| ➤ Session Start : 2025-07-27 13:07:52                                                  ||
═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## Usage 🎯

### Command Syntax 🔧

To run IrisTest, use the following command syntax:

```bash
ziristest [OPTIONS]
```

### Available Options 🎨

* `-i, --id <TestRunID>`: Specify a **unique ID** for the test run (e.g., 40)
* `-o, --output <FORMAT>`: Specify one or more **output formats**. Supported formats:

  * `html` 📄
  * `xml` 🗂️
  * `junitxml` 🏆
  * `allure` ✨
  * `shell` 💻
  * `json` 🧮
  * `csv` 📊
  * `text` 📜
* `-d=<DIR>, --output-dir=<DIR>`: Specify the **directory** to save generated reports (e.g., `/tmp/test` or `C:/test`)

---

## Report Formats 📑

IrisTest supports a variety of output formats, making it flexible for different needs. The available formats include:

* `html` 📄: Detailed, styled HTML report
* `xml` 🗂️: Standard XML format
* `junitxml` 🏆: JUnit-compatible XML report
* `allure` ✨: Allure test report format
* `json` 🧮: JSON formatted results for easy processing
* `csv` 📊: Comma-separated values for simple data export
* `shell` 💻: Simple shell-friendly output
* `text` 📜: Basic plain-text output for simplicity

---

## Installation ⚙️


### Steps 🔄:

1. **Clone the repository**:

   ```bash
   git clone https://github.com/your-username/irisTest.git
   ```

2. **Navigate to the project directory**:

   ```bash
   cd irisTest
   ```

2. **Run the docker compose file**:

   ```bash
   docker compose -f docker-compose.yml up -d --build
   ```

---

## Configuration ⚙️

To configure IrisTest, modify the configuration file or use the `CONFIG` shell command to view/update system details. This includes test run ID specifications, output directories, and more.

Check the system version or shell info using the `INFO` command.

---

## Examples 📌

* **Generate HTML report for test run ID 123**:

  ```bash
  ziristest --id=123 --output=html
  ```

* **Generate multiple formats (HTML, XML, JUnitXML)**:

  ```bash
  ziristest -i=123 -o=html,xml,junitxml
  ```

* **Save reports to a specific directory (`./reports`)**:

  ```bash
  ziristest -i=123 -o=html,xml,junitxml --output-dir=./reports
  ```
* **Predefined he reports to a specific directory (`./reports`)**:

  ```bash
  do ##class(IrisTest.Report.Base).DefineFilePath(pFileType , pFileLocation)
  e.g : do ##class(IrisTest.Report.Base).DefineFilePath("html" , "C:\html\" )
  
  ```
* **Show the report configuration**:

  ```bash
  CONFIG
  ```
* **Clear the shell history**:

  ```bash
  HIST CLEAR
  ```

* **Show test case results for a specific test ID**:

  ```bash
  SHOW 10
  ```

---

## Commands 🛠️

* `CLEAR`: Clear the shell screen 🧹
* `CONFIG`: Show configuration details ⚙️
* `DEL <TestRunID>`: Delete the test case with the specified ID ❌
* `HELP`: Show this help message ℹ️
* `HIST`: View command history 📜
* `INFO`: Display system or shell version info 📅
* `QUIT`: Exit the interactive shell 🚪
* `RUNALL`: Run all available test cases 🏃‍♂️
* `SHOW`: Show detailed results for a specific test run 🔍
* `SHOWALL`: List all unit test results 📋

---

## Contributing 🤝

We welcome contributions! If you'd like to contribute to IrisTest, follow these steps:

1. **Fork the repository** 🍴
2. **Create a new branch** 🌿
3. **Make your changes** ✍️
4. **Submit a pull request** with a description of your changes 🔄

We appreciate bug fixes, enhancements, and feature additions!

---

## License 📜

IrisTest is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for more details.

---

Feel free to explore IrisTest's powerful features, commands, and options! If you run into any issues or have questions, refer to the help section or contact the maintainers. Happy testing! 🚀
