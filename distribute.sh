# rm -rf distribute

# Source
rm -f distribute/source/shader_toy.love
zip -9 -r -v distribute/source/shader_toy.love . -x *.git* *.sh "distribute/*"
cd distribute/source
rm -f ../shader_toy_source.zip
zip -9 -r -v ../shader_toy_source.zip .
cd ../..

# Windows
rm -f distribute/windows/shader_toy.exe
cat distribute/windows/love.exe distribute/source/shader_toy.love > distribute/windows/shader_toy.exe
cd distribute/windows
rm -f ../shader_toy_windows.zip
zip -9 -r -v ../shader_toy_windows.zip . -x love.exe love.ico
cd ../..

# Linux
rm -f distribute/linux/shader_toy.love
cp distribute/source/shader_toy.love distribute/linux/
cd distribute/linux
rm -f ../shader_toy_linux.zip
zip -9 -r -v ../shader_toy_linux.zip .
cd ../..

# OSX
rm -f distribute/osx/shader_toy.app/Contents/Resources/shader_toy.love
cp distribute/source/shader_toy.love distribute/osx/shader_toy.app/Contents/Resources/
cd distribute/osx
rm -f ../shader_toy_osx.zip
zip -9 -r -v ../shader_toy_osx.zip .
cd ../..
