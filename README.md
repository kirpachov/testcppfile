# Test cpp file

Script to test a cpp file with multiple inputs and outputs.

> Note: Runs only on Linux, requires g++ and ruby.

    .
    ├── ...
    ├── project_dir            # Root of the project
    │   ├── inputs             # Folder with inputs
    │   │   ├── input0.txt
    │   │   ├── input1.txt
    │   │   └── ...
    │   ├── outputs           # Folder with expected outputs
    │   │   ├── output0.txt
    │   │   ├── output1.txt
    │   │   └── ...
    │   └── logic.cpp         # File to compile and test for each input and output
    └── ...

## Installation

Give the file permissions to execute and create a symbolic link to the file in /usr/bin.
```bash
chmod +x testcppfile.rb && sudo ln -s "$(pwd)/testcppfile.rb" /usr/bin/testcppfile
```

## Usage example

```bash
./testcppfile.rb spec/fixtures/donothing/donothing.cpp -w
```

## Options
```bash
./testcppfile.rb -h
```