all: mac32 mac64 i386 amd64

init:
	-cd scam-2.4-OSX_32 && wget http://beastie.cs.ua.edu/scam/scam-2.4-OSX_32.tgz
	-cd scam-2.4a-OSX_64 && wget http://beastie.cs.ua.edu/scam/scam-2.4a-OSX_64.tgz
	-cd scam-2.4-i386 && wget http://beastie.cs.ua.edu/scam/scam-2.4-i386.tgz
	-cd scam-2.4a-amd64 && wget http://beastie.cs.ua.edu/scam/scam-2.4a-amd64.tgz

mac32:
	-shasum -a 256 scam-2.4-OSX_32/* > scam-2.4-OSX_32-SHA256SUMS.asc
	-shasum -a 512 scam-2.4-OSX_32/* > scam-2.4-OSX_32-SHA512SUMS.asc

mac64:
	-shasum -a 256 scam-2.4a-OSX_64/* > scam-2.4a-OSX_64-SHA256SUMS.asc
	-shasum -a 512 scam-2.4a-OSX_64/* > scam-2.4a-OSX_64-SHA512SUMS.asc

i386:
	-shasum -a 256 scam-2.4-i386/* > scam-2.4-i386-SHA256SUMS.asc
	-shasum -a 512 scam-2.4-i386/* > scam-2.4-i386-SHA512SUMS.asc

amd64:
	-shasum -a 256 scam-2.4a-amd64/* > scam-2.4a-amd64-SHA256SUMS.asc
	-shasum -a 512 scam-2.4a-amd64/* > scam-2.4a-amd64-SHA512SUMS.asc
