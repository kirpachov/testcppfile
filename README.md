# Competitive Programming fast test

This is a simple script to test a competitive programming solution with multiple inputs and outputs.

## Project structure
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
```bash
# Clone the repository
# Enter the repository folder
chmod +x testcppfile.rb && sudo ln -s "$(pwd)/testcppfile.rb" /usr/bin/testcppfile
```

## Usage
### Basics
```bash
testcppfile <cpp_file> <input_folder> <output_folder>
```

### Options
To see all the command-line options update, use the `-h` option.
```bash
testcppfile -h
```

### One input, one output
```bash
testcppfile project_dir/logic.cpp project_dir/input.txt project_dir/output.txt
```

### Multiple inputs, multiple outputs
```bash
testcppfile project_dir/logic.cpp project_dir/inputs project_dir/outputs
```

### Compile options
```bash
testcppfile project_dir/logic.cpp project_dir/inputs project_dir/outputs -c "-O2 -std=c++17"
```

### Watch for changes
```bash
testcppfile logic.cpp inputs outputs -w
```