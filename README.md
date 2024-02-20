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

## Getting started

Give the file permissions to execute.
```bash
chmod +x testcppfile.rb
```

## Usage example

```bash
./testcppfile.rb spec/fixtures/donothing/donothing.cpp -w
```

## Options
```bash
./testcppfile.rb -h
```