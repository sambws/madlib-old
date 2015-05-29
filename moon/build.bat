@ECHO OFF
cd C:\Users\Sam\Documents\love\Game\moon
echo $$BUILD STARTING$$
moonc -t C:\Users\Sam\Documents\love\Game\ *.moon
cd ent
moonc -t C:\Users\Sam\Documents\love\Game\ent *.moon
cd ..
cd lib
moonc -t C:\Users\Sam\Documents\love\Game\lib *.moon
cd ..
echo $$BUILD DONE$$
cls
love --console C:\Users\Sam\Documents\love\Game