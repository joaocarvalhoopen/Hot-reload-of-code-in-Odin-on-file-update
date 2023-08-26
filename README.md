# Hot reload of code in Odin on file update
This is a simple hot reload of a plugin code file in the Odin programming language.

## Description
This code has 2 shared libraries, one static ( for the file changing monitor ) and one dynamic ( for the hot plugin ). IT has code in C and in Odin.

## Problems
Now there are no problems, it's working fine!

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

5. Now build the "dll_plug_odin.odin" file again (You can do this several times,
   that's the all point of this peace of code! ).

   $ make dll_plug
 
6. It will update automatically.

7. Now you can see the changes in the program0s output.

```

## License
Mit Open Source

## Have fun
Best regards, <br>
Joao Carvalho