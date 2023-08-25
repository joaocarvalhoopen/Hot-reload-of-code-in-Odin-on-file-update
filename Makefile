all: main_c_file_monitor dll_plug main_host.odin
	odin build main_host.odin -out:hot_reloadeble_program -file -extra-linker-flags:"-ldl -lrt"

#	odin build main_host.odin main_c_file_monitor.o -out:hot_reloadeble_program -file -extra-linker-flags:"-ldl -lrt"


# This will be hot reloadable
# Generate the shared dynamic library ".so".
dll_plug: plug_dir/dll_plug_code.odin
	odin build ./plug_dir/dll_plug_code.odin  -build-mode:dll -file 

# Generate the object compilation unit.
# Generate the static library ".a".
main_c_file_monitor: main_c_file_monitor.c
	clang -c main_c_file_monitor.c -o main_c_file_monitor.o
	ar rcs main_c_file_monitor.a main_c_file_monitor.o

clean:
	rm main_c_file_monitor.o main_c_file_monitor.a dll_plug_code.so hot_reloadeble_program

# How to call this:
#
# 1. First clean the code objects previously generated.
#
#    $ make clean
#
# 2. Then build the all the code objects.
#
#    $ make all
#
# 3. Run the program, this will load the ".so" Shared dynamic library in Linux.
#
#   $ ./hot_reloadeble_program
#
# 4. Now change the code in the "dll_plug_odin.odin" file and save it in VScode
#    or emacs or vim.
#
#   $ code dll_plug_odin.odin
#
# 5. Now build the "dll_plug_odin.odin" file again.
#
#  $ make dll_plug
#
# 6. Now press a key in the program to reload the code, or wait for a call back
#    the Linux OS to see if a file was changed.
#    In the simpler case wait for the program timer to reload again the code.
#
# 7. Now you can see the changes in the program.
#
