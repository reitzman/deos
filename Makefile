all:
	clone

port: clone init clone

clone:
	cd ext && make

init:
	-mv ext/jk2mv/assets jk2client/assets
	-mv ext/jk2mv/build jk2client/build
	-mv ext/jk2mv/libs jk2client/libs
	-mv ext/jk2mv/res jk2client/res
	-mv ext/jk2mv/src jk2client/src
	-mv ext/jk2mv/tools jk2client/tools
	-mv ext/jk2mv/.editorconfig jk2client/.editorconfig
	-mv ext/jk2mv/.gitignore jk2client/.gitignore
	-mv ext/jk2mv/.gitmodules jk2client/.gitmodules
	-mv ext/jk2mv/.travis.yml jk2client/.travis.yml
	-mv ext/jk2mv/appveyor.yml jk2client/appveyor.yml
	-mv ext/jk2mv/CMakeLists.txt jk2client/CMakeLists.txt
	-mv ext/jk2mv/CVARS.rst jk2client/CVARS.rst
	-mv ext/jk2mv/LICENSE jk2client/LICENSE.txt
	-mv ext/jk2mv/README.md jk2client/README.md
