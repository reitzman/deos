all: clean clone init mvsdk sdl2 buildit

buildit:
	-mv ext/mvsdk/.git src/mvsdk/.git
	-mv ext/jk2mv/.git .git
	cd build && cmake -G "Unix Makefiles" -DUseInternalLibs=ON -DBuildPortableVersion=ON ../.
	cd build && make
	cd build && make package
	-rm -rf src/mvsdk/.git .git

sdl2:
	-cd ext && rm -rf sdl2
	-cd ext && mkdir sdl2
	-cd ext/sdl2 && curl -O https://www.libsdl.org/release/SDL2-2.0.8.tar.gz
	-cd ext/sdl2 && tar xzf SDL2-2.0.8.tar.gz
	-cd ext/sdl2/SDL2-2.0.8/Xcode/SDL && sed -i -e 's/@rpath//g' SDL.xcodeproj/project.pbxproj
	-cd ext/sdl2/SDL2-2.0.8/Xcode/SDL && xcodebuild -configuration Release

mvsdk:
	-mv ext/mvsdk/build src/mvsdk/build
	-mv ext/mvsdk/cmake src/mvsdk/cmake
	-mv ext/mvsdk/code src/mvsdk/code
	-mv ext/mvsdk/tools src/mvsdk/tools
	-mv ext/mvsdk/.editorconfig src/mvsdk/.editorconfig
	-mv ext/mvsdk/.gitignore src/mvsdk/.gitignore
	-mv ext/mvsdk/CMakeLists.txt src/mvsdk/CMakeLists.txt
	-mv ext/mvsdk/LICENSE.txt src/mvsdk/LICENSE.txt
	-mv ext/mvsdk/README-raven.txt src/mvsdk/README-raven.txt
	-mv ext/mvsdk/README.md src/mvsdk/README.md

clone:
	-cd ext/ && rm -rf jk2mv libzt mvsdk
	-cd ext/ && git clone git@github.com:desantis/jk2mv.git
	-cd ext/ && git clone git@github.com:desantis/libzt.git
	-cd ext/ && git clone git@github.com:desantis/mvsdk.git

init:
	-mv ext/jk2mv/assets assets
	-mv ext/jk2mv/build build
	-mv ext/jk2mv/libs libs
	-mv ext/jk2mv/res res
	-mv ext/jk2mv/src src
	-mv ext/jk2mv/tools tools
	-mv ext/jk2mv/.editorconfig .editorconfig
	-mv ext/jk2mv/.gitignore .gitignore
	-mv ext/jk2mv/.travis.yml .travis.yml
	-mv ext/jk2mv/appveyor.yml appveyor.yml
	-mv ext/jk2mv/CMakeLists.txt CMakeLists.txt
	-mv ext/jk2mv/CVARS.rst CVARS.rst

clean:
	-rm -rf assets build libs res src tools
	-rm .editorconfig .gitignore .gitmodules .travis.yml appveyor.yml
	-rm CMakeLists.txt CVARS.rst
