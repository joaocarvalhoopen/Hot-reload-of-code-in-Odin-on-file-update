# Hot reload of code in Odin on file update
This is a simple hot reload of a plugin code file in the Odin programming language.

## Description
This code has 2 shared libraries, one static ( for the file changing monitor ) and one dynamic ( for the hot plugin ). IT has code in C and in Odin.

## Current problems
Currently the code in the last version has a small problem that was introduced when i made a change in the code, but because the day is already very long and because I'm tired I will try to address the bug tomorrow.
The problem is that the update file changed is only working the first time it is made, not the second time.
I suspect that is the reader that is not advancing in the correct amount of bytes, and because of this it dessincronizes. And loses the ability to detect change after the first call to it.

## Important
Before you build this project of this repository, you have to make a directory called the following and copy or move one file to it.

```
$ mkdir plug_dir
$ cp dll_plug_code.odin ./plug_dir/dll_plug_code.odin
```

## How to test this code on Linux

```
1. First clean the code objects previously generated.

   $ make clean

2. Then build all the code objects.

   $ make all

3. Run the program, this will load the ".so" Shared dynamic library in Linux
   ( for the hot plugin code) and the ".a" static library ( for the file change
   in C ).

   $ ./hot_reloadeble_program

4. Now change the code in the "dll_plug_odin.odin" file and save it in VScode
   or emacs or vim.

   $ code dll_plug_odin.odin

5. Now build the "dll_plug_odin.odin" file again.

   $ make dll_plug
 
6. It will update automatically.

7. Now you can see the changes in the program0s output.

```

## License
Mit Open Source

## Have fun
Best regards, <br>
Joao Carvalho