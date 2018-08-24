all: reinit

clone:
	-cd ../ext/ && rm -rf jk2mv
	-cd ../ext/ && git clone git@github.com:desantis/jk2mv.git

init:
	-mv ../ext/jk2mv/assets assets
	-mv ../ext/jk2mv/build build
	-mv ../ext/jk2mv/libs libs
	-mv ../ext/jk2mv/res res
	-mv ../ext/jk2mv/src src
	-mv ../ext/jk2mv/tools tools
	-mv ../ext/jk2mv/.editorconfig .editorconfig
	-mv ../ext/jk2mv/.gitignore .gitignore
	-mv ../ext/jk2mv/.gitmodules .gitmodules
	-mv ../ext/jk2mv/.travis.yml .travis.yml
	-mv ../ext/jk2mv/appveyor.yml appveyor.yml
	-mv ../ext/jk2mv/CMakeLists.txt CMakeLists.txt
	-mv ../ext/jk2mv/CVARS.rst CVARS.rst
	-mv ../ext/jk2mv/LICENSE LICENSE.txt
	-mv ../ext/jk2mv/README.md README.md

reinit: init
	-rm -rf assets build libs res src tools
	-rm .editorconfig .gitignore .gitmodules .travis.yml appveyor CMakeLists.txt CVARS.rst LICENSE.txt README.md
