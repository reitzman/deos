all: clean clone

mac:
	gcc -O3 -force_cpusubtype_ALL -arch i386 -arch x86_64 master.c ini.c -o rplmaster

linux:
	gcc -O3 master.c ini.c -o rplmaster

clone:
	-git clone git@github.com:desantis/rplmaster.git

clean:
	-rm -rf rplmaster
